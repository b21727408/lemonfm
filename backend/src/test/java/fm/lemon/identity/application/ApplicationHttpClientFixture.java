package fm.lemon.identity.application;

import java.net.http.HttpClient;

public interface ApplicationHttpClientFixture {
  HttpClient client();
}
