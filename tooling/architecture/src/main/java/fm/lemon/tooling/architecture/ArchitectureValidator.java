package fm.lemon.tooling.architecture;

import static fm.lemon.tooling.architecture.ToolSupport.JSON;
import static fm.lemon.tooling.architecture.ToolSupport.YAML;
import static fm.lemon.tooling.architecture.ToolSupport.fail;
import static fm.lemon.tooling.architecture.ToolSupport.fieldNames;
import static fm.lemon.tooling.architecture.ToolSupport.slash;

import com.fasterxml.jackson.databind.JsonNode;
import com.networknt.schema.Error;
import com.networknt.schema.Schema;
import com.networknt.schema.SchemaRegistry;
import com.networknt.schema.SpecificationVersion;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayDeque;
import java.util.ArrayList;
import java.util.Deque;
import java.util.HashMap;
import java.util.HashSet;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.TreeMap;
import java.util.TreeSet;

final class ArchitectureValidator {
  private final Path root;
  private final JsonNode modules;

  ArchitectureValidator(Path root, JsonNode modules) {
    this.root = root;
    this.modules = modules;
  }

  void validate() throws IOException {
    validateSchema();
    validateBackendRelationships();
    validateFlutterRelationships();
    System.out.println("architecture/modules.yaml: schema and semantics valid");
  }

