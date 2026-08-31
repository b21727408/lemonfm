package fm.lemon.modulithfixture.beta.application;

import fm.lemon.modulithfixture.beta.api.BetaApi;
import org.springframework.stereotype.Component;

@Component
class BetaComponent implements BetaApi {
  @Override
  public void accept(String value) {}
}
