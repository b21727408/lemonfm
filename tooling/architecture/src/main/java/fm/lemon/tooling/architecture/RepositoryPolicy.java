package fm.lemon.tooling.architecture;

import static fm.lemon.tooling.architecture.ToolSupport.fail;
import static fm.lemon.tooling.architecture.ToolSupport.slash;

import com.fasterxml.jackson.databind.JsonNode;
import java.io.IOException;
import java.math.BigDecimal;
import java.math.RoundingMode;
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
  private static final Pattern BUILD_LOGIC_VERSIONED_DEPENDENCY =
      Pattern.compile(
          "(?:implementation|api|compileOnly|runtimeOnly|testImplementation|testRuntimeOnly|testCompileOnly|checkstyle|errorprone)\\s*\\(\\s*(?:(?:enforcedPlatform|platform)\\s*\\(\\s*)?\"[^\"]+:[^\"]+:[^\"]+\"");
  private static final Pattern BUILD_LOGIC_TOOL_VERSION =
      Pattern.compile(
          "googleJavaFormat\\s*\\(\\s*\"[^\"]+\"|toolVersion\\s*=\\s*\"[^\"]+\"|JavaLanguageVersion\\.of\\(\\d+\\)|options\\.release\\s*=\\s*\\d+");
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
  private static final Pattern DIGEST_PINNED_POSTGRES =
      Pattern.compile("(?m)^\\s*image:\\s*postgres:[^\\s@]+@sha256:[0-9a-f]{64}\\s*$");
  private static final Pattern PINNED_WRAPPER_VALIDATION_ACTION =
      Pattern.compile("uses:\\s*gradle/actions/wrapper-validation@[0-9a-f]{40}");

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
    checkTrackedProvisionalMarkers(violations);
    checkProductionContractFixtures(violations);
    checkNativeLaunchSurface(violations);
    checkAndroidWrapper(violations);
    checkAndroidDependencyIntegrity(violations);
    checkBuildLogicCatalogImport(violations);
    checkWrapperValidationWorkflow(violations);
    checkDevelopmentPostgres(violations);
    checkAndroidReleaseSigning(violations);
    checkWebShellSurfaces(violations);
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
                  if (relative.startsWith("build-logic/") && relative.endsWith(".gradle.kts")) {
                    String catalogViolation = buildLogicCatalogViolation(source);
                    if (catalogViolation != null) {
                      violations.add(relative + ": " + catalogViolation);
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
            "apps/mobile/android/app/gradle.lockfile",
            "apps/mobile/android/gradle/verification-metadata.xml",
            "pubspec.lock")) {
      if (!Files.isRegularFile(root.resolve(required))) {
        violations.add(required + ": required dependency integrity file is missing");
      }
    }
    for (String relative :
        List.of(
            "gradle/verification-metadata.xml",
            "apps/mobile/android/gradle/verification-metadata.xml")) {
      Path verificationMetadata = root.resolve(relative);
      if (Files.isRegularFile(verificationMetadata)
          && !Files.readString(verificationMetadata, StandardCharsets.UTF_8)
              .contains("<verify-metadata>true</verify-metadata>")) {
        violations.add(relative + ": metadata verification must be enabled");
      }
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
    expectViolation(
        provisionalViolation(
            "scripts/example.sh", Files.readString(fixtures.resolve("provisional-shell.txt"))),
        "tracked shell provisional marker");
    expectViolation(
        productionContractFixtureViolation(
            Files.readString(fixtures.resolve("production-contract-fixture.txt"))),
        "production contract fixture");
    expectViolation(
        nativeLaunchReferenceViolation(
            Files.readString(fixtures.resolve("invalid-native-launch.txt")), "@color/lemon_bg0"),
        "native launch ground");
    expectViolation(
        androidWrapperViolation(
            Files.readString(fixtures.resolve("android-wrapper-missing-checksum.txt"))),
        "Android wrapper checksum");
    String invalidAndroidIntegrity =
        Files.readString(fixtures.resolve("android-integrity-disabled.txt"));
    expectViolation(
        androidDependencyIntegrityViolation(invalidAndroidIntegrity, invalidAndroidIntegrity),
        "Android dependency locking");
    expectViolation(
        androidDependencyIntegrityViolation(
            "lockAllConfigurations()\nLockMode.STRICT",
            Files.readString(fixtures.resolve("android-verification-disabled.txt"))),
        "Android dependency verification");
    expectViolation(
        buildLogicCatalogViolation(Files.readString(fixtures.resolve("catalog-owned-version.txt"))),
        "catalog-owned build-logic version");
    expectViolation(
        wrapperValidationWorkflowViolation(
            Files.readString(fixtures.resolve("unpinned-wrapper-action.txt"))),
        "unpinned Gradle wrapper validation action");
    String validCompose =
        "image: postgres:18.6@sha256:" + "0".repeat(64) + "\nports:\n  - \"127.0.0.1:5432:5432\"\n";
    String validDev = "docker compose up --detach --wait postgres";
    expectViolation(
        developmentPostgresViolation(
            Files.readString(fixtures.resolve("dev-postgres-mutable-image.txt")), validDev),
        "mutable development PostgreSQL image");
    expectViolation(
        developmentPostgresViolation(
            Files.readString(fixtures.resolve("dev-postgres-exposed-port.txt")), validDev),
        "exposed development PostgreSQL port");
    expectViolation(
        developmentPostgresViolation(
            validCompose, Files.readString(fixtures.resolve("dev-postgres-no-wait.txt"))),
        "development PostgreSQL health wait");
    expectViolation(
        androidReleaseSigningViolation(
            Files.readString(fixtures.resolve("debug-release-signing.txt"))),
        "debug release-signing fallback");
    String invalidWeb = Files.readString(fixtures.resolve("invalid-web-shell.txt"));
    expectViolation(
        webShellViolation(invalidWeb, invalidWeb, invalidWeb, "#050613"), "raw Flutter web shell");
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
    if (buildLogicCatalogViolation(
            Files.readString(fixtures.resolve("catalog-derived-version.txt")))
        != null) {
      fail("Repository policy catalog-derived build-logic fixture was rejected");
    }
    if (provisionalViolation("docs/example.md", "PROVISION" + "AL") != null) {
      fail("Canonical documentation provisional-marker exclusion was rejected");
    }
  }

  private void checkTrackedProvisionalMarkers(List<String> violations) throws IOException {
    Process process =
        new ProcessBuilder("git", "ls-files", "-z")
            .directory(root.toFile())
            .redirectErrorStream(true)
            .start();
    byte[] output = process.getInputStream().readAllBytes();
    int exit;
    try {
      exit = process.waitFor();
    } catch (InterruptedException exception) {
      Thread.currentThread().interrupt();
      throw new IOException("Interrupted while listing tracked repository files", exception);
    }
    if (exit != 0) {
      fail("Cannot list tracked repository files for provisional policy");
    }
    for (String relative : new String(output, StandardCharsets.UTF_8).split("\u0000")) {
      if (relative.isBlank() || !isProvisionalText(relative)) {
        continue;
      }
      Path path = root.resolve(relative);
      if (!Files.isRegularFile(path)) {
        continue;
      }
      String violation =
          provisionalViolation(relative, Files.readString(path, StandardCharsets.UTF_8));
      if (violation != null) {
        violations.add(relative + ": " + violation);
      }
    }
  }

  private void checkProductionContractFixtures(List<String> violations) throws IOException {
    for (String productionRoot :
        List.of(
            "contracts/http",
            "backend/src/main",
            "backend/src/generated/openapi",
            "packages/api_client",
            "packages/admin_api_client")) {
      Path directory = root.resolve(productionRoot);
      if (!Files.isDirectory(directory)) {
        continue;
      }
      try (Stream<Path> paths = Files.walk(directory)) {
        for (Path path :
            paths.filter(Files::isRegularFile).filter(this::isProductionContractText).toList()) {
          String violation =
              productionContractFixtureViolation(Files.readString(path, StandardCharsets.UTF_8));
          if (violation != null) {
            violations.add(slash(root.relativize(path)) + ": " + violation);
          }
        }
      }
    }
  }

  private boolean isProductionContractText(Path path) {
    String relative = slash(root.relativize(path));
    if (relative.contains("/.dart_tool/") || relative.contains("/build/")) {
      return false;
    }
    return isProvisionalText(relative);
  }

  private void checkNativeLaunchSurface(List<String> violations) throws IOException {
    String androidGround = "@color/lemon_bg0";
    for (String relative :
        List.of(
            "apps/mobile/android/app/src/main/res/drawable/launch_background.xml",
            "apps/mobile/android/app/src/main/res/drawable-v21/launch_background.xml",
            "apps/mobile/android/app/src/main/res/values/styles.xml",
            "apps/mobile/android/app/src/main/res/values-night/styles.xml",
            "apps/mobile/android/app/src/main/res/values-v31/styles.xml",
            "apps/mobile/android/app/src/main/res/values-night-v31/styles.xml")) {
      String source = Files.readString(root.resolve(relative), StandardCharsets.UTF_8);
      String violation = nativeLaunchReferenceViolation(source, androidGround);
      if (violation != null) {
        violations.add(relative + ": " + violation);
      }
      if (source.contains("Theme.Light")) {
        violations.add(relative + ": native launch theme must remain dark-only");
      }
    }
    String storyboardPath = "apps/mobile/ios/Runner/Base.lproj/LaunchScreen.storyboard";
    String storyboard = Files.readString(root.resolve(storyboardPath), StandardCharsets.UTF_8);
    String iosReference = "<color key=\"backgroundColor\" name=\"LemonBg0\"/>";
    String violation = nativeLaunchReferenceViolation(storyboard, iosReference);
    if (violation != null) {
      violations.add(storyboardPath + ": " + violation);
    }
    String bg0 =
        ToolSupport.JSON
            .readTree(root.resolve("design/tokens/colors.json").toFile())
            .path("bg0")
            .asText();
    String expectedFallback = iosFallback(bg0);
    if (!storyboard.contains(expectedFallback)) {
      violations.add(storyboardPath + ": LemonBg0 fallback must equal design token bg0");
    }
  }

  private void checkAndroidWrapper(List<String> violations) throws IOException {
    String relative = "apps/mobile/android/gradle/wrapper/gradle-wrapper.properties";
    String violation =
        androidWrapperViolation(Files.readString(root.resolve(relative), StandardCharsets.UTF_8));
    if (violation != null) {
      violations.add(relative + ": " + violation);
    }
  }

  private void checkAndroidDependencyIntegrity(List<String> violations) throws IOException {
    String buildPath = "apps/mobile/android/build.gradle.kts";
    String metadataPath = "apps/mobile/android/gradle/verification-metadata.xml";
    Path metadata = root.resolve(metadataPath);
    if (!Files.isRegularFile(metadata)) {
      return;
    }
    String violation =
        androidDependencyIntegrityViolation(
            Files.readString(root.resolve(buildPath), StandardCharsets.UTF_8),
            Files.readString(metadata, StandardCharsets.UTF_8));
    if (violation != null) {
      violations.add(buildPath + ": " + violation);
    }
  }

  private void checkBuildLogicCatalogImport(List<String> violations) throws IOException {
    String relative = "build-logic/settings.gradle.kts";
    String source = Files.readString(root.resolve(relative), StandardCharsets.UTF_8);
    if (!source.contains("from(files(\"../gradle/libs.versions.toml\"))")) {
      violations.add(relative + ": included build must import the root version catalog");
    }
  }

  private void checkWrapperValidationWorkflow(List<String> violations) throws IOException {
    String relative = ".github/workflows/ci.yml";
    String violation =
        wrapperValidationWorkflowViolation(
            Files.readString(root.resolve(relative), StandardCharsets.UTF_8));
    if (violation != null) {
      violations.add(relative + ": " + violation);
    }
  }

  private void checkDevelopmentPostgres(List<String> violations) throws IOException {
    String violation =
        developmentPostgresViolation(
            Files.readString(root.resolve("compose.yaml"), StandardCharsets.UTF_8),
            Files.readString(root.resolve("lemon"), StandardCharsets.UTF_8));
    if (violation != null) {
      violations.add("compose.yaml: " + violation);
    }
  }

  private void checkAndroidReleaseSigning(List<String> violations) throws IOException {
    String relative = "apps/mobile/android/app/build.gradle.kts";
    String violation =
        androidReleaseSigningViolation(
            Files.readString(root.resolve(relative), StandardCharsets.UTF_8));
    if (violation != null) {
      violations.add(relative + ": " + violation);
    }
  }

  private void checkWebShellSurfaces(List<String> violations) throws IOException {
    String bg0 =
        ToolSupport.JSON
            .readTree(root.resolve("design/tokens/colors.json").toFile())
            .path("bg0")
            .asText()
            .toUpperCase();
    for (String app : List.of("moderation", "widgetbook")) {
      String webRoot = "apps/" + app + "/web/";
      String violation =
          webShellViolation(
              Files.readString(root.resolve(webRoot + "index.html"), StandardCharsets.UTF_8),
              Files.readString(root.resolve(webRoot + "manifest.json"), StandardCharsets.UTF_8),
              Files.readString(
                  root.resolve(webRoot + "lemon_generated_colors.css"), StandardCharsets.UTF_8),
              bg0);
      if (violation != null) {
        violations.add(webRoot + ": " + violation);
      }
    }
  }

  private static String provisionalViolation(String relative, String source) {
    if (isProvisionalExcluded(relative) || !isProvisionalText(relative)) {
      return null;
    }
    return source.contains("PROVISION" + "AL") ? "unresolved provisional marker" : null;
  }

  private static boolean isProvisionalText(String relative) {
    String lower = relative.toLowerCase();
    return lower.endsWith(".java")
        || lower.endsWith(".kt")
        || lower.endsWith(".kts")
        || lower.endsWith(".dart")
        || lower.endsWith(".yaml")
        || lower.endsWith(".yml")
        || lower.endsWith(".json")
        || lower.endsWith(".sql")
        || lower.endsWith(".sh")
        || lower.endsWith(".toml")
        || lower.endsWith(".properties")
        || lower.endsWith(".xml")
        || lower.endsWith(".swift")
        || lower.endsWith(".gradle")
        || lower.endsWith(".md")
        || lower.endsWith(".txt")
        || lower.endsWith(".cfg")
        || lower.endsWith(".conf")
        || lower.endsWith(".ini")
        || lower.endsWith(".cmd")
        || lower.endsWith(".ps1")
        || lower.endsWith(".plist")
        || lower.endsWith(".pbxproj")
        || lower.endsWith(".xcconfig")
        || lower.endsWith(".storyboard")
        || lower.endsWith("/dockerfile")
        || lower.equals("dockerfile")
        || lower.equals("lemon")
        || lower.endsWith("/gradlew");
  }

  private static boolean isProvisionalExcluded(String relative) {
    return relative.startsWith("docs/")
        || relative.equals("AGENTS.md")
        || relative.equals("tooling/architecture/src/main/resources/AGENTS.template.md")
        || relative.startsWith("tooling/architecture/fixtures/")
        || relative.startsWith("architecture/generated/")
        || relative.startsWith("backend/src/generated/")
        || relative.startsWith("backend/src/test/resources/generated/")
        || relative.startsWith("contracts/fixtures/generated/")
        || relative.equals("contracts/generated-bindings.sha256.json")
        || relative.startsWith("packages/api_client/lib/")
        || relative.startsWith("packages/admin_api_client/lib/")
        || relative.startsWith("packages/lemon_lints/lib/src/generated/")
        || relative.startsWith("packages/lemon_ui/lib/src/generated/")
        || relative.startsWith("tooling/generated/")
        || relative.endsWith("/lemon_generated_colors.xml")
        || relative.contains("/LemonBg0.colorset/");
  }

  private static String productionContractFixtureViolation(String source) {
    return source.contains("/_contract/fixture")
            || source.contains("ContractFixture")
            || source.contains("contract_fixture")
        ? "test-only contract fixture escaped into a production surface"
        : null;
  }

  private static String nativeLaunchReferenceViolation(String source, String required) {
    return source.contains(required) ? null : "native launch surface must use Lemon bg0";
  }

  private static String androidWrapperViolation(String source) {
    Matcher properties = GRADLE_PROPERTY.matcher(source);
    String checksum = null;
    while (properties.find()) {
      if (properties.group(1).strip().equals("distributionSha256Sum")) {
        checksum = properties.group(2).strip();
      }
    }
    return checksum != null && checksum.matches("[0-9a-f]{64}")
        ? null
        : "pinned Android Gradle distribution requires distributionSha256Sum";
  }

  private static String androidDependencyIntegrityViolation(String buildSource, String metadata) {
    if (!buildSource.contains("lockAllConfigurations()")
        || !buildSource.contains("LockMode.STRICT")) {
      return "Flutter Android Gradle configurations require strict dependency locking";
    }
    return metadata.contains("<verify-metadata>true</verify-metadata>")
        ? null
        : "Flutter Android Gradle dependencies require checksum verification metadata";
  }

  private static String buildLogicCatalogViolation(String source) {
    return BUILD_LOGIC_VERSIONED_DEPENDENCY.matcher(source).find()
            || BUILD_LOGIC_TOOL_VERSION.matcher(source).find()
        ? "catalog-owned dependency/tool version must come from gradle/libs.versions.toml"
        : null;
  }

  private static String wrapperValidationWorkflowViolation(String source) {
    if (!PINNED_WRAPPER_VALIDATION_ACTION.matcher(source).find()) {
      return "official Gradle wrapper validation action must be pinned to a full commit SHA";
    }
    if (!source.contains(
        "policy:\n    name: Policy / schema first\n    needs: wrapper-validation")) {
      return "wrapper validation must complete before the policy/build graph";
    }
    if (!source.contains("min-wrapper-count: 2")) {
      return "wrapper validation must require both repository wrapper JARs";
    }
    return source.contains("needs: [wrapper-validation, pr-classification, final-verification]")
        ? null
        : "terminal PR gate must depend on wrapper validation";
  }

  private static String developmentPostgresViolation(String compose, String commandSurface) {
    if (!DIGEST_PINNED_POSTGRES.matcher(compose).find()) {
      return "development PostgreSQL image must retain its tag and pin a SHA-256 digest";
    }
    if (!compose.contains("127.0.0.1:5432:5432") || compose.contains("\"5432:5432\"")) {
      return "development PostgreSQL port must bind to 127.0.0.1 only";
    }
    return commandSurface.contains("docker compose up --detach --wait postgres")
        ? null
        : "./lemon dev must wait for PostgreSQL health before backend boot";
  }

  private static String androidReleaseSigningViolation(String source) {
    if (source.contains("signingConfigs.getByName(\"debug\")") || source.contains("TODO")) {
      return "Android release builds must not fall back to debug signing";
    }
    for (String required :
        List.of(
            "LEMON_RELEASE_STORE_FILE",
            "LEMON_RELEASE_STORE_PASSWORD",
            "LEMON_RELEASE_KEY_ALIAS",
            "LEMON_RELEASE_KEY_PASSWORD",
            "gradle.taskGraph.whenReady",
            "Release signing is not configured")) {
      if (!source.contains(required)) {
        return "Android release signing must fail closed with an explicit configuration contract";
      }
    }
    return null;
  }

  private static String webShellViolation(
      String index, String manifest, String generatedCss, String bg0) {
    String combined = index + manifest + generatedCss;
    if (combined.contains("#0175C2") || combined.contains("A new Flutter project.")) {
      return "Flutter template design/copy must not escape into Lemon web shells";
    }
    if (!index.contains("lemon_generated_colors.css")) {
      return "web shell must load the generated Lemon color surface";
    }
    if (!generatedCss.contains("--lemon-bg0: " + bg0)) {
      return "generated web shell background must equal design token bg0";
    }
    return manifest.contains("\"background_color\": \"" + bg0 + "\"")
            && manifest.contains("\"theme_color\": \"" + bg0 + "\"")
        ? null
        : "web manifest background/theme must equal design token bg0";
  }

  private static String iosFallback(String hexColor) {
    String hex = hexColor.substring(1);
    String red = iosComponent(hex.substring(0, 2));
    String green = iosComponent(hex.substring(2, 4));
    String blue = iosComponent(hex.substring(4, 6));
    return "<color red=\""
        + red
        + "\" green=\""
        + green
        + "\" blue=\""
        + blue
        + "\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"sRGB\"/>";
  }

  private static String iosComponent(String hex) {
    return BigDecimal.valueOf(Integer.parseInt(hex, 16))
        .divide(BigDecimal.valueOf(255), 6, RoundingMode.HALF_UP)
        .toPlainString();
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
