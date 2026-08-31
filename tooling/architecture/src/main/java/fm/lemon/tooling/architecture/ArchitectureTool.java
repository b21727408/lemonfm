package fm.lemon.tooling.architecture;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import com.networknt.schema.Error;
import com.networknt.schema.Schema;
import com.networknt.schema.SchemaRegistry;
import com.networknt.schema.SpecificationVersion;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

public final class ArchitectureTool {
    private static final ObjectMapper YAML = new ObjectMapper(new YAMLFactory());
    private static final ObjectMapper JSON =
            new ObjectMapper().enable(SerializationFeature.INDENT_OUTPUT);
    private static final Pattern SUMMARY =
            Pattern.compile("<!-- agent-summary -->(.*?)<!-- /agent-summary -->", Pattern.DOTALL);
    private static final Pattern LAW =
            Pattern.compile(
                    "<!-- agent-law:id=([a-z0-9.-]+) -->(.*?)<!-- /agent-law -->",
                    Pattern.DOTALL);
    private static final Pattern VERSIONED_DEPENDENCY =
            Pattern.compile("(?:implementation|api|compileOnly|runtimeOnly|testImplementation|testRuntimeOnly)\\s*\\(\\s*\"[^\"]+:[^\"]+:[^\"]+\"");

    private final Path root;
    private final JsonNode modules;

    private ArchitectureTool(Path root) throws IOException {
        this.root = root;
        this.modules = YAML.readTree(root.resolve("architecture/modules.yaml").toFile());
    }

    public static void main(String[] arguments) throws Exception {
        Path root = findRoot(Path.of("").toAbsolutePath());
        ArchitectureTool tool = new ArchitectureTool(root);
        String command = arguments.length == 0 ? "validate" : arguments[0];
        String scope = arguments.length < 2 ? "all" : arguments[1];

        switch (command) {
            case "validate" -> tool.validate();
            case "generate" -> {
                tool.validate();
                tool.writeGenerated();
            }
            case "check" -> tool.check(scope);
            default -> throw new IllegalArgumentException("Unknown architecture command: " + command);
        }
    }

    private static Path findRoot(Path start) {
        Path candidate = start;
        while (candidate != null) {
            if (Files.isRegularFile(candidate.resolve("architecture/modules.yaml"))) {
                return candidate;
            }
            candidate = candidate.getParent();
        }
        throw new IllegalStateException("Cannot locate repository root from " + start);
    }

    private void check(String scope) throws Exception {
        validate();
        if (scope.equals("all") || scope.equals("policy")) {
            checkRepositoryPolicy();
        }
        if (scope.equals("all") || scope.equals("generated")) {
            checkGenerated();
        }
        if (!Set.of("all", "policy", "generated").contains(scope)) {
            throw new IllegalArgumentException("Unknown architecture check scope: " + scope);
        }
    }

    private void validate() throws IOException {
        validateSchema();
        validateBackendRelationships();
        validateFlutterRelationships();
        System.out.println("architecture/modules.yaml: schema and semantics valid");
    }

    private void validateSchema() throws IOException {
        JsonNode schemaDocument =
                JSON.readTree(root.resolve("architecture/modules.schema.json").toFile());
        SchemaRegistry registry =
                SchemaRegistry.withDefaultDialect(SpecificationVersion.DRAFT_2020_12);
        Schema schema = registry.getSchema(schemaDocument);
        List<Error> errors = schema.validate(modules);
        if (!errors.isEmpty()) {
            List<String> messages = errors.stream().map(Object::toString).sorted().toList();
            throw new IllegalStateException(
                    "architecture/modules.yaml failed schema validation:\n  - "
                            + String.join("\n  - ", messages));
        }
    }

