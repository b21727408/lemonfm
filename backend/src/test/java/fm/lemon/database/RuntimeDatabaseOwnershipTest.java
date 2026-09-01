package fm.lemon.database;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertFalse;
import static org.junit.jupiter.api.Assertions.assertTrue;

import fm.lemon.LemonApplication;
import java.io.IOException;
import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.concurrent.CountDownLatch;
import java.util.concurrent.TimeUnit;
import org.junit.jupiter.api.Tag;
import org.junit.jupiter.api.Test;
import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.env.YamlPropertySourceLoader;
import org.springframework.context.ApplicationEventPublisher;
import org.springframework.context.ConfigurableApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.core.env.PropertySource;
import org.springframework.core.io.ClassPathResource;
import org.springframework.modulith.events.ApplicationModuleListener;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.support.TransactionTemplate;
import org.testcontainers.postgresql.PostgreSQLContainer;

final class RuntimeDatabaseOwnershipTest {
  @Test
  void defaultConfigurationDisablesRuntimeSchemaMutation() throws IOException {
    PropertySource<?> source =
        new YamlPropertySourceLoader()
            .load("application", new ClassPathResource("application.yaml"))
            .getFirst();

    assertEquals(false, source.getProperty("spring.flyway.enabled"));
    assertEquals("platform", source.getProperty("spring.modulith.events.jdbc.schema"));
    assertEquals(
        false, source.getProperty("spring.modulith.events.jdbc.schema-initialization.enabled"));
  }

  @Tag("postgres")
  @Test
  void modulithRegistryUsesFlywayOwnedPlatformTable() throws SQLException {
    try (PostgreSQLContainer container = DatabaseScaffold.postgres()) {
      container.start();
      DatabaseScaffold.migrate(container);

      try (ConfigurableApplicationContext context = startApplication(container)) {
        ApplicationEventPublisher publisher = context.getBean(ApplicationEventPublisher.class);
        PlatformTransactionManager transactions = context.getBean(PlatformTransactionManager.class);
        new TransactionTemplate(transactions)
            .executeWithoutResult(ignored -> publisher.publishEvent(new RegistryFixtureEvent()));
        assertTrue(
            context.getBean(RegistryFixtureListener.class).await(),
            "the durable event listener did not complete");
      }

      try (Connection connection = DatabaseScaffold.connect(container)) {
        assertTrue(tableExists(connection, "platform", "event_publication"));
        assertFalse(tableExists(connection, "public", "event_publication"));
        assertEquals(1, rowCount(connection, "platform", "event_publication"));
      }
    }
  }

  private static ConfigurableApplicationContext startApplication(PostgreSQLContainer container) {
    return new SpringApplicationBuilder(LemonApplication.class, RegistryFixtureConfiguration.class)
        .properties(
            "spring.main.web-application-type=none",
            "spring.datasource.url=" + container.getJdbcUrl(),
            "spring.datasource.username=" + container.getUsername(),
            "spring.datasource.password=" + container.getPassword())
        .run();
  }

  record RegistryFixtureEvent() {}

  @Configuration(proxyBeanMethods = false)
  static class RegistryFixtureConfiguration {
    @Bean
    RegistryFixtureListener registryFixtureListener() {
      return new RegistryFixtureListener();
    }
  }

  static final class RegistryFixtureListener {
    private final CountDownLatch completed = new CountDownLatch(1);

    @ApplicationModuleListener
    void on(RegistryFixtureEvent event) {
      completed.countDown();
    }

    boolean await() {
      try {
        return completed.await(10, TimeUnit.SECONDS);
      } catch (InterruptedException exception) {
        Thread.currentThread().interrupt();
        return false;
      }
    }
  }

  private static boolean tableExists(Connection connection, String schema, String table)
      throws SQLException {
    try (ResultSet result = connection.getMetaData().getTables(null, schema, table, null)) {
      return result.next();
    }
  }

  private static int rowCount(Connection connection, String schema, String table)
      throws SQLException {
    try (var statement = connection.createStatement();
        ResultSet result = statement.executeQuery("SELECT COUNT(*) FROM " + schema + "." + table)) {
      assertTrue(result.next());
      return result.getInt(1);
    }
  }
}
