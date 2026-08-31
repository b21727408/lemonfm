package fm.lemon.modulithfixture.alpha.application;

import fm.lemon.modulithfixture.beta.api.BetaApi;
import fm.lemon.modulithfixture.delta.api.DeltaValue;
import fm.lemon.modulithfixture.gamma.api.GammaEvent;
import org.springframework.modulith.events.ApplicationModuleListener;
import org.springframework.stereotype.Component;

@Component
class AlphaComponent {
  private final BetaApi betaApi;
  private final DeltaValue value = new DeltaValue("fixture");

  AlphaComponent(BetaApi betaApi) {
    this.betaApi = betaApi;
  }

  @ApplicationModuleListener
  void on(GammaEvent event) {
    betaApi.accept(value.value() + event.value());
  }
}
