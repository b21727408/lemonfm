import 'dart:io';

import 'package:test/test.dart';

import '../../../tool/http.dart' as generation;

void main() {
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
