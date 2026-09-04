package fm.lemon.externaliofixture;

import org.springframework.transaction.annotation.Transactional;

final class TransactionalOperation {
  private final Gateway gateway;

  TransactionalOperation(Gateway gateway) {
    this.gateway = gateway;
  }

  @Transactional
  void execute() {
    gateway.send();
  }
}
