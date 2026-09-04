package fm.lemon.tooling.architecture;

import static fm.lemon.tooling.architecture.ToolSupport.fail;
import static fm.lemon.tooling.architecture.ToolSupport.normalize;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

final class AgentsGenerator {
  private static final Pattern SUMMARY =
      Pattern.compile("<!-- agent-summary -->(.*?)<!-- /agent-summary -->", Pattern.DOTALL);
  private static final Pattern LAW =
      Pattern.compile(
          "<!-- agent-law:id=([a-z0-9.-]+) -->(.*?)<!-- /agent-law -->", Pattern.DOTALL);

  private final Path root;

  AgentsGenerator(Path root) {
    this.root = root;
  }

  String generate() throws IOException {
    String template =
        normalize(
            Files.readString(
                root.resolve("tooling/architecture/src/main/resources/AGENTS.template.md"),
                StandardCharsets.UTF_8));
    List<Path> documents;
    try (Stream<Path> paths = Files.list(root.resolve("docs"))) {
      documents =
          paths
              .filter(path -> path.getFileName().toString().endsWith(".md"))
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
                    id, trimOuterNewlines(lawMatcher.group(2)), document.getFileName().toString()));
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
      lawText
          .append("### `")
          .append(law.id())
          .append("`\n\n")
          .append(law.body())
          .append("\n\nSource: `")
          .append(law.source())
          .append('`');
    }
    return template
        .replace("{{SUMMARY}}", summaries.getFirst())
        .replace("{{LAWS}}", lawText.toString());
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

  private record LawBlock(String id, String body, String source) {}
}
