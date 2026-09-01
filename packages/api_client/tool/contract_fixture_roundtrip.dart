import 'dart:convert';
import 'dart:io';

import '../lib/api_client.dart';

Future<void> main() async {
  final contract = await _fixture('public');
  final server = await HttpServer.bind(InternetAddress.loopbackIPv4, 0);
  final requestHandled = server.first.then((request) async {
    if (request.uri.path != contract.path) {
      throw StateError('unexpected public fixture path: ${request.uri.path}');
    }
    request.response
      ..statusCode = HttpStatus.ok
      ..headers.contentType = ContentType.json
      ..write(jsonEncode({'fixture': contract.value}));
    await request.response.close();
  });

  try {
    final client = ApiClient(
      basePathOverride: 'http://${server.address.host}:${server.port}',
    );
    final response = await client
        .getContractFixtureApi()
        .getPublicContractFixture();
    await requestHandled;
    if (response.statusCode != HttpStatus.ok ||
        response.data?.fixture != ContractFixtureResponseFixtureEnum.publicV1) {
      throw StateError('public generated client failed its fixture round-trip');
    }
  } finally {
    await server.close(force: true);
  }
}

Future<({String path, String value})> _fixture(String surface) async {
  final file = File.fromUri(
    Platform.script.resolve(
      '../../../contracts/generated/fixture-contracts.json',
    ),
  );
  final fixtures =
      jsonDecode(await file.readAsString()) as Map<String, dynamic>;
  final fixture = fixtures[surface] as Map<String, dynamic>;
  return (path: fixture['path'] as String, value: fixture['fixture'] as String);
}
