package fm.lemon.externaliofixture;

final class Gateway {
  private final HostedPort hostedPort;

  Gateway(HostedPort hostedPort) {
    this.hostedPort = hostedPort;
  }

  void send() {
    hostedPort.send();
  }
}
