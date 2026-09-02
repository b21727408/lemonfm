package fm.lemon.tooling.architecture;

import static fm.lemon.tooling.architecture.ToolSupport.fail;
import static fm.lemon.tooling.architecture.ToolSupport.slash;

import com.fasterxml.jackson.databind.JsonNode;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.ArrayList;
import java.util.List;
import java.util.Set;
import java.util.TreeSet;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import java.util.stream.Stream;

final class RepositoryPolicy {
  private static final Pattern VERSIONED_DEPENDENCY =
      Pattern.compile(
          "(?:implementation|api|compileOnly|runtimeOnly|testImplementation|testRuntimeOnly)\\s*\\(\\s*\"[^\"]+:[^\"]+:[^\"]+\"");
  private static final Pattern PLUGIN_LINE = Pattern.compile("id\\(\"[A-Za-z0-9_.-]+\"\\)");
  private static final Pattern JAVA_LITERAL =
      Pattern.compile("\"\"\"(.*?)\"\"\"|\"(?:\\\\.|[^\"\\\\])*\"", Pattern.DOTALL);
  private static final Pattern STRING_JOOQ_IDENTIFIER =
      Pattern.compile("\\bDSL\\s*\\.\\s*(?:table|field|name)\\s*\\(\\s*\"");
  private static final Pattern QUOTED_VALUE = Pattern.compile("[\"']([^\"']+)[\"']");
  private static final Pattern DYNAMIC_VERSION =
      Pattern.compile("(?i)(?:latest\\.(?:release|integration)|[^:]*\\+|[^:]*snapshot[^:]*)");
  private static final Pattern GRADLE_PROPERTY =
      Pattern.compile("(?m)^\\s*([^#\\s][^=]*)=(.*?)\\s*$");

  private final Path root;
  private final Set<String> schemas;

  RepositoryPolicy(Path root, JsonNode modules) {
    this.root = root;
    this.schemas = new TreeSet<>();
    modules.path("backend").forEach(module -> schemas.add(module.path("schema").asText()));
    schemas.add("platform");
  }

