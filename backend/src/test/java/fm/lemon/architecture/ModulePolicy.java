package fm.lemon.architecture;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
import java.util.List;
import java.util.Map;
import java.util.Properties;
import java.util.Set;

final class ModulePolicy {
  private final Properties properties;

  private ModulePolicy(Properties properties) {
    this.properties = properties;
  }

  static ModulePolicy load() {
    Properties properties = new Properties();
    try (InputStream input =
        ModulePolicy.class
            .getClassLoader()
            .getResourceAsStream("generated/backend-policy.properties")) {
      if (input == null) {
        throw new IllegalStateException("Generated backend policy is missing");
      }
      properties.load(input);
    } catch (IOException exception) {
      throw new IllegalStateException("Cannot read generated backend policy", exception);
    }
    return new ModulePolicy(properties);
  }

  Set<String> modules() {
    Set<String> modules = new LinkedHashSet<>();
    for (String name : properties.stringPropertyNames()) {
      if (name.startsWith("module.") && name.endsWith(".schema")) {
        modules.add(name.substring("module.".length(), name.length() - ".schema".length()));
      }
    }
    return modules;
  }

  Set<String> calls(String source) {
    return values("module." + source + ".calls");
  }

  String crossModuleVisibleLayer() {
    String visibility = required("policy.crossModule.visibility");
    String suffix = "_only";
    if (!visibility.endsWith(suffix)) {
      throw new IllegalStateException("Unsupported cross-module visibility policy: " + visibility);
    }
    return visibility.substring(0, visibility.length() - suffix.length());
  }

  boolean domainMayDependOnOtherModules() {
    return Boolean.parseBoolean(required("policy.domain.mayDependOnOtherModules"));
  }

  Set<String> domainForbiddenNamespaces() {
    return values("policy.domain.forbiddenNamespaces");
  }

  Set<String> directIoJavaOwnerLayers() {
    return values("policy.directIo.java.ownerLayers");
  }

  Set<String> directIoJavaForbiddenNamespaces() {
    return values("policy.directIo.java.forbiddenNamespaces");
  }

  String externalIoMarker() {
    return required("policy.transactions.externalIoMarker");
  }

  List<String> layerOrder() {
    return List.copyOf(values("policy.layers.order"));
  }

  Set<String> domainDependencies() {
    return values("policy.layers.domainDependsOn");
  }

  Set<String> apiMayDependOn() {
    return values("policy.layers.apiMayDependOn");
  }

  Set<String> apiMayNotDependOn() {
    return values("policy.layers.apiMayNotDependOn");
  }

  String apiImplementedBy() {
    return required("policy.layers.apiImplementedBy");
  }

  Set<String> apiMayExpose() {
    return values("policy.apiSignatures.mayExpose");
  }

  Set<String> apiMayNotExpose() {
    return values("policy.apiSignatures.mayNotExpose");
  }

  String ownApiCategory() {
    return required("policy.apiSignatures.ownApiCategory");
  }

  Set<String> apiAnnotationOnlyTypes() {
    return values("policy.apiSignatures.annotationOnlyTypes");
  }

  Map<String, Set<String>> apiNamespaceCategories() {
    String prefix = "policy.apiSignatures.namespace.";
    Map<String, Set<String>> categories = new LinkedHashMap<>();
    properties.stringPropertyNames().stream()
        .filter(name -> name.startsWith(prefix))
        .sorted()
        .forEach(name -> categories.put(name.substring(prefix.length()), values(name)));
    return categories;
  }

  Set<String> subscriptions(String subscriber, String publisher) {
    return values("module." + subscriber + ".subscribes." + publisher);
  }

  Map<String, String> schemas() {
    Map<String, String> schemas = new LinkedHashMap<>();
    for (String module : modules()) {
      schemas.put(module, properties.getProperty("module." + module + ".schema"));
    }
    return schemas;
  }

  private Set<String> values(String key) {
    String value = properties.getProperty(key, "");
    if (value.isBlank()) {
      return Set.of();
    }
    return new LinkedHashSet<>(Arrays.asList(value.split(",")));
  }

  private String required(String key) {
    String value = properties.getProperty(key);
    if (value == null || value.isBlank()) {
      throw new IllegalStateException("Generated backend policy is missing " + key);
    }
    return value;
  }
}
