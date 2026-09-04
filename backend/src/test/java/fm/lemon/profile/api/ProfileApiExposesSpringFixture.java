package fm.lemon.profile.api;

import org.springframework.http.ResponseEntity;

public interface ProfileApiExposesSpringFixture {
  ResponseEntity<String> getProfile();
}
