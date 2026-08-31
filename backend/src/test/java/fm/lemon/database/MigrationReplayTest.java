package fm.lemon.database;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.LinkedHashSet;
import java.util.Set;
import org.flywaydb.core.api.output.MigrateResult;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.testcontainers.postgresql.PostgreSQLContainer;

final class MigrationReplayTest {
  @Tag("postgres")
  @Test
  void migrationsReplayFromAnEmptyPostgresDatabase() throws SQLException {
    try (PostgreSQLContainer container = DatabaseScaffold.postgres()) {
      container.start();
      DatabaseScaffold.migrate(container);

      try (Connection connection = DatabaseScaffold.connect(container)) {
        assertEquals(expectedSchemas(), applicationSchemas(connection));
        assertTrue(tableExists(connection, "platform", "flyway_schema_history"));
      }

      MigrateResult secondRun = DatabaseScaffold.migrate(container).migrate();
      assertEquals(0, secondRun.migrationsExecuted);
    }
  }

  private static Set<String> expectedSchemas() {
    Set<String> expected = new LinkedHashSet<>(DatabaseScaffold.schemas().values());
    expected.add("platform");
    return expected;
  }

  private static Set<String> applicationSchemas(Connection connection) throws SQLException {
    Set<String> schemas = new LinkedHashSet<>();
    try (var statement =
            connection.prepareStatement(
                "SELECT schema_name FROM information_schema.schemata "
                    + "WHERE schema_name = 'platform' OR schema_name IN "
                    + "('identity','profile','quiz','discovery','messaging','safety',"
                    + "'commerce','content','media','notification') ORDER BY schema_name");
        ResultSet result = statement.executeQuery()) {
      while (result.next()) {
        schemas.add(result.getString(1));
      }
    }
    return schemas;
  }

  private static boolean tableExists(Connection connection, String schema, String table)
      throws SQLException {
    try (ResultSet result = connection.getMetaData().getTables(null, schema, table, null)) {
      return result.next();
    }
  }
}
