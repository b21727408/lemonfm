package fm.lemon.externaliofixture;

import fm.lemon.architecture.ExternalIo;

@ExternalIo
interface HostedPort {
  void send();
}
