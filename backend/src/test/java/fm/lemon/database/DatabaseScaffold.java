package fm.lemon.database;

import java.io.IOException;
import java.io.InputStream;
import java.nio.file.Files;
import java.nio.file.Path;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Comparator;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.Properties;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.flywaydb.core.Flyway;
import org.jooq.codegen.GenerationTool;
import org.jooq.meta.jaxb.Configuration;
import org.jooq.meta.jaxb.Database;
import org.jooq.meta.jaxb.Generate;
import org.jooq.meta.jaxb.Generator;
import org.jooq.meta.jaxb.Jdbc;
import org.jooq.meta.jaxb.Target;
import org.testcontainers.postgresql.PostgreSQLContainer;
import org.testcontainers.utility.DockerImageName;

final class DatabaseScaffold {
  private static final Pattern POSTGRES_IMAGE =
      Pattern.compile("(?m)^\\s*image:\\s*(postgres:[^\\s@]+@sha256:[0-9a-f]{64})\\s*(?:#.*)?$");

  private DatabaseScaffold() {}

  static PostgreSQLContainer postgres() {
    return new PostgreSQLContainer(postgresDockerImage())
        .withDatabaseName("lemon")
        .withUsername("lemon")
        .withPassword("lemon");
  }

  static DockerImageName postgresDockerImage() {
    return DockerImageName.parse(postgresImage()).asCompatibleSubstituteFor("postgres");
  }

  static String postgresImage() {
    String composePath = System.getProperty("lemon.compose.file");
    if (composePath == null || composePath.isBlank()) {
      throw new IllegalStateException(
          "lemon.compose.file must point to the repository Compose file");
    }
    try {
      Matcher image = POSTGRES_IMAGE.matcher(Files.readString(Path.of(composePath)));
      if (!image.find()) {
        throw new IllegalStateException(
            "Compose PostgreSQL image must use a tag and SHA-256 digest");
      }
      return image.group(1);
    } catch (IOException exception) {
      throw new IllegalStateException("Cannot read Compose PostgreSQL image", exception);
    }
  }

  static Flyway migrate(PostgreSQLContainer container) {
    Flyway flyway =
        Flyway.configure()
            .dataSource(container.getJdbcUrl(), container.getUsername(), container.getPassword())
            .createSchemas(true)
            .defaultSchema("platform")
            .schemas("platform")
            .locations("classpath:db/migration")
            .load();
    flyway.migrate();
    return flyway;
  }

  static Connection connect(PostgreSQLContainer container) throws SQLException {
    return DriverManager.getConnection(
        container.getJdbcUrl(), container.getUsername(), container.getPassword());
  }

  static Map<String, String> schemas() {
    Properties properties = new Properties();
    try (InputStream input =
        DatabaseScaffold.class
            .getClassLoader()
            .getResourceAsStream("generated/backend-policy.properties")) {
      if (input == null) {
        throw new IllegalStateException("Generated backend policy is missing");
      }
      properties.load(input);
    } catch (IOException exception) {
      throw new IllegalStateException("Cannot read generated backend policy", exception);
    }

    Map<String, String> schemas = new LinkedHashMap<>();
    properties.stringPropertyNames().stream()
        .filter(name -> name.startsWith("module.") && name.endsWith(".schema"))
        .sorted()
        .forEach(
            name -> {
              String module =
                  name.substring("module.".length(), name.length() - ".schema".length());
              schemas.put(module, properties.getProperty(name));
            });
    return schemas;
  }

  static void generate(PostgreSQLContainer container, Path outputRoot) throws Exception {
    recreateDirectory(outputRoot);
    for (String schema : schemas().values()) {
      Path schemaOutput = outputRoot.resolve(schema);
      Configuration configuration =
          new Configuration()
              .withJdbc(
                  new Jdbc()
                      .withDriver("org.postgresql.Driver")
                      .withUrl(container.getJdbcUrl())
                      .withUser(container.getUsername())
                      .withPassword(container.getPassword()))
              .withGenerator(
                  new Generator()
                      .withDatabase(
                          new Database()
                              .withName("org.jooq.meta.postgres.PostgresDatabase")
                              .withInputSchema(schema)
                              .withIncludes(".*"))
                      .withGenerate(
                          new Generate()
                              .withDeprecated(false)
                              .withGeneratedAnnotation(false)
                              .withEmptyCatalogs(true)
                              .withEmptySchemas(true)
                              .withRecords(false)
                              .withPojos(false)
                              .withDaos(false))
                      .withTarget(
                          new Target()
                              .withPackageName("fm.lemon.generated.jooq." + schema)
                              .withDirectory(schemaOutput.toString())
                              .withClean(true)));
      GenerationTool.generate(configuration);
    }
  }

  private static void recreateDirectory(Path outputRoot) throws IOException {
    Path normalized = outputRoot.toAbsolutePath().normalize();
    if (normalized.getNameCount() < 3 || !normalized.toString().contains("generated")) {
      throw new IllegalArgumentException("Refusing to clean unexpected jOOQ output: " + normalized);
    }
    if (Files.exists(normalized)) {
      try (var paths = Files.walk(normalized)) {
        paths.sorted(Comparator.reverseOrder()).forEach(DatabaseScaffold::delete);
      }
    }
    Files.createDirectories(normalized);
  }

  private static void delete(Path path) {
    try {
      Files.delete(path);
    } catch (IOException exception) {
      throw new IllegalStateException("Cannot remove stale jOOQ output " + path, exception);
    }
  }
}
