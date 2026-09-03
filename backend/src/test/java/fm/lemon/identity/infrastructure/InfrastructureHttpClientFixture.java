package fm.lemon.identity.infrastructure;

import java.net.http.HttpClient;

public interface InfrastructureHttpClientFixture {
  HttpClient client();
}
