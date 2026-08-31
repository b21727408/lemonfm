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
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.HexFormat;
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
    private static final Set<String> HTTP_OPERATIONS =
            Set.of("get", "put", "post", "delete", "options", "head", "patch", "trace");

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
            case "contract-manifest" -> {
                if (scope.equals("generate")) {
                    tool.writeContractManifest();
                } else if (scope.equals("check")) {
                    tool.checkContractManifest();
                } else {
                    throw new IllegalArgumentException("Expected contract-manifest generate|check");
                }
            }
            case "openapi-breaking" -> tool.checkOpenApiCompatibility(scope);
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
        checkContractManifest();
        System.out.println("generated artifacts: current");
    }

    private void writeContractManifest() throws IOException {
        Path path = root.resolve("contracts/generated-bindings.sha256.json");
        Files.createDirectories(path.getParent());
        Files.writeString(path, contractManifest(), StandardCharsets.UTF_8);
        System.out.println("generated contracts/generated-bindings.sha256.json");
    }

    private void checkContractManifest() throws IOException {
        Path path = root.resolve("contracts/generated-bindings.sha256.json");
        if (!Files.isRegularFile(path)) {
            fail("Generated contract manifest is missing; run ./lemon generate");
        }
        String expected = contractManifest();
        String actual = Files.readString(path, StandardCharsets.UTF_8);
        if (!actual.equals(expected)) {
            fail(
                    "Generated contract bindings differ from their authored OpenAPI; run ./lemon generate");
        }
        System.out.println("generated contract bindings: current");
    }

    private String contractManifest() throws IOException {
        Map<String, String> sources = new TreeMap<>();
        sources.put("contracts/http/admin-v1.yaml", sha256(root.resolve("contracts/http/admin-v1.yaml")));
        sources.put("contracts/http/public-v1.yaml", sha256(root.resolve("contracts/http/public-v1.yaml")));

        Map<String, String> outputs = new TreeMap<>();
        addContractOutputHashes(outputs, Path.of("backend/src/generated/openapi/admin"));
        addContractOutputHashes(outputs, Path.of("backend/src/generated/openapi/public"));
        addContractOutputHashes(outputs, Path.of("packages/admin_api_client/lib"));
        addContractOutputHashes(outputs, Path.of("packages/api_client/lib"));
        if (outputs.isEmpty()) {
            fail("Generated contract bindings are missing; run ./lemon generate");
        }

        Map<String, Object> manifest = new LinkedHashMap<>();
        manifest.put("algorithm", "SHA-256");
        manifest.put("authoredSources", sources);
        manifest.put("generatedOutputs", outputs);
        return JSON.writeValueAsString(manifest) + "\n";
    }

    private void addContractOutputHashes(Map<String, String> outputs, Path relativeRoot)
            throws IOException {
        Path directory = root.resolve(relativeRoot);
        if (!Files.isDirectory(directory)) {
            fail("Generated contract output is missing: " + slash(relativeRoot));
        }
        try (Stream<Path> paths = Files.walk(directory)) {
            for (Path path : paths.filter(Files::isRegularFile).sorted().toList()) {
                String relative = slash(root.relativize(path));
                outputs.put(relative, sha256(path));
            }
        }
    }

    private static String sha256(Path path) throws IOException {
        try {
            MessageDigest digest = MessageDigest.getInstance("SHA-256");
            return HexFormat.of().formatHex(digest.digest(Files.readAllBytes(path)));
        } catch (NoSuchAlgorithmException exception) {
            throw new IllegalStateException("SHA-256 is unavailable", exception);
        }
    }

    private void checkOpenApiCompatibility(String baseRef) throws IOException, InterruptedException {
        CommandResult baseCommit = git("rev-parse", "--verify", baseRef + "^{commit}");
        if (baseCommit.exitCode() != 0) {
            fail("Cannot resolve OpenAPI compatibility base " + baseRef + ": " + baseCommit.output());
        }
        for (String specification : List.of("public-v1.yaml", "admin-v1.yaml")) {
            String relative = "contracts/http/" + specification;
            CommandResult baseline = git("show", baseRef + ":" + relative);
            if (baseline.exitCode() != 0) {
                System.out.println(relative + ": no baseline on " + baseRef + " (initial contract)");
                continue;
            }
            JsonNode previous = YAML.readTree(baseline.output());
            JsonNode current = YAML.readTree(root.resolve(relative).toFile());
            compareOpenApi(previous, current, relative);
            System.out.println(relative + ": no breaking changes against " + baseRef);
        }
    }

    private void compareOpenApi(JsonNode previous, JsonNode current, String specification) {
        previous.path("paths")
                .fields()
                .forEachRemaining(
                        pathEntry -> {
                            String path = pathEntry.getKey();
                            JsonNode currentPath = current.path("paths").path(path);
                            if (currentPath.isMissingNode()) {
                                fail(specification + ": removed path " + path);
                            }
                            pathEntry.getValue()
                                    .fields()
                                    .forEachRemaining(
                                            operationEntry -> {
                                                String method = operationEntry.getKey();
                                                if (!HTTP_OPERATIONS.contains(method)) {
                                                    return;
                                                }
                                                JsonNode currentOperation = currentPath.path(method);
                                                if (currentOperation.isMissingNode()) {
                                                    fail(
                                                            specification
                                                                    + ": removed operation "
                                                                    + method.toUpperCase()
                                                                    + " "
                                                                    + path);
                                                }
                                                compareOperation(
                                                        previous,
                                                        current,
                                                        operationEntry.getValue(),
                                                        currentOperation,
                                                        specification
                                                                + " "
                                                                + method.toUpperCase()
                                                                + " "
                                                                + path);
                                            });
                        });
    }

    private void compareOperation(
            JsonNode previousRoot,
            JsonNode currentRoot,
            JsonNode previous,
            JsonNode current,
            String location) {
        compareParameters(
                previousRoot,
                currentRoot,
                previous.path("parameters"),
                current.path("parameters"),
                location);

        JsonNode previousBody = resolve(previousRoot, previous.path("requestBody"));
        if (!previousBody.isMissingNode()) {
            JsonNode currentBody = resolve(currentRoot, current.path("requestBody"));
            if (currentBody.isMissingNode()) {
                fail(location + ": removed request body");
            }
            if (!previousBody.path("required").asBoolean(false)
                    && currentBody.path("required").asBoolean(false)) {
                fail(location + ": made request body required");
            }
            compareContent(
                    previousRoot,
                    currentRoot,
                    previousBody,
                    currentBody,
                    location + " request",
                    true);
        }

        previous.path("responses")
                .fields()
                .forEachRemaining(
                        response -> {
                            JsonNode currentResponse = current.path("responses").path(response.getKey());
                            if (currentResponse.isMissingNode()) {
                                fail(location + ": removed response " + response.getKey());
                            }
                            compareContent(
                                    previousRoot,
                                    currentRoot,
                                    resolve(previousRoot, response.getValue()),
                                    resolve(currentRoot, currentResponse),
                                    location + " response " + response.getKey(),
                                    false);
                        });
    }

    private void compareParameters(
            JsonNode previousRoot,
            JsonNode currentRoot,
            JsonNode previous,
            JsonNode current,
            String location) {
        for (JsonNode parameterNode : previous) {
            JsonNode parameter = resolve(previousRoot, parameterNode);
            String name = parameter.path("name").asText();
            String in = parameter.path("in").asText();
            JsonNode currentParameter = null;
            for (JsonNode candidateNode : current) {
                JsonNode candidate = resolve(currentRoot, candidateNode);
                if (name.equals(candidate.path("name").asText())
                        && in.equals(candidate.path("in").asText())) {
                    currentParameter = candidate;
                    break;
                }
            }
            if (currentParameter == null) {
                fail(location + ": removed " + in + " parameter " + name);
            }
            if (!parameter.path("required").asBoolean(false)
                    && currentParameter.path("required").asBoolean(false)) {
                fail(location + ": made parameter required: " + name);
            }
            compareSchema(
                    previousRoot,
                    currentRoot,
                    parameter.path("schema"),
                    currentParameter.path("schema"),
                    location + " parameter " + name,
                    true,
                    new HashSet<>());
        }
    }

    private void compareContent(
            JsonNode previousRoot,
            JsonNode currentRoot,
            JsonNode previous,
            JsonNode current,
            String location,
            boolean request) {
        previous.path("content")
                .fields()
                .forEachRemaining(
                        media -> {
                            JsonNode currentMedia = current.path("content").path(media.getKey());
                            if (currentMedia.isMissingNode()) {
                                fail(location + ": removed media type " + media.getKey());
                            }
                            compareSchema(
                                    previousRoot,
                                    currentRoot,
                                    media.getValue().path("schema"),
                                    currentMedia.path("schema"),
                                    location + " " + media.getKey(),
                                    request,
                                    new HashSet<>());
                        });
    }

    private void compareSchema(
            JsonNode previousRoot,
            JsonNode currentRoot,
            JsonNode previousNode,
            JsonNode currentNode,
            String location,
            boolean request,
            Set<String> visited) {
        JsonNode previous = resolve(previousRoot, previousNode);
        JsonNode current = resolve(currentRoot, currentNode);
        String visitKey =
                previousNode.path("$ref").asText() + "|" + currentNode.path("$ref").asText();
        if (!visitKey.equals("|") && !visited.add(visitKey)) {
            return;
        }
        if (current.isMissingNode()) {
            fail(location + ": removed schema");
        }
        String previousType = previous.path("type").asText();
        String currentType = current.path("type").asText();
        if (!previousType.isEmpty() && !previousType.equals(currentType)) {
            fail(
                    location
                            + ": narrowed or changed type from "
                            + previousType
                            + " to "
                            + currentType);
        }
        if (previous.path("nullable").asBoolean(false)
                && !current.path("nullable").asBoolean(false)) {
            fail(location + ": removed nullable support");
        }
        Set<String> currentEnums = textValues(current.path("enum"));
        for (String value : textValues(previous.path("enum"))) {
            if (!currentEnums.contains(value)) {
                fail(location + ": removed enum value " + value);
            }
        }

        JsonNode currentProperties = current.path("properties");
        previous.path("properties")
                .fields()
                .forEachRemaining(
                        property -> {
                            JsonNode currentProperty = currentProperties.path(property.getKey());
                            if (currentProperty.isMissingNode()) {
                                fail(location + ": removed property " + property.getKey());
                            }
                            compareSchema(
                                    previousRoot,
                                    currentRoot,
                                    property.getValue(),
                                    currentProperty,
                                    location + "." + property.getKey(),
                                    request,
                                    visited);
                        });
        if (request) {
            Set<String> addedRequired = textValues(current.path("required"));
            addedRequired.removeAll(textValues(previous.path("required")));
            if (!addedRequired.isEmpty()) {
                fail(location + ": added required request properties " + addedRequired);
            }
        }
        if (previous.has("items")) {
            compareSchema(
                    previousRoot,
                    currentRoot,
                    previous.path("items"),
                    current.path("items"),
                    location + "[]",
                    request,
                    visited);
        }
    }

    private static JsonNode resolve(JsonNode root, JsonNode node) {
        if (!node.has("$ref")) {
            return node;
        }
        String reference = node.path("$ref").asText();
        if (!reference.startsWith("#/")) {
            fail("Only local OpenAPI references are supported by the compatibility gate: " + reference);
        }
        JsonNode resolved = root;
        for (String part : reference.substring(2).split("/")) {
            resolved = resolved.path(part.replace("~1", "/").replace("~0", "~"));
        }
        return resolved;
    }

    private static Set<String> textValues(JsonNode array) {
        Set<String> values = new LinkedHashSet<>();
        array.forEach(value -> values.add(value.asText()));
        return values;
    }

    private CommandResult git(String... arguments) throws IOException, InterruptedException {
        List<String> command = new ArrayList<>();
        command.add("git");
        command.addAll(List.of(arguments));
        Process process =
                new ProcessBuilder(command).directory(root.toFile()).redirectErrorStream(true).start();
        String output =
                new String(process.getInputStream().readAllBytes(), StandardCharsets.UTF_8).strip();
        return new CommandResult(process.waitFor(), output);
    }

    private Map<Path, String> generatedOutputs() throws IOException {
        Map<Path, String> outputs = new LinkedHashMap<>();
        String normalized = JSON.writeValueAsString(modules) + "\n";
        outputs.put(Path.of("architecture/generated/modules.json"), normalized);
        outputs.put(Path.of("backend/src/test/resources/generated/modules.json"), normalized);
        outputs.put(
                Path.of("backend/src/test/resources/generated/backend-policy.properties"),
                backendPolicyProperties());
        outputs.put(Path.of("tooling/generated/flutter-package-graph.json"), flutterGraphJson());
        outputs.put(
                Path.of("packages/lemon_lints/lib/src/generated/module_policy.dart"),
                flutterPolicyDart());
        addBackendShells(outputs);
        outputs.put(Path.of("AGENTS.md"), agentsFile());
        return outputs;
    }

    private void addBackendShells(Map<Path, String> outputs) {
        modules.path("backend")
                .fieldNames()
                .forEachRemaining(
                        module -> {
                            Path base =
                                    Path.of("backend/src/main/java/fm/lemon")
                                            .resolve(module);
                            outputs.put(
                                    base.resolve("package-info.java"),
                                    "@org.springframework.modulith.ApplicationModule(displayName = \""
                                            + module
                                            + "\")\n"
                                            + "@org.jspecify.annotations.NullMarked\n"
                                            + "package fm.lemon."
                                            + module
                                            + ";\n");
                            for (String layer :
                                    List.of("api", "application", "domain", "infrastructure")) {
                                String namedInterface =
                                        layer.equals("api")
                                                ? "@org.springframework.modulith.NamedInterface(\"api\")\n"
                                                : "";
                                outputs.put(
                                        base.resolve(layer).resolve("package-info.java"),
                                        namedInterface
                                                + "@org.jspecify.annotations.NullMarked\n"
                                                + "package fm.lemon."
                                                + module
                                                + "."
                                                + layer
                                                + ";\n");
                            }
                        });
    }

    private String backendPolicyProperties() {
        StringBuilder output =
                new StringBuilder("# GENERATED FILE — DO NOT EDIT.\n")
                        .append("# Generated by ./lemon generate from architecture/modules.yaml.\n");
        modules.path("backend")
                .fields()
                .forEachRemaining(
                        entry -> {
                            String module = entry.getKey();
                            JsonNode definition = entry.getValue();
                            List<String> calls = new ArrayList<>();
                            definition.path("calls").forEach(call -> calls.add(call.asText()));
                            calls.sort(String::compareTo);
                            output.append("module.")
                                    .append(module)
                                    .append(".schema=")
                                    .append(definition.path("schema").asText())
                                    .append('\n');
                            output.append("module.")
                                    .append(module)
                                    .append(".calls=")
                                    .append(String.join(",", calls))
                                    .append('\n');
                            definition.path("subscribes")
                                    .fields()
                                    .forEachRemaining(
                                            subscription -> {
                                                List<String> events = new ArrayList<>();
                                                subscription
                                                        .getValue()
                                                        .forEach(event -> events.add(event.asText()));
                                                events.sort(String::compareTo);
                                                output.append("module.")
                                                        .append(module)
                                                        .append(".subscribes.")
                                                        .append(subscription.getKey())
                                                        .append('=')
                                                        .append(String.join(",", events))
                                                        .append('\n');
                                            });
                        });
        return output.toString();
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

    private record CommandResult(int exitCode, String output) {}
}