    private void validateBackendRelationships() {
        JsonNode backend = modules.path("backend");
        Set<String> moduleNames = fieldNames(backend);
        Set<String> schemas = new HashSet<>();
        Map<String, Set<String>> calls = new TreeMap<>();
        Map<String, String> publishers = new HashMap<>();
        Set<String> consumedEvents = new HashSet<>();

        backend.fields()
                .forEachRemaining(
                        entry -> {
                            String module = entry.getKey();
                            JsonNode definition = entry.getValue();
                            String schema = definition.path("schema").asText();
                            if (!schemas.add(schema)) {
                                fail("Database schema is owned more than once: " + schema);
                            }
                            Set<String> targets = new LinkedHashSet<>();
                            definition.path("calls")
                                    .forEach(
                                            call -> {
                                                String raw = call.asText();
                                                String target = raw.substring(0, raw.length() - ".api".length());
                                                if (!moduleNames.contains(target)) {
                                                    fail(module + " calls unknown module " + raw);
                                                }
                                                targets.add(target);
                                            });
                            calls.put(module, targets);

                            definition.path("publishes")
                                    .forEach(
                                            event -> {
                                                String previous = publishers.put(event.asText(), module);
                                                if (previous != null) {
                                                    fail(
                                                            "Event "
                                                                    + event.asText()
                                                                    + " is published by both "
                                                                    + previous
                                                                    + " and "
                                                                    + module);
                                                }
                                            });
                        });

        backend.fields()
                .forEachRemaining(
                        entry -> {
                            String subscriber = entry.getKey();
                            entry.getValue()
                                    .path("subscribes")
                                    .fields()
                                    .forEachRemaining(
                                            subscription -> {
                                                String publisher = subscription.getKey();
                                                if (!moduleNames.contains(publisher)) {
                                                    fail(
                                                            subscriber
                                                                    + " subscribes to unknown module "
                                                                    + publisher);
                                                }
                                                subscription.getValue()
                                                        .forEach(
                                                                event -> {
                                                                    String actualPublisher =
                                                                            publishers.get(event.asText());
                                                                    if (!publisher.equals(actualPublisher)) {
                                                                        fail(
                                                                                subscriber
                                                                                        + " subscribes to "
                                                                                        + publisher
                                                                                        + "."
                                                                                        + event.asText()
                                                                                        + " but it is published by "
                                                                                        + actualPublisher);
                                                                    }
                                                                    consumedEvents.add(event.asText());
                                                                });
                                            });
                        });

        publishers.forEach(
                (event, publisher) -> {
                    if (!consumedEvents.contains(event)) {
                        fail(publisher + " publishes orphan event " + event);
                    }
                });
        assertAcyclic(calls);
    }

    private void validateFlutterRelationships() {
        JsonNode flutter = modules.path("flutter");
        Set<String> packages = fieldNames(flutter.path("packages"));
        Set<String> features = fieldNames(flutter.path("features"));

        flutter.path("packages")
                .fields()
                .forEachRemaining(
                        entry ->
                                validateDependencies(
                                        "package " + entry.getKey(),
                                        entry.getValue().path("dependencies"),
                                        packages,
                                        Set.of()));
        flutter.path("features")
                .fields()
                .forEachRemaining(
                        entry ->
                                validateDependencies(
                                        "feature " + entry.getKey(),
                                        entry.getValue().path("dependencies"),
                                        packages,
                                        Set.of()));
        Set<String> appTargets = new HashSet<>(packages);
        appTargets.addAll(features);
        flutter.path("apps")
                .fields()
                .forEachRemaining(
                        entry ->
                                validateDependencies(
                                        "app " + entry.getKey(),
                                        entry.getValue().path("dependencies"),
                                        appTargets,
                                        Set.of("all_features")));
    }

    private static void validateDependencies(
            String owner, JsonNode dependencies, Set<String> valid, Set<String> aliases) {
        dependencies.forEach(
                dependency -> {
                    String name = dependency.asText();
                    if (!valid.contains(name) && !aliases.contains(name)) {
                        fail(owner + " depends on unknown package " + name);
                    }
                });
    }

    private static void assertAcyclic(Map<String, Set<String>> graph) {
        Set<String> complete = new HashSet<>();
        Set<String> active = new LinkedHashSet<>();
        Deque<String> path = new ArrayDeque<>();
        for (String node : graph.keySet()) {
            visit(node, graph, complete, active, path);
        }
    }

    private static void visit(
            String node,
            Map<String, Set<String>> graph,
            Set<String> complete,
            Set<String> active,
            Deque<String> path) {
        if (complete.contains(node)) {
            return;
        }
        if (!active.add(node)) {
            List<String> cycle = new ArrayList<>(path);
            cycle.add(node);
            int start = cycle.indexOf(node);
            fail("Synchronous call cycle: " + String.join(" -> ", cycle.subList(start, cycle.size())));
        }
        path.addLast(node);
        for (String target : graph.getOrDefault(node, Set.of())) {
            visit(target, graph, complete, active, path);
        }
        path.removeLast();
        active.remove(node);
        complete.add(node);
    }

    private void writeGenerated() throws IOException {
        for (Map.Entry<Path, String> output : generatedOutputs().entrySet()) {
            Path path = root.resolve(output.getKey());
            Files.createDirectories(path.getParent());
            Files.writeString(path, output.getValue(), StandardCharsets.UTF_8);
            System.out.println("generated " + root.relativize(path).toString().replace('\\', '/'));
        }
    }

    private void checkGenerated() throws IOException {
        List<String> drift = new ArrayList<>();
        for (Map.Entry<Path, String> output : generatedOutputs().entrySet()) {
            Path path = root.resolve(output.getKey());
            if (!Files.isRegularFile(path)) {
                drift.add(output.getKey() + " is missing");
            } else if (!Files.readString(path, StandardCharsets.UTF_8).equals(output.getValue())) {
                drift.add(output.getKey() + " differs from its authored sources");
            }
        }
        if (!drift.isEmpty()) {
            throw new IllegalStateException("Generated artifact drift:\n  - " + String.join("\n  - ", drift));
        }
        System.out.println("generated artifacts: current");
    }

