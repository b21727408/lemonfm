import 'dart:io';

import 'package:test/test.dart';

import '../../../tool/http.dart' as generation;

void main() {
  test(
    'check-drift regenerates current inputs without writing bindings',
    () async {
      // Copy working-tree inputs, including uncommitted fixes, without build caches.
      // All mutations below stay in this fixture; authored repository files are read-only.
      final repository = Directory('../..').absolute;
      final fixture = Directory.systemTemp.createTempSync('lemonfm-http-');
      expect(
        fixture.parent.resolveSymbolicLinksSync(),
        Directory.systemTemp.resolveSymbolicLinksSync(),
      );
      addTearDown(() => fixture.deleteSync(recursive: true));
      final tracked = await Process.run('git', [
        'ls-files',
        '-z',
      ], workingDirectory: repository.path);
      expect(tracked.exitCode, 0, reason: '${tracked.stderr}');
      for (final path in (tracked.stdout as String).split('\x00')) {
        if (path.isEmpty) continue;
        final target = File('${fixture.path}/$path');
        target.parent.createSync(recursive: true);
        File('${repository.path}/$path').copySync(target.path);
      }

      final bindings = Directory('${fixture.path}/packages/api_client/lib');
      final manifest = File('${fixture.path}/packages/api_client/pubspec.yaml');
      final originalManifest = manifest.readAsStringSync().replaceAll(
        '\r\n',
        '\n',
      );
      final stage = Directory('${fixture.path}/build/generated/http/dart');
      final lockedPaths = [
        'pubspec.lock',
        'gradle.lockfile',
        'backend/gradle.lockfile',
        'gradle/verification-metadata.xml',
      ];
      final lockedBytes = {
        for (final path in lockedPaths)
          path: File('${fixture.path}/$path').readAsBytesSync(),
      };

      Future<void> checkDrift(String scenario, List<String> drift) async {
        final before = generation.snapshot(bindings);
        final result = await Process.run(Platform.resolvedExecutable, [
          'tool/http.dart',
          'check-drift',
        ], workingDirectory: fixture.path);
        final output = '${result.stdout}${result.stderr}';
        expect(result.exitCode, drift.isEmpty ? 0 : 1, reason: output);
        expect(output, contains('generateDartHttp'));
        expect(output, contains('--dependency-verification=strict'));
        expect(output, contains('pub get --enforce-lockfile'));
        expect(output, isNot(contains('generateJavaHttp')));
        expect(output, isNot(contains(':backend:test')));
        expect(output, isNot(contains('--write-locks')));
        expect(output, isNot(contains('--write-verification-metadata')));
        if (drift.isEmpty) {
          expect(
            output,
            contains('Dart binding drift: ${before.length} files identical'),
          );
        } else {
          expect(output, contains('Dart binding drift failed:'));
          for (final path in drift) {
            expect(output, contains(path));
          }
        }
        expect(
          generation.snapshot(bindings),
          before,
          reason: 'check-drift must be read-only',
        );
        for (final entry in lockedBytes.entries) {
          expect(
            File('${fixture.path}/${entry.key}').readAsBytesSync(),
            entry.value,
          );
        }
        expect(
          File('${stage.path}/pubspec.lock').readAsBytesSync(),
          lockedBytes['pubspec.lock'],
        );
        final stagedManifest = File(
          '${stage.path}/pubspec.yaml',
        ).readAsStringSync();
        expect(stagedManifest, isNot(contains('resolution: workspace')));
        expect(
          stagedManifest,
          manifest
              .readAsStringSync()
              .split(RegExp(r'(?<=\n)'))
              .where((line) => line.trim() != 'resolution: workspace')
              .join(),
        );
        // Report scenarios explicitly rather than treating an expected CLI failure as a pass.
        print(
          '$scenario: exit ${result.exitCode}; bindings and locks unchanged',
        );
      }

      expect(stage.existsSync(), isFalse);
      manifest.writeAsStringSync(originalManifest);
      await checkDrift(
        'LF manifest, no pre-existing generated output, matching bindings',
        [],
      );

      // The retained candidate and checked-in bindings now match. Change an actual
      // generator input: comparing those two stale trees must no longer pass.
      final template = File(
        '${fixture.path}/tool/generation/templates/dart/serialization/built_value/serializers.mustache',
      );
      final originalTemplate = template.readAsBytesSync();
      template.writeAsStringSync(
        '\n// Current-input regression marker.\n',
        mode: FileMode.append,
      );
      await checkDrift('Changed template with stale matching trees', [
        'src/serializers.dart',
      ]);
      expect(
        File('${stage.path}/lib/src/serializers.dart').readAsStringSync(),
        contains('// Current-input regression marker.'),
      );
      template.writeAsBytesSync(originalTemplate);

      manifest.writeAsStringSync(originalManifest.replaceAll('\n', '\r\n'));
      await checkDrift('CRLF manifest, restored inputs, matching bindings', []);

      const modified = 'src/api/profiles_api.dart';
      const missing = 'src/model/api_error.dart';
      const obsolete = 'obsolete_binding.dart';
      File(
        '${bindings.path}/$modified',
      ).writeAsStringSync('\n// Stale fixture.\n', mode: FileMode.append);
      File('${bindings.path}/$missing').deleteSync();
      File(
        '${bindings.path}/$obsolete',
      ).writeAsStringSync('// Obsolete fixture.\n');
      await checkDrift('Modified, missing and obsolete binding files', [
        modified,
        missing,
        obsolete,
      ]);
    },
    timeout: const Timeout(Duration(minutes: 8)),
  );
}
