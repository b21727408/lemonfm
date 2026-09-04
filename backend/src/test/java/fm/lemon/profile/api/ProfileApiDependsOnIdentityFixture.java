package fm.lemon.profile.api;

import fm.lemon.identity.api.ForeignIdentityApiFixture;

public interface ProfileApiDependsOnIdentityFixture {
  ForeignIdentityApiFixture foreignIdentityApi();
}
