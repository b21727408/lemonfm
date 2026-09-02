package fm.lemon.tooling.architecture;

import static fm.lemon.tooling.architecture.ToolSupport.JSON;
import static fm.lemon.tooling.architecture.ToolSupport.YAML;
import static fm.lemon.tooling.architecture.ToolSupport.fail;
import static fm.lemon.tooling.architecture.ToolSupport.fieldNames;
import static fm.lemon.tooling.architecture.ToolSupport.normalize;
import static fm.lemon.tooling.architecture.ToolSupport.slash;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.HexFormat;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.stream.Stream;

final class GeneratedArtifactProducer {
  private final Path root;
  private final JsonNode modules;

  GeneratedArtifactProducer(Path root, JsonNode modules) {
    this.root = root;
    this.modules = modules;
  }

  void write() throws IOException {
    for (Map.Entry<Path, String> output : outputs().entrySet()) {
      Path path = root.resolve(output.getKey());
      Files.createDirectories(path.getParent());
      Files.writeString(path, output.getValue(), StandardCharsets.UTF_8);
      System.out.println("generated " + slash(root.relativize(path)));
    }
  }

  void check() throws IOException {
    List<String> drift = new ArrayList<>();
    for (Map.Entry<Path, String> output : outputs().entrySet()) {
      Path path = root.resolve(output.getKey());
      if (!Files.isRegularFile(path)) {
        drift.add(output.getKey() + " is missing");
      } else if (!Files.readString(path, StandardCharsets.UTF_8).equals(output.getValue())) {
        drift.add(output.getKey() + " differs from its authored sources");
      }
    }
    if (!drift.isEmpty()) {
      fail("Generated artifact drift:\n  - " + String.join("\n  - ", drift));
    }
    checkContractManifest();
    System.out.println("generated artifacts: current");
  }

  void writeContractManifest() throws IOException {
    Path path = root.resolve("contracts/generated-bindings.sha256.json");
    Files.createDirectories(path.getParent());
    Files.writeString(path, contractManifest(), StandardCharsets.UTF_8);
    System.out.println("generated contracts/generated-bindings.sha256.json");
  }

  void checkContractManifest() throws IOException {
    Path path = root.resolve("contracts/generated-bindings.sha256.json");
    if (!Files.isRegularFile(path)) {
      fail("Generated contract manifest is missing; run ./lemon generate");
    }
    if (!Files.readString(path, StandardCharsets.UTF_8).equals(contractManifest())) {
      fail("Generated contract bindings differ from their authored OpenAPI; run ./lemon generate");
    }
    System.out.println("generated contract bindings: current");
  }

  private Map<Path, String> outputs() throws IOException {
    Map<Path, String> outputs = new LinkedHashMap<>();
    String normalized = json(modules);
    outputs.put(Path.of("architecture/generated/modules.json"), normalized);
    outputs.put(Path.of("backend/src/test/resources/generated/modules.json"), normalized);
    outputs.put(
        Path.of("backend/src/test/resources/generated/backend-policy.properties"),
        backendPolicyProperties());
    outputs.put(Path.of("tooling/generated/flutter-package-graph.json"), flutterGraphJson());
    outputs.put(
        Path.of("packages/lemon_lints/lib/src/generated/module_policy.dart"), flutterPolicyDart());
    outputs.put(
        Path.of("packages/lemon_ui/lib/src/generated/tokens.dart"),
        new DesignTokenGenerator(root).generateDart());
    outputs.put(Path.of("contracts/generated/fixture-contracts.json"), contractFixtures());
    addBackendShells(outputs);
    outputs.put(Path.of("AGENTS.md"), new AgentsGenerator(root).generate());
    return outputs;
  }