    private Map<Path, String> generatedOutputs() throws IOException {
        Map<Path, String> outputs = new LinkedHashMap<>();
        String normalized = JSON.writeValueAsString(modules) + "\n";
        outputs.put(Path.of("architecture/generated/modules.json"), normalized);
        outputs.put(Path.of("backend/src/test/resources/generated/modules.json"), normalized);
        outputs.put(Path.of("tooling/generated/flutter-package-graph.json"), flutterGraphJson());
        outputs.put(
                Path.of("packages/lemon_lints/lib/src/generated/module_policy.dart"),
                flutterPolicyDart());
        outputs.put(Path.of("AGENTS.md"), agentsFile());
        return outputs;
    }

    private String flutterGraphJson() throws JsonProcessingException {
        Map<String, Object> graph = new TreeMap<>();
        JsonNode flutter = modules.path("flutter");
        addFlutterUnits(graph, "packages", flutter.path("packages"), Set.of());
        addFlutterUnits(graph, "features", flutter.path("features"), Set.of());
        addFlutterUnits(
                graph,
                "apps",
                flutter.path("apps"),
                fieldNames(flutter.path("features")));
        return JSON.writeValueAsString(graph) + "\n";
    }

    private static void addFlutterUnits(
            Map<String, Object> graph, String kind, JsonNode units, Set<String> allFeatures) {
        units.fields()
                .forEachRemaining(
                        entry -> {
                            List<String> dependencies = new ArrayList<>();
                            entry.getValue()
                                    .path("dependencies")
                                    .forEach(
                                            dependency -> {
                                                if (dependency.asText().equals("all_features")) {
                                                    dependencies.addAll(allFeatures);
                                                } else {
                                                    dependencies.add(dependency.asText());
                                                }
                                            });
                            dependencies.sort(String::compareTo);
                            String prefix = kind.equals("features") ? "packages/features" : kind;
                            Map<String, Object> definition = new LinkedHashMap<>();
                            definition.put("kind", kind);
                            definition.put("dependencies", dependencies);
                            graph.put(prefix + "/" + entry.getKey(), definition);
                        });
    }

    private String flutterPolicyDart() {
        StringBuilder output =
                new StringBuilder("// GENERATED FILE — DO NOT EDIT.\n")
                        .append("// Generated by ./lemon generate from architecture/modules.yaml.\n\n")
                        .append("const Map<String, Set<String>> allowedPackageDependencies = {\n");
        JsonNode flutter = modules.path("flutter");
        Map<String, List<String>> units = new TreeMap<>();
        collectFlutterDependencies(units, flutter.path("packages"), Set.of());
        collectFlutterDependencies(units, flutter.path("features"), Set.of());
        collectFlutterDependencies(
                units, flutter.path("apps"), fieldNames(flutter.path("features")));
        units.forEach(
                (name, dependencies) -> {
                    output.append("  '").append(name).append("': {");
                    for (int index = 0; index < dependencies.size(); index++) {
                        if (index > 0) {
                            output.append(", ");
                        }
                        output.append("'").append(dependencies.get(index)).append("'");
                    }
                    output.append("},\n");
                });
        return output.append("};\n").toString();
    }

    private static void collectFlutterDependencies(
            Map<String, List<String>> units, JsonNode definitions, Set<String> allFeatures) {
        definitions.fields()
                .forEachRemaining(
                        entry -> {
                            List<String> dependencies = new ArrayList<>();
                            entry.getValue()
                                    .path("dependencies")
                                    .forEach(
                                            dependency -> {
                                                if (dependency.asText().equals("all_features")) {
                                                    dependencies.addAll(allFeatures);
                                                } else {
                                                    dependencies.add(dependency.asText());
                                                }
                                            });
                            dependencies.sort(String::compareTo);
                            units.put(entry.getKey(), dependencies);
                        });
    }

