// E1 only: ordinary Gradle/Pub tasks plus source-tree comparison. No application gates.
import 'dart:io';

final root = File.fromUri(Platform.script).parent.parent;
final generated = Directory('${root.path}/build/generated/http');
final client = Directory('${root.path}/packages/api_client');

Future<void> run(String executable, List<String> args, Directory cwd) async {
  stdout.writeln('> $executable ${args.join(' ')} (${cwd.path})');
  final process = await Process.run(
    executable,
    args,
    workingDirectory: cwd.path,
    runInShell: Platform.isWindows,
  );
  if (process.exitCode != 0) {
    stderr.write(process.stdout);
    stderr.write(process.stderr);
    throw ProcessException(
      executable,
      args,
      'Command failed',
      process.exitCode,
    );
  }
  // Preserve full tool evidence without flooding the terminal with generated filenames.
  final logs = Directory('${root.path}/build/proof-logs')
    ..createSync(recursive: true);
  File(
    '${logs.path}/${executable.split(RegExp(r'[/\\]')).last}-${args.first}.log',
  ).writeAsStringSync('${process.stdout}${process.stderr}');
  stdout.writeln('  passed');
}

Map<String, List<int>> snapshot(Directory directory, {String? suffix}) {
  if (!directory.existsSync()) return {};
  return {
    for (final file in directory.listSync(recursive: true).whereType<File>())
      if (suffix == null || file.path.endsWith(suffix))
        file.path.substring(directory.path.length + 1).replaceAll('\\', '/'):
            file.readAsBytesSync(),
  };
}

void compare(
  Map<String, List<int>> expected,
  Map<String, List<int>> actual,
  String label,
) {
  final changed = <String>[];
  for (final name in {...expected.keys, ...actual.keys}) {
    final a = expected[name];
    final b = actual[name];
    if (a == null ||
        b == null ||
        a.length != b.length ||
        List.generate(a.length, (i) => i).any((i) => a[i] != b[i])) {
      changed.add(name);
    }
  }
  if (changed.isNotEmpty || expected.isEmpty) {
    throw StateError(
      '$label failed: ${changed.join(', ')}. Run dart tool/http.dart generate.',
    );
  }
  stdout.writeln(
    '$label: ${expected.length} files identical (including additions/removals).',
  );
}

Future<void> dartGeneration() async {
  final stage = Directory('${generated.path}/dart');
  // A disposable standalone package reuses the workspace's exact resolution.
  File('${stage.path}/pubspec.yaml').writeAsStringSync(
    File(
      '${client.path}/pubspec.yaml',
    ).readAsStringSync().replaceAll('resolution: workspace\n', ''),
  );
  File('${root.path}/pubspec.lock').copySync('${stage.path}/pubspec.lock');
  await run('dart', ['pub', 'get', '--enforce-lockfile'], stage);
  await run('dart', ['run', 'build_runner', 'build'], stage);
  await run('dart', ['format', 'lib'], stage);
}

Future<void> main(List<String> args) async {
  Directory.current = root;
  if (args.length != 1 ||
      ![
        'generate',
        'check',
        'check-fast',
        'format',
        'check-drift',
      ].contains(args.single)) {
    stderr.writeln(
      'Usage: dart tool/http.dart generate|check|check-fast|format|check-drift (E1 only)',
    );
    exitCode = 64;
    return;
  }
  try {
    if (!Platform.version.startsWith('3.12.2 ')) {
      throw StateError('Use Dart 3.12.2 (Flutter 3.44.8, pinned in .fvmrc).');
    }
    if (args.single == 'format') {
      await run('dart', [
        'format',
        'tool/http.dart',
        'packages/api_client/test',
      ], root);
      return;
    }
    if (args.single == 'check-drift') {
      compare(
        snapshot(Directory('${generated.path}/dart/lib')),
        snapshot(Directory('${client.path}/lib')),
        'Dart binding drift',
      );
      return;
    }
    final gradle =
        '${root.path}/${Platform.isWindows ? 'gradlew.bat' : 'gradlew'}';
    await run('dart', ['pub', 'get', '--enforce-lockfile'], root);
    await run(gradle, [
      'clean',
      'generateJavaHttp',
      'generateDartHttp',
      ':backend:test',
      '--console=plain',
      '--rerun-tasks',
    ], root);
    await dartGeneration();
    final firstJava = snapshot(
      Directory('${generated.path}/java'),
      suffix: '.java',
    );
    final firstDart = snapshot(Directory('${generated.path}/dart/lib'));
    if (args.single == 'generate') {
      // Only this generator-owned directory is replaced; tests and manifests are hand-written.
      final target = Directory('${client.path}/lib');
      if (target.existsSync()) {
        final resolved = target.resolveSymbolicLinksSync();
        final workspace = root.resolveSymbolicLinksSync();
        final intended =
            '$workspace${Platform.pathSeparator}packages${Platform.pathSeparator}api_client${Platform.pathSeparator}lib';
        if (resolved != intended) {
          throw StateError(
            'Refusing to replace generated files outside $intended',
          );
        }
        target.deleteSync(recursive: true);
      }
      for (final entry in firstDart.entries) {
        final file = File('${target.path}/${entry.key}');
        file.parent.createSync(recursive: true);
        file.writeAsBytesSync(entry.value);
      }
      stdout.writeln('Generated ${firstDart.length} Dart files.');
      return;
    }
    compare(
      firstDart,
      snapshot(Directory('${client.path}/lib')),
      'Dart binding drift',
    );
    await run(gradle, [
      'generateJavaHttp',
      'generateDartHttp',
      '--rerun-tasks',
      '--console=plain',
    ], root);
    await dartGeneration();
    compare(
      firstJava,
      snapshot(Directory('${generated.path}/java'), suffix: '.java'),
      'Java determinism',
    );
    compare(
      firstDart,
      snapshot(Directory('${generated.path}/dart/lib')),
      'Dart determinism',
    );
    await run('dart', [
      'format',
      '--output=none',
      '--set-exit-if-changed',
      'tool/http.dart',
      'packages/api_client/test',
    ], root);
    await run('dart', [
      'analyze',
      '--fatal-infos',
      'tool/http.dart',
      'packages/api_client/test',
    ], root);
    await run('dart', ['test'], client);
    stdout.writeln(
      'E1 checks passed. This is not bootstrap or foundation acceptance.',
    );
  } catch (error) {
    stderr.writeln(error);
    exitCode = error is ProcessException && error.errorCode > 0
        ? error.errorCode
        : 1;
  }
}