  private void validateSchema() throws IOException {
    JsonNode schemaDocument =
        JSON.readTree(root.resolve("architecture/modules.schema.json").toFile());
    SchemaRegistry registry = SchemaRegistry.withDefaultDialect(SpecificationVersion.DRAFT_2020_12);
    Schema schema = registry.getSchema(schemaDocument);
    List<Error> errors = schema.validate(modules);
    if (!errors.isEmpty()) {
      List<String> messages = errors.stream().map(Object::toString).sorted().toList();
      fail(
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

    backend
        .fields()
        .forEachRemaining(
            entry -> {
              String module = entry.getKey();
              JsonNode definition = entry.getValue();
              String schema = definition.path("schema").asText();
              if (!schemas.add(schema)) {
                fail("Database schema is owned more than once: " + schema);
              }
              Set<String> targets = new LinkedHashSet<>();
              definition
                  .path("calls")
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
              definition
                  .path("publishes")
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

    backend
        .fields()
        .forEachRemaining(
            entry -> {
              String subscriber = entry.getKey();
              entry
                  .getValue()
                  .path("subscribes")
                  .fields()
                  .forEachRemaining(
                      subscription -> {
                        String publisher = subscription.getKey();
                        if (!moduleNames.contains(publisher)) {
                          fail(subscriber + " subscribes to unknown module " + publisher);
                        }
                        subscription
                            .getValue()
                            .forEach(
                                event -> {
                                  String actualPublisher = publishers.get(event.asText());
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
    validateFlutterLayerPolicy(packages);
    flutter
        .path("packages")
        .fields()
        .forEachRemaining(
            entry ->
                validateDependencies(
                    "package " + entry.getKey(),
                    entry.getValue().path("dependencies"),
                    packages,
                    Set.of()));
    flutter
        .path("features")
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
    flutter
        .path("apps")
        .fields()
        .forEachRemaining(
            entry ->
                validateDependencies(
                    "app " + entry.getKey(),
                    entry.getValue().path("dependencies"),
                    appTargets,
                    Set.of("all_features")));
    if (Files.isRegularFile(root.resolve("pubspec.yaml"))) {
      validateFlutterWorkspace(flutter, features);
    }
  }

  private void validateFlutterLayerPolicy(Set<String> packages) {
    Set<String> layers = Set.of("domain", "application", "data", "presentation");
    JsonNode policy = modules.path("policies").path("flutter_layers");
    for (String layer : layers) {
      JsonNode definition = policy.path(layer);
      for (String target : textValues(definition.path("may_import_own_layers"))) {
        if (!layers.contains(target)) {
          fail("Flutter layer " + layer + " allows unknown own layer " + target);
        }
      }
      for (String target : textValues(definition.path("may_import_workspace_packages"))) {
        if (!packages.contains(target)) {
          fail("Flutter layer " + layer + " allows unknown workspace package " + target);
        }
      }
    }
    String appearanceOwner = policy.path("appearance").path("owner").asText();
    if (!packages.contains(appearanceOwner)) {
      fail("Flutter appearance owner is not a declared workspace package: " + appearanceOwner);
    }
  }

  private void validateFlutterWorkspace(JsonNode flutter, Set<String> features) {
    Map<String, Path> expectedMembers = new TreeMap<>();
    addFlutterMemberPaths(expectedMembers, flutter.path("packages"), Path.of("packages"));
    addFlutterMemberPaths(
        expectedMembers, flutter.path("features"), Path.of("packages", "features"));
    addFlutterMemberPaths(expectedMembers, flutter.path("apps"), Path.of("apps"));
    JsonNode workspace;
    try {
      workspace = YAML.readTree(root.resolve("pubspec.yaml").toFile());
    } catch (IOException exception) {
      throw new IllegalStateException("Cannot read root pubspec.yaml", exception);
    }
    Set<String> expectedPaths = new LinkedHashSet<>();
    expectedMembers.values().stream().map(ToolSupport::slash).forEach(expectedPaths::add);
    Set<String> actualPaths = textValues(workspace.path("workspace"));
    if (!expectedPaths.equals(actualPaths)) {
      fail(
          "Dart workspace members differ from architecture/modules.yaml; expected "
              + expectedPaths
              + " but found "
              + actualPaths);
    }

    Set<String> allUnits = expectedMembers.keySet();
    Map<String, Set<String>> expectedDependencies = new TreeMap<>();
    collectFlutterDependencySets(expectedDependencies, flutter.path("packages"), Set.of());
    collectFlutterDependencySets(expectedDependencies, flutter.path("features"), Set.of());
    collectFlutterDependencySets(expectedDependencies, flutter.path("apps"), features);
    expectedMembers.forEach(
        (name, relativePath) -> {
          Path pubspecPath = root.resolve(relativePath).resolve("pubspec.yaml");
          if (!Files.isRegularFile(pubspecPath)) {
            fail("Declared Dart workspace package is missing " + slash(pubspecPath));
          }
          JsonNode pubspec;
          try {
            pubspec = YAML.readTree(pubspecPath.toFile());
          } catch (IOException exception) {
            throw new IllegalStateException(
                "Cannot read " + slash(root.relativize(pubspecPath)), exception);
          }
          String location = slash(root.relativize(pubspecPath));
          if (!name.equals(pubspec.path("name").asText())) {
            fail(location + ": package name must be " + name);
          }
          if (!"workspace".equals(pubspec.path("resolution").asText())) {
            fail(location + ": resolution must be workspace");
          }
          JsonNode declarations = pubspec.path("dependencies");
          Set<String> actualInternal = internalDependencies(declarations, allUnits);
          Set<String> expectedInternal = expectedDependencies.getOrDefault(name, Set.of());
          if (!expectedInternal.equals(actualInternal)) {
            fail(
                location
                    + ": internal dependencies differ from architecture/modules.yaml; expected "
                    + expectedInternal
                    + " but found "
                    + actualInternal);
          }
          Set<String> nonRuntimeInternal = new TreeSet<>();
          nonRuntimeInternal.addAll(
              internalDependencies(pubspec.path("dev_dependencies"), allUnits));
          nonRuntimeInternal.addAll(
              internalDependencies(pubspec.path("dependency_overrides"), allUnits));
          if (!nonRuntimeInternal.isEmpty()) {
            fail(
                location
                    + ": internal workspace dependencies must be declared in dependencies and modules.yaml, not dev_dependencies/dependency_overrides: "
                    + nonRuntimeInternal);
          }
          for (String dependency : expectedInternal) {
            JsonNode declaration = declarations.path(dependency);
            if (!declaration.isObject() || !declaration.has("path")) {
              fail(location + ": " + dependency + " must be a local path dependency");
            }
            Path actual =
                pubspecPath
                    .getParent()
                    .resolve(declaration.path("path").asText())
                    .toAbsolutePath()
                    .normalize();
            Path expected =
                root.resolve(expectedMembers.get(dependency)).toAbsolutePath().normalize();
            if (!actual.equals(expected)) {
              fail(
                  location
                      + ": "
                      + dependency
                      + " path resolves to "
                      + actual
                      + " instead of "
                      + expected);
            }
          }
        });
  }

  private static void addFlutterMemberPaths(
      Map<String, Path> members, JsonNode definitions, Path parent) {
    definitions.fieldNames().forEachRemaining(name -> members.put(name, parent.resolve(name)));
  }

  private static void collectFlutterDependencySets(
      Map<String, Set<String>> units, JsonNode definitions, Set<String> allFeatures) {
    definitions
        .fields()
        .forEachRemaining(
            entry -> {
              Set<String> dependencies = new TreeSet<>();
              entry
                  .getValue()
                  .path("dependencies")
                  .forEach(
                      dependency -> {
                        if (dependency.asText().equals("all_features")) {
                          dependencies.addAll(allFeatures);
                        } else {
                          dependencies.add(dependency.asText());
                        }
                      });
              units.put(entry.getKey(), dependencies);
            });
  }

  private static Set<String> internalDependencies(JsonNode declarations, Set<String> allUnits) {
    Set<String> dependencies = new TreeSet<>();
    declarations
        .fieldNames()
        .forEachRemaining(
            name -> {
              if (allUnits.contains(name)) {
                dependencies.add(name);
              }
            });
    return dependencies;
  }

  private static Set<String> textValues(JsonNode array) {
    Set<String> values = new LinkedHashSet<>();
    array.forEach(value -> values.add(value.asText()));
    return values;
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
}