    private String agentsFile() throws IOException {
        String template =
                normalize(
                        Files.readString(
                                root.resolve(
                                        "tooling/architecture/src/main/resources/AGENTS.template.md"),
                                StandardCharsets.UTF_8));
        List<Path> documents;
        try (Stream<Path> paths = Files.list(root.resolve("docs"))) {
            documents =
                    paths.filter(path -> path.getFileName().toString().endsWith(".md"))
                            .sorted(Comparator.comparing(path -> path.getFileName().toString()))
                            .toList();
        }

        List<String> summaries = new ArrayList<>();
        Map<String, LawBlock> laws = new LinkedHashMap<>();
        for (Path document : documents) {
            String visible = withoutFencedCode(normalize(Files.readString(document)));
            Matcher summaryMatcher = SUMMARY.matcher(visible);
            while (summaryMatcher.find()) {
                summaries.add(trimOuterNewlines(summaryMatcher.group(1)));
            }
            Matcher lawMatcher = LAW.matcher(visible);
            while (lawMatcher.find()) {
                String id = lawMatcher.group(1);
                LawBlock previous =
                        laws.put(
                                id,
                                new LawBlock(
                                        id,
                                        trimOuterNewlines(lawMatcher.group(2)),
                                        document.getFileName().toString()));
                if (previous != null) {
                    fail("Duplicate agent-law id " + id);
                }
            }
        }
        if (summaries.size() != 1) {
            fail("Expected exactly one agent-summary block, found " + summaries.size());
        }

        StringBuilder lawText = new StringBuilder();
        for (LawBlock law : laws.values()) {
            if (!lawText.isEmpty()) {
                lawText.append("\n\n");
            }
            lawText.append("### `").append(law.id()).append("`\n\n")
                    .append(law.body()).append("\n\n")
                    .append("Source: `").append(law.source()).append("`");
        }
        return template.replace("{{SUMMARY}}", summaries.getFirst())
                .replace("{{LAWS}}", lawText.toString());
    }

    private void checkRepositoryPolicy() throws IOException {
        List<String> violations = new ArrayList<>();
        try (Stream<Path> paths = Files.walk(root)) {
            paths.filter(Files::isRegularFile)
                    .filter(path -> !isIgnored(path))
                    .filter(ArchitectureTool::isPolicyCandidate)
                    .forEach(
                            path -> {
                                String relative = slash(root.relativize(path));
                                try {
                                    String source = Files.readString(path, StandardCharsets.UTF_8);
                                    if (isSourceFile(path)
                                            && !relative.startsWith("docs/")
                                            && !relative.equals("AGENTS.md")
                                            && source.contains("PROVISION" + "AL")) {
                                        violations.add(relative + ": unresolved provisional marker");
                                    }
                                    if (relative.endsWith("build.gradle.kts")
                                            && !relative.startsWith("build-logic/")
                                            && VERSIONED_DEPENDENCY.matcher(source).find()) {
                                        violations.add(relative + ": hardcoded dependency version");
                                    }
                                    if (relative.endsWith("build.gradle.kts")
                                            && !relative.startsWith("build-logic/")
                                            && source.contains("repositories {")) {
                                        violations.add(relative + ": project repository declaration");
                                    }
                                } catch (IOException exception) {
                                    throw new IllegalStateException(exception);
                                }
                            });
        }
        if (!violations.isEmpty()) {
            violations.sort(String::compareTo);
            throw new IllegalStateException(
                    "Repository policy violations:\n  - " + String.join("\n  - ", violations));
        }
        System.out.println("repository policy: valid");
    }

    private boolean isIgnored(Path path) {
        String relative = slash(root.relativize(path));
        return relative.startsWith(".git/")
                || relative.startsWith(".gradle/")
                || relative.startsWith("build/")
                || relative.contains("/.gradle/")
                || relative.contains("/build/")
                || relative.contains("/.dart_tool/");
    }

    private static boolean isPolicyCandidate(Path path) {
        String name = path.getFileName().toString();
        return isSourceFile(path)
                || name.equals("build.gradle.kts")
                || name.equals("pubspec.yaml")
                || name.equals("pubspec.yml");
    }

    private static boolean isSourceFile(Path path) {
        String name = path.getFileName().toString();
        return name.endsWith(".java")
                || name.endsWith(".kt")
                || name.endsWith(".kts")
                || name.endsWith(".dart")
                || name.endsWith(".yaml")
                || name.endsWith(".yml")
                || name.endsWith(".json");
    }

    private static Set<String> fieldNames(JsonNode node) {
        Set<String> names = new LinkedHashSet<>();
        Iterator<String> iterator = node.fieldNames();
        iterator.forEachRemaining(names::add);
        return names;
    }

    private static String withoutFencedCode(String source) {
        StringBuilder visible = new StringBuilder();
        boolean fenced = false;
        for (String line : source.split("\n", -1)) {
            if (line.stripLeading().startsWith("```")) {
                fenced = !fenced;
                visible.append('\n');
            } else if (fenced) {
                visible.append('\n');
            } else {
                visible.append(line).append('\n');
            }
        }
        return visible.toString();
    }

    private static String trimOuterNewlines(String value) {
        return value.replaceFirst("^\\n", "").replaceFirst("\\n$", "");
    }

    private static String normalize(String value) {
        return value.replace("\r\n", "\n").replace('\r', '\n');
    }

    private static String slash(Path path) {
        return path.toString().replace('\\', '/');
    }

    private static void fail(String message) {
        throw new IllegalStateException(message);
    }

    private record LawBlock(String id, String body, String source) {}
}