  private void addBackendShells(Map<Path, String> outputs) {
    modules
        .path("backend")
        .fieldNames()
        .forEachRemaining(
            module -> {
              Path base = Path.of("backend/src/main/java/fm/lemon").resolve(module);
              outputs.put(
                  base.resolve("package-info.java"),
                  "@org.springframework.modulith.ApplicationModule(displayName = \""
                      + module
                      + "\")\n@org.jspecify.annotations.NullMarked\npackage fm.lemon."
                      + module
                      + ";\n");
              for (String layer : List.of("api", "application", "domain", "infrastructure")) {
                String namedInterface =
                    layer.equals("api")
                        ? "@org.springframework.modulith.NamedInterface(\"api\")\n"
                        : "";
                outputs.put(
                    base.resolve(layer).resolve("package-info.java"),
                    namedInterface
                        + "@org.jspecify.annotations.NullMarked\npackage fm.lemon."
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
    JsonNode policies = modules.path("policies");
    JsonNode domain = policies.path("domain_layer");
    JsonNode layers = policies.path("layers");
    JsonNode crossModule = policies.path("cross_module");
    JsonNode apiSignatures = crossModule.path("api_signatures");
    appendProperty(
        output, "policy.crossModule.visibility", crossModule.path("visibility").asText());
    appendProperty(
        output,
        "policy.domain.mayDependOnOtherModules",
        domain.path("may_depend_on_other_modules").asText());
    appendSortedProperty(
        output,
        "policy.domain.forbiddenNamespaces",
        domain.path("forbidden_namespaces").path("java"));
    appendSortedProperty(
        output, "policy.domain.forbiddenCalls", domain.path("forbidden_calls").path("java"));
    appendProperty(output, "policy.layers.order", joinedValues(layers.path("order"), false));
    appendSortedProperty(output, "policy.layers.domainDependsOn", layers.path("domain_depends_on"));
    appendSortedProperty(output, "policy.layers.apiMayDependOn", layers.path("api_may_depend_on"));
    appendSortedProperty(
        output, "policy.layers.apiMayNotDependOn", layers.path("api_may_not_depend_on"));
    appendProperty(
        output, "policy.layers.apiImplementedBy", layers.path("api_implemented_by").asText());
    appendSortedProperty(
        output, "policy.apiSignatures.mayExpose", apiSignatures.path("may_expose"));
    appendSortedProperty(
        output, "policy.apiSignatures.mayNotExpose", apiSignatures.path("may_not_expose"));
    appendProperty(
        output,
        "policy.apiSignatures.ownApiCategory",
        apiSignatures.path("own_api_category").asText());
    appendSortedProperty(
        output,
        "policy.apiSignatures.annotationOnlyTypes",
        apiSignatures.path("annotation_only_types"));
    apiSignatures
        .path("namespace_categories")
        .fields()
        .forEachRemaining(
            entry ->
                appendSortedProperty(
                    output, "policy.apiSignatures.namespace." + entry.getKey(), entry.getValue()));
    modules
        .path("backend")
        .fields()
        .forEachRemaining(
            entry -> {
              String module = entry.getKey();
              JsonNode definition = entry.getValue();
              List<String> calls = new ArrayList<>();
              definition.path("calls").forEach(call -> calls.add(call.asText()));
              calls.sort(String::compareTo);
              output
                  .append("module.")
                  .append(module)
                  .append(".schema=")
                  .append(definition.path("schema").asText())
                  .append('\n')
                  .append("module.")
                  .append(module)
                  .append(".calls=")
                  .append(String.join(",", calls))
                  .append('\n');
              definition
                  .path("subscribes")
                  .fields()
                  .forEachRemaining(
                      subscription -> {
                        List<String> events = new ArrayList<>();
                        subscription.getValue().forEach(event -> events.add(event.asText()));
                        events.sort(String::compareTo);
                        output
                            .append("module.")
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

  private static void appendSortedProperty(StringBuilder output, String key, JsonNode values) {
    appendProperty(output, key, joinedValues(values, true));
  }

  private static void appendProperty(StringBuilder output, String key, String value) {
    output.append(key).append('=').append(value).append('\n');
  }

  private static String joinedValues(JsonNode values, boolean sorted) {
    List<String> result = new ArrayList<>();
    values.forEach(value -> result.add(value.asText()));
    if (sorted) {
      result.sort(String::compareTo);
    }
    return String.join(",", result);
  }

  private String flutterGraphJson() throws JsonProcessingException {
    Map<String, Object> graph = new TreeMap<>();
    JsonNode flutter = modules.path("flutter");
    addFlutterUnits(graph, "packages", flutter.path("packages"), Set.of());
    addFlutterUnits(graph, "features", flutter.path("features"), Set.of());
    addFlutterUnits(graph, "apps", flutter.path("apps"), fieldNames(flutter.path("features")));
    return json(graph);
  }

  private static void addFlutterUnits(
      Map<String, Object> graph, String kind, JsonNode units, Set<String> allFeatures) {
    units
        .fields()
        .forEachRemaining(
            entry -> {
              List<String> dependencies = dependencies(entry.getValue(), allFeatures);
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
            .append("const Set<String> featurePackages = {\n");
    fieldNames(modules.path("flutter").path("features")).stream()
        .sorted()
        .forEach(feature -> output.append("  '").append(feature).append("',\n"));
    output.append("};\n\nconst Map<String, Set<String>> allowedPackageDependencies = {\n");
    JsonNode flutter = modules.path("flutter");
    Map<String, List<String>> units = new TreeMap<>();
    collectFlutterDependencies(units, flutter.path("packages"), Set.of());
    collectFlutterDependencies(units, flutter.path("features"), Set.of());
    collectFlutterDependencies(units, flutter.path("apps"), fieldNames(flutter.path("features")));
    units.forEach(
        (name, dependencies) -> {
          output.append("  '").append(name).append("': {");
          if (dependencies.size() >= 5) {
            output.append('\n');
            dependencies.forEach(
                dependency -> output.append("    '").append(dependency).append("',\n"));
            output.append("  ");
          } else {
            for (int index = 0; index < dependencies.size(); index++) {
              if (index > 0) {
                output.append(", ");
              }
              output.append('\'').append(dependencies.get(index)).append('\'');
            }
          }
          output.append("},\n");
        });
    output.append("};\n\n");
    JsonNode layerPolicy = modules.path("policies").path("flutter_layers");
    appendDartSetMap(output, "allowedOwnLayerImports", layerPolicy, "may_import_own_layers");
    appendDartSetMap(
        output, "allowedLayerWorkspacePackages", layerPolicy, "may_import_workspace_packages");
    appendDartSetMap(
        output, "allowedLayerExternalPackages", layerPolicy, "may_import_external_packages");
    output.append("const Set<String> workspacePackages = {");
    List<String> workspacePackages =
        fieldNames(modules.path("flutter").path("packages")).stream().sorted().toList();
    workspacePackages.forEach(name -> output.append("\n  '").append(name).append("',"));
    output.append("\n};\n\nconst Set<String> forbiddenFeatureVisualImports = {");
    List<String> visualImports = new ArrayList<>();
    layerPolicy
        .path("appearance")
        .path("forbidden_feature_imports")
        .forEach(value -> visualImports.add(value.asText()));
    visualImports.stream()
        .sorted()
        .forEach(value -> output.append("\n  '").append(value).append("',"));
    return output.append("\n};\n").toString();
  }

  private static void appendDartSetMap(
      StringBuilder output, String constantName, JsonNode policy, String field) {
    output.append("const Map<String, Set<String>> ").append(constantName).append(" = {\n");
    for (String layer : List.of("domain", "application", "data", "presentation")) {
      List<String> values = new ArrayList<>();
      policy.path(layer).path(field).forEach(value -> values.add(value.asText()));
      values.sort(String::compareTo);
      output.append("  '").append(layer).append("': {");
      if (values.size() >= 5) {
        output.append('\n');
        values.forEach(value -> output.append("    '").append(value).append("',\n"));
        output.append("  ");
      } else {
        for (int index = 0; index < values.size(); index++) {
          if (index > 0) {
            output.append(", ");
          }
          output.append('\'').append(values.get(index)).append('\'');
        }
      }
      output.append("},\n");
    }
    output.append("};\n\n");
  }

  private static void collectFlutterDependencies(
      Map<String, List<String>> units, JsonNode definitions, Set<String> allFeatures) {
    definitions
        .fields()
        .forEachRemaining(
            entry -> units.put(entry.getKey(), dependencies(entry.getValue(), allFeatures)));
  }

  private static List<String> dependencies(JsonNode definition, Set<String> allFeatures) {
    List<String> dependencies = new ArrayList<>();
    definition
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
    return dependencies;
  }

  private String contractFixtures() throws IOException {
    Map<String, Object> fixtures = new LinkedHashMap<>();
    fixtures.put("public", contractFixture("public-v1.yaml"));
    fixtures.put("admin", contractFixture("admin-v1.yaml"));
    return json(fixtures);
  }

  private Map<String, String> contractFixture(String file) throws IOException {
    JsonNode contract = YAML.readTree(root.resolve("contracts/http").resolve(file).toFile());
    var paths = contract.path("paths").fields();
    while (paths.hasNext()) {
      var path = paths.next();
      if (path.getKey().endsWith("/_contract/fixture")) {
        JsonNode schema =
            path.getValue()
                .path("get")
                .path("responses")
                .path("200")
                .path("content")
                .path("application/json")
                .path("schema");
        JsonNode resolved = schema;
        if (schema.has("$ref")) {
          String name = schema.path("$ref").asText().replace("#/components/schemas/", "");
          resolved = contract.path("components").path("schemas").path(name);
        }
        String fixture = resolved.path("properties").path("fixture").path("enum").get(0).asText();
        Map<String, String> result = new LinkedHashMap<>();
        result.put("path", path.getKey());
        result.put("fixture", fixture);
        return result;
      }
    }
    throw new IllegalStateException(file + ": fixture operation is missing");
  }

  private String contractManifest() throws IOException {
    Map<String, String> sources = new TreeMap<>();
    sources.put(
        "contracts/http/admin-v1.yaml", sha256(root.resolve("contracts/http/admin-v1.yaml")));
    sources.put(
        "contracts/http/public-v1.yaml", sha256(root.resolve("contracts/http/public-v1.yaml")));
    Map<String, String> generated = new TreeMap<>();
    addContractOutputHashes(generated, Path.of("backend/src/generated/openapi/admin"));
    addContractOutputHashes(generated, Path.of("backend/src/generated/openapi/public"));
    addContractOutputHashes(generated, Path.of("packages/admin_api_client/lib"));
    addContractOutputHashes(generated, Path.of("packages/api_client/lib"));
    addContractOutputHashes(generated, Path.of("contracts/generated"));
    Map<String, Object> manifest = new LinkedHashMap<>();
    manifest.put("algorithm", "SHA-256");
    manifest.put("authoredSources", sources);
    manifest.put("generatedOutputs", generated);
    return json(manifest);
  }

  private static String json(Object value) throws JsonProcessingException {
    return normalize(JSON.writeValueAsString(value)) + "\n";
  }

  private void addContractOutputHashes(Map<String, String> outputs, Path relativeRoot)
      throws IOException {
    Path directory = root.resolve(relativeRoot);
    if (!Files.isDirectory(directory)) {
      fail("Generated contract output is missing: " + slash(relativeRoot));
    }
    try (Stream<Path> paths = Files.walk(directory)) {
      for (Path path : paths.filter(Files::isRegularFile).sorted().toList()) {
        if (!path.endsWith("generated-bindings.sha256.json")) {
          outputs.put(slash(root.relativize(path)), sha256(path));
        }
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
}
