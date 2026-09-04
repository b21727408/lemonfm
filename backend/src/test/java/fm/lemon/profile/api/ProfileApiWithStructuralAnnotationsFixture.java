package fm.lemon.profile.api;

import fm.lemon.architecture.ExternalIo;
import org.jspecify.annotations.Nullable;

@ExternalIo
public interface ProfileApiWithStructuralAnnotationsFixture {
  @Nullable String optionalValue();
}