  void check() throws IOException {
    runPermanentNegativeFixtures();
    List<String> violations = new ArrayList<>();
    try (Stream<Path> paths = Files.walk(root)) {
      paths
          .filter(Files::isRegularFile)
          .filter(path -> !isIgnored(path))
          .filter(RepositoryPolicy::isPolicyCandidate)
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
                  if (isProjectBuild(relative)) {
                    if (VERSIONED_DEPENDENCY.matcher(source).find()) {
                      violations.add(relative + ": hardcoded dependency version");
                    }
                    String buildViolation = projectBuildViolation(source);
                    if (buildViolation != null) {
                      violations.add(relative + ": " + buildViolation);
                    }
                  }
                  if (isAuthoredGradleVersionSurface(relative)) {
                    String dynamicVersion = dynamicVersionViolation(source);
                    if (dynamicVersion != null) {
                      violations.add(relative + ": " + dynamicVersion);
                    }
                  }
                  if (relative.startsWith("backend/src/main/java/") && relative.endsWith(".java")) {
                    String sqlViolation = rawPersistenceViolation(source);
                    if (sqlViolation != null) {
                      violations.add(relative + ": " + sqlViolation);
                    }
                  }
                } catch (IOException exception) {
                  throw new IllegalStateException(exception);
                }
              });
    }
    for (String required :
        List.of(
            "backend/gradle.lockfile",
            "build-logic/gradle.lockfile",
            "tooling/architecture/gradle.lockfile",
            "gradle/verification-metadata.xml",
            "pubspec.lock")) {
      if (!Files.isRegularFile(root.resolve(required))) {
        violations.add(required + ": required dependency integrity file is missing");
      }
    }
    Path verificationMetadata = root.resolve("gradle/verification-metadata.xml");
    if (Files.isRegularFile(verificationMetadata)
        && !Files.readString(verificationMetadata, StandardCharsets.UTF_8)
            .contains("<verify-metadata>true</verify-metadata>")) {
      violations.add("gradle/verification-metadata.xml: metadata verification must be enabled");
    }
    if (!violations.isEmpty()) {
      violations.sort(String::compareTo);
      fail("Repository policy violations:\n  - " + String.join("\n  - ", violations));
    }
    System.out.println("repository policy: valid (permanent negative fixtures passed)");
  }

  void checkAppendOnlyMigrations(String baseRef) throws IOException, InterruptedException {
    Process process =
        new ProcessBuilder(
                "git",
                "diff",
                "--name-status",
                "--find-renames",
                baseRef,
                "--",
                "backend/src/main/resources/db/migration")
            .directory(root.toFile())
            .redirectErrorStream(true)
            .start();
    String output = new String(process.getInputStream().readAllBytes(), StandardCharsets.UTF_8);
    int exit = process.waitFor();
    if (exit != 0) {
      fail("Cannot compare migrations with " + baseRef + ":\n" + output.strip());
    }
    String violation = appendOnlyViolation(output);
    if (violation != null) {
      fail("Existing Flyway migrations are append-only; " + violation);
    }
    System.out.println("Flyway migrations: append-only relative to " + baseRef);
  }

  private void runPermanentNegativeFixtures() throws IOException {
    Path fixtures = root.resolve("tooling/architecture/fixtures/repository-policy");
    expectViolation(
        projectBuildViolation(Files.readString(fixtures.resolve("invalid-project-build.txt"))),
        "plugin list only");
    expectViolation(
        rawPersistenceViolation(Files.readString(fixtures.resolve("raw-cross-schema.txt"))),
        "raw schema-qualified persistence");
    expectViolation(
        appendOnlyViolation(Files.readString(fixtures.resolve("modified-migration.txt"))),
        "append-only migration");
    String invalidVersions = Files.readString(fixtures.resolve("invalid-dynamic-version.txt"));
    for (String declaration : invalidVersions.split("\\R")) {
      if (!declaration.isBlank() && !declaration.startsWith("[")) {
        expectViolation(
            dynamicVersionViolation(declaration), "dynamic Gradle version " + declaration);
      }
    }
    if (projectBuildViolation(Files.readString(fixtures.resolve("valid-project-build.txt")))
        != null) {
      fail("Repository policy positive fixture was rejected");
    }
    if (dynamicVersionViolation(Files.readString(fixtures.resolve("valid-versions.txt"))) != null) {
      fail("Repository policy valid Gradle versions fixture was rejected");
    }
  }

  private static void expectViolation(String violation, String fixture) {
    if (violation == null) {
      fail("Repository policy " + fixture + " fixture did not fail");
    }
  }

  private static String projectBuildViolation(String source) {
    String withoutComments =
        source.replaceAll("(?s)/\\*.*?\\*/", "").replaceAll("(?m)//.*$", "").strip();
    if (!withoutComments.startsWith("plugins")) {
      return "individual project build file must be a plugin list only";
    }
    int open = withoutComments.indexOf('{');
    int close = withoutComments.lastIndexOf('}');
    if (open < 0 || close < open || !withoutComments.substring(close + 1).isBlank()) {
      return "individual project build file must be a plugin list only";
    }
    String prefix = withoutComments.substring(0, open).strip();
    if (!prefix.equals("plugins")) {
      return "individual project build file must be a plugin list only";
    }
    for (String line : withoutComments.substring(open + 1, close).split("\\R")) {
      String declaration = line.strip();
      if (!declaration.isEmpty() && !PLUGIN_LINE.matcher(declaration).matches()) {
        return "individual project build file must be a plugin list only; found `"
            + declaration
            + "`";
      }
    }
    return null;
  }

  private String rawPersistenceViolation(String source) {
    if (STRING_JOOQ_IDENTIFIER.matcher(source).find()) {
      return "string-based jOOQ identifiers are forbidden; use owned generated jOOQ types";
    }
    Matcher literals = JAVA_LITERAL.matcher(source);
    while (literals.find()) {
      String literal = literals.group();
      for (String schema : schemas) {
        if (Pattern.compile("(?i)(^|[^A-Za-z0-9_])" + Pattern.quote(schema) + "\\s*\\.")
            .matcher(literal)
            .find()) {
          return "raw schema-qualified persistence reference `"
              + schema
              + ".` is forbidden; use owned generated jOOQ types";
        }
      }
    }
    return null;
  }

  private static String appendOnlyViolation(String nameStatus) {
    for (String line : nameStatus.split("\\R")) {
      String status = line.strip();
      if (status.matches("^(?:M|D|R[0-9]+|C[0-9]+|T)\\s+.*")) {
        return "modified, deleted, renamed, copied, or type-changed migration: " + status;
      }
    }
    return null;
  }

  private static String dynamicVersionViolation(String source) {
    Matcher values = QUOTED_VALUE.matcher(source);
    while (values.find()) {
      String value = values.group(1).strip();
      String candidate = value;
      int finalColon = candidate.lastIndexOf(':');
      if (finalColon >= 0) {
        candidate = candidate.substring(finalColon + 1);
      }
      if (DYNAMIC_VERSION.matcher(candidate).matches()) {
        return "dynamic Gradle version is forbidden: `" + value + "`";
      }
    }
    Matcher properties = GRADLE_PROPERTY.matcher(source);
    while (properties.find()) {
      String key = properties.group(1).strip();
      String value = properties.group(2).strip();
      String lowerKey = key.toLowerCase();
      String lowerValue = value.toLowerCase();
      if ((lowerKey.contains("version") || lowerKey.equals("distributionurl"))
          && (value.contains("+")
              || lowerValue.contains("latest.release")
              || lowerValue.contains("latest.integration")
              || lowerValue.contains("snapshot"))) {
        return "dynamic Gradle version is forbidden: `" + key + "=" + value + "`";
      }
    }
    return null;
  }

  private boolean isIgnored(Path path) {
    String relative = slash(root.relativize(path));
    return relative.startsWith(".git/")
        || relative.startsWith(".gradle/")
        || relative.startsWith("build/")
        || relative.contains("/.gradle/")
        || relative.contains("/build/")
        || relative.contains("/.dart_tool/")
        || relative.startsWith("tooling/architecture/fixtures/");
  }

  private static boolean isPolicyCandidate(Path path) {
    String name = path.getFileName().toString();
    return isSourceFile(path)
        || name.equals("build.gradle.kts")
        || name.equals("settings.gradle.kts")
        || name.equals("libs.versions.toml")
        || name.equals("gradle.properties")
        || name.equals("gradle-wrapper.properties")
        || name.endsWith(".gradle")
        || name.equals("pubspec.yaml")
        || name.equals("pubspec.yml");
  }

  private static boolean isAuthoredGradleVersionSurface(String relative) {
    return relative.endsWith(".gradle.kts")
        || relative.endsWith(".gradle")
        || relative.endsWith("gradle.properties")
        || relative.equals("gradle/libs.versions.toml")
        || relative.endsWith("gradle-wrapper.properties");
  }

  private static boolean isProjectBuild(String relative) {
    return relative.endsWith("build.gradle.kts")
        && !relative.equals("build.gradle.kts")
        && !relative.startsWith("build-logic/")
        && !relative.startsWith("apps/mobile/android/");
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
}
