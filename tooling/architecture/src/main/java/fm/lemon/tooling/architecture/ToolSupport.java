package fm.lemon.tooling.architecture;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.SerializationFeature;
import com.fasterxml.jackson.dataformat.yaml.YAMLFactory;
import java.nio.file.Path;
import java.util.Iterator;
import java.util.LinkedHashSet;
import java.util.Set;

final class ToolSupport {
  static final ObjectMapper YAML = new ObjectMapper(new YAMLFactory());
  static final ObjectMapper JSON = new ObjectMapper().enable(SerializationFeature.INDENT_OUTPUT);

  private ToolSupport() {}

  static Set<String> fieldNames(JsonNode node) {
    Set<String> names = new LinkedHashSet<>();
    Iterator<String> iterator = node.fieldNames();
    iterator.forEachRemaining(names::add);
    return names;
  }

  static String normalize(String value) {
    return value.replace("\r\n", "\n").replace('\r', '\n');
  }

  static String slash(Path path) {
    return path.toString().replace('\\', '/');
  }

  static void fail(String message) {
    throw new IllegalStateException(message);
  }
}
