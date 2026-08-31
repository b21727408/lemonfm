package fm.lemon.architecture;

import java.io.IOException;
import java.io.InputStream;
import java.util.Arrays;
import java.util.LinkedHashMap;
import java.util.LinkedHashSet;
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
}
