package fm.lemon.identity.infrastructure;

import fm.lemon.architecture.ExternalIo;
import fm.lemon.identity.application.MarkedExternalPortFixture;
import java.net.http.HttpClient;

@ExternalIo
public final class MarkedHttpAdapterFixture implements MarkedExternalPortFixture {
  private final HttpClient client;

  public MarkedHttpAdapterFixture(HttpClient client) {
    this.client = client;
  }

  @Override
  public void send() {
    client.version();
  }
}
