import 'dart:io';

final class FixtureCase {
  const FixtureCase(this.name, this.relativePath, this.expectedCode);

  final String name;
  final String relativePath;
  final String? expectedCode;
}

Future<void> main() async {
  final root = File.fromUri(Platform.script).parent.parent.parent.parent;
  final fixtures = root.uri.resolve('packages/lemon_lints/test_fixtures/');
  final temporary = await Directory.systemTemp.createTemp('lemon-lints-');
  final package = Directory.fromUri(
    temporary.uri.resolve('packages/features/profile/'),
  );
  await package.create(recursive: true);
  final pluginPath = root.uri
      .resolve('packages/lemon_lints/')
      .toFilePath()
      .replaceAll(r'\', '/');
  await File.fromUri(package.uri.resolve('pubspec.yaml')).writeAsString('''
name: profile
publish_to: none
environment:
  sdk: '>=3.13.2 <4.0.0'
''');
  await File.fromUri(package.uri.resolve('analysis_options.yaml'))
      .writeAsString('''
analyzer:
  errors:
    uri_does_not_exist: ignore
plugins:
  lemon_lints:
    path: $pluginPath
''');
  final pub = await Process.run(Platform.resolvedExecutable, [
    'pub',
    'get',
  ], workingDirectory: package.path);
  if (pub.exitCode != 0) {
    throw StateError('fixture pub get failed:\n${pub.stdout}\n${pub.stderr}');
  }

  const cases = [
    FixtureCase(
      'layer_flutter_negative',
      'lib/src/domain/layer_flutter.dart',
      'lemon_layer_boundary',
    ),
    FixtureCase(
      'layer_private_negative',
      'lib/src/presentation/layer_private.dart',
      'lemon_layer_boundary',
    ),
    FixtureCase('layer_positive', 'lib/src/domain/layer.dart', null),
    FixtureCase(
      'layer_domain_technical_negative',
      'lib/src/domain/technical.dart',
      'lemon_layer_boundary',
    ),
    FixtureCase('layer_domain_positive', 'lib/src/domain/model.dart', null),
    FixtureCase(
      'layer_domain_dart_io_negative',
      'lib/src/domain/http_client.dart',
      'lemon_layer_boundary',
    ),
    FixtureCase(
      'layer_application_negative',
      'lib/src/application/reversed.dart',
      'lemon_layer_boundary',
    ),
    FixtureCase(
      'layer_application_positive',
      'lib/src/application/use_case.dart',
      null,
    ),
    FixtureCase(
      'layer_application_dart_io_negative',
      'lib/src/application/http_client.dart',
      'lemon_layer_boundary',
    ),
    FixtureCase(
      'layer_data_negative',
      'lib/src/data/reversed.dart',
      'lemon_layer_boundary',
    ),
    FixtureCase('layer_data_positive', 'lib/src/data/gateway.dart', null),
    FixtureCase(
      'layer_data_dart_io_positive',
      'lib/src/data/http_client.dart',
      null,
    ),
    FixtureCase(
      'layer_presentation_negative',
      'lib/src/presentation/reversed.dart',
      'lemon_layer_boundary',
    ),
    FixtureCase(
      'layer_presentation_positive',
      'lib/src/presentation/controller.dart',
      null,
    ),
    FixtureCase(
      'raw_design_negative',
      'lib/src/presentation/raw_design.dart',
      'lemon_design_token_boundary',
    ),
    FixtureCase(
      'raw_design_positive',
      'lib/src/presentation/design.dart',
      null,
    ),
    FixtureCase(
      'material_visual_negative',
      'lib/src/presentation/material_visual.dart',
      'lemon_design_token_boundary',
    ),
    FixtureCase(
      'widget_string_negative',
      'lib/src/presentation/widget_string.dart',
      'lemon_widget_text_boundary',
    ),
    FixtureCase(
      'widget_string_positive',
      'lib/src/presentation/widget_text.dart',
      null,
    ),
    FixtureCase(
      'vendor_negative',
      'lib/src/presentation/vendor.dart',
      'lemon_vendor_boundary',
    ),
    FixtureCase('vendor_positive', 'lib/src/presentation/framework.dart', null),
    FixtureCase(
      'determinism_negative',
      'lib/src/application/determinism.dart',
      'lemon_determinism_boundary',
    ),
    FixtureCase(
      'determinism_positive',
      'lib/src/application/injected_time.dart',
      null,
    ),
  ];

  try {
    for (final fixture in cases) {
      final source = await File.fromUri(fixtures.resolve('${fixture.name}.txt'))
          .readAsString();
      final target = File.fromUri(package.uri.resolve(fixture.relativePath));
      await target.parent.create(recursive: true);
      await target.writeAsString(source);
      final analysis = await Process.run(Platform.resolvedExecutable, [
        'analyze',
        '--format',
        'machine',
        target.path,
      ], workingDirectory: package.path);
      final output = '${analysis.stdout}\n${analysis.stderr}';
      final customDiagnostics = RegExp(r'lemon_[a-z_]+')
          .allMatches(output.toLowerCase())
          .map((match) => match.group(0))
          .toSet();
      if (fixture.expectedCode == null && customDiagnostics.isNotEmpty) {
        throw StateError(
          '${fixture.name} unexpectedly failed: $customDiagnostics\n$output',
        );
      }
      if (fixture.expectedCode != null &&
          !customDiagnostics.contains(fixture.expectedCode)) {
        throw StateError(
          '${fixture.name} did not report ${fixture.expectedCode}:\n$output',
        );
      }
      await target.delete();
    }
  } finally {
    await temporary.delete(recursive: true);
  }
  stdout.writeln(
    'lemon_lints: all five rules passed positive and negative fixtures',
  );
}
