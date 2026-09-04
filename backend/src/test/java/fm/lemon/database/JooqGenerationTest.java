package fm.lemon.database;

import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.nio.file.Path;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.io.TempDir;
import org.testcontainers.postgresql.PostgreSQLContainer;

final class JooqGenerationTest {
  @Tag("postgres")
  @Test
  void eachSchemaGeneratesIntoItsOwnedPackage(@TempDir Path temporaryDirectory) throws Exception {
    try (PostgreSQLContainer container = DatabaseScaffold.postgres()) {
      container.start();
      DatabaseScaffold.migrate(container);
      DatabaseScaffold.generate(container, temporaryDirectory.resolve("generated-jooq"));
    }

    for (String schema : DatabaseScaffold.schemas().values()) {
      Path schemaRoot = temporaryDirectory.resolve("generated-jooq").resolve(schema);
      assertTrue(Files.isDirectory(schemaRoot), "missing output for " + schema);
      assertGeneratedSourcesBelongTo(schemaRoot, schema);
    }
  }

  private static void assertGeneratedSourcesBelongTo(Path schemaRoot, String schema)
      throws IOException {
    try (var sources = Files.walk(schemaRoot)) {
      var javaSources = sources.filter(path -> path.toString().endsWith(".java")).toList();
      assertFalse(javaSources.isEmpty(), "no generated Java sources for " + schema);
      for (Path source : javaSources) {
        String text = Files.readString(source, StandardCharsets.UTF_8);
        assertTrue(
            text.contains("package fm.lemon.generated.jooq." + schema),
            () -> source + " escaped the package owned by " + schema);
      }
    }
  }
}
