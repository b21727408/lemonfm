package fm.lemon.database;

import java.nio.file.Path;
import org.testcontainers.postgresql.PostgreSQLContainer;

public final class JooqGenerator {
  private JooqGenerator() {}

  public static void main(String[] arguments) throws Exception {
    if (arguments.length != 1) {
      throw new IllegalArgumentException("Expected the generated source output directory");
    }
    try (PostgreSQLContainer container = DatabaseScaffold.postgres()) {
      container.start();
      DatabaseScaffold.migrate(container);
      DatabaseScaffold.generate(container, Path.of(arguments[0]));
    }
  }
}
