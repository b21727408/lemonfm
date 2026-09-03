package fm.lemon.identity.infrastructure;

import fm.lemon.identity.application.UnmarkedExternalPortFixture;
import java.net.http.HttpClient;

public final class UnmarkedHttpAdapterFixture implements UnmarkedExternalPortFixture {
  private final HttpClient client;

  public UnmarkedHttpAdapterFixture(HttpClient client) {
    this.client = client;
  }

  @Override
  public void send() {
    client.version();
  }
}
