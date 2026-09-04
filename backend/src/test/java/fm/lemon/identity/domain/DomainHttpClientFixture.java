package fm.lemon.identity.domain;

import java.net.http.HttpClient;

public interface DomainHttpClientFixture {
  HttpClient client();
}
