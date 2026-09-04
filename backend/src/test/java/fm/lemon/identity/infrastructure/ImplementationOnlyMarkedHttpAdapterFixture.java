package fm.lemon.identity.infrastructure;

import fm.lemon.architecture.ExternalIo;
import fm.lemon.identity.application.UnmarkedExternalPortFixture;
import java.net.http.HttpClient;

@ExternalIo
public final class ImplementationOnlyMarkedHttpAdapterFixture
    implements UnmarkedExternalPortFixture {
  private final HttpClient client;

  public ImplementationOnlyMarkedHttpAdapterFixture(HttpClient client) {
    this.client = client;
  }

  @Override
  public void send() {
    client.version();
  }
}
