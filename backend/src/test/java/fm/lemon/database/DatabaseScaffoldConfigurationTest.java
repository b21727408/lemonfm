package fm.lemon.database;

import static org.assertj.core.api.Assertions.assertThat;

import org.junit.jupiter.api.Test;

final class DatabaseScaffoldConfigurationTest {
  @Test
  void testcontainersUsesTheDigestPinnedComposeImage() {
    String image = DatabaseScaffold.postgresImage();

    assertThat(image).matches("postgres:[0-9]+\\.[0-9]+@sha256:[0-9a-f]{64}");
    assertThat(DatabaseScaffold.postgresDockerImage().toString()).isEqualTo(image);
  }
}
