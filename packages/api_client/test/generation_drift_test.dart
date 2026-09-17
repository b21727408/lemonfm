import 'dart:io';

import 'package:test/test.dart';

import '../../../tool/http.dart' as generation;

void main() {
  for (final newline in ['\n', '\r\n']) {
    test(
      'standalone manifest preserves settings with ${newline.length == 1 ? 'LF' : 'CRLF'}',
      () {
        final original = File(
          'pubspec.yaml',
        ).readAsStringSync().replaceAll('\r\n', '\n');
        final lines = original.split('\n');
        expect(lines, contains('resolution: workspace'));
        final manifest = lines.join(newline);
        final expected = lines
            .where((line) => line != 'resolution: workspace')
            .join(newline);
        expect(generation.standaloneManifest(manifest), expected);
        expect(
          generation.standaloneManifest(manifest),
          isNot(contains('resolution: workspace')),
        );
      },
    );
  }

  test('drift check detects changed, missing and obsolete checked-in source', () {
    final actual = generation.snapshot(Directory('lib'));
    expect(actual, isNotEmpty);
    final name = actual.keys.first;
    // Mutate snapshots, never generated files. Exercise the same check used by the CLI.
    final stale = {
      ...actual,
      name: [...actual[name]!, 32],
    };
    final missing = {...actual}..remove(name);
    final obsolete = {
      ...actual,
      'obsolete_binding.dart': <int>[32],
    };
    for (final candidate in [stale, missing, obsolete]) {
      expect(
        () => generation.compare(actual, candidate, 'Dart binding drift'),
        throwsA(
          isA<StateError>().having(
            (e) => e.message,
            'message',
            contains('failed'),
          ),
        ),
      );
    }
    generation.compare(actual, actual, 'Unmodified generated bindings');
  });
}
