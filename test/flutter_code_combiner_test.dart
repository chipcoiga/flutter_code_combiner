// test/flutter_code_combiner_test.dart
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_code_combiner/flutter_code_combiner.dart';
import 'package:path/path.dart' as path;

void main() {
  late Directory tempDir;

  setUp(() async {
    // Create a temporary directory for test files
    tempDir =
        await Directory.systemTemp.createTemp('flutter_code_combiner_test_');

    // Create a mock Flutter project structure
    await _createMockProject(tempDir.path);
  });

  tearDown(() async {
    // Clean up temporary directory after tests
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  test('combines Flutter project files correctly', () async {
    final combined = await FlutterCodeCombiner.combineProject(tempDir.path);

    // Check if output contains project information
    expect(combined, contains('// Project: test_project'));
    expect(combined, contains('// Version: 1.0.0'));

    // Check if all mock files are included
    expect(combined, contains('// File: lib/main.dart'));
    expect(combined, contains('void main() {'));
    expect(combined, contains('// File: lib/src/widget.dart'));
    expect(combined, contains('class TestWidget'));
  });

  test('handles empty directories gracefully', () async {
    final emptyDir = await Directory.systemTemp.createTemp('empty_test_');

    final combined = await FlutterCodeCombiner.combineProject(emptyDir.path);
    expect(combined.trim(), isEmpty);

    await emptyDir.delete(recursive: true);
  });

  test('handles missing pubspec.yaml gracefully', () async {
    final noPubspecDir =
        await Directory.systemTemp.createTemp('no_pubspec_test_');
    await File(path.join(noPubspecDir.path, 'lib/main.dart'))
        .create(recursive: true)
        .then((file) => file.writeAsString('void main() {}'));

    final combined =
        await FlutterCodeCombiner.combineProject(noPubspecDir.path);
    expect(combined, contains('void main()'));
    expect(combined, isNot(contains('// Project:')));

    await noPubspecDir.delete(recursive: true);
  });

  test('skips duplicate files', () async {
    // Create a duplicate file structure
    await _createDuplicateFiles(tempDir.path);

    final combined = await FlutterCodeCombiner.combineProject(tempDir.path);

    // Count occurrences of specific file markers
    final mainFileCount = '// File: lib/main.dart'.allMatches(combined).length;
    expect(mainFileCount, equals(1),
        reason: 'Duplicate files should be skipped');
  });

  test('processes test directory', () async {
    final combined = await FlutterCodeCombiner.combineProject(tempDir.path);

    expect(combined, contains('// File: test/widget_test.dart'));
    expect(combined, contains('void main() {'));
    expect(combined, contains('testWidgets'));
  });

  test('handles invalid project path', () async {
    await expectLater(
      FlutterCodeCombiner.combineProject('/invalid/path'),
      throwsA(isA<FileSystemException>()),
    );
  });
}

// Helper function to create mock project structure
Future<void> _createMockProject(String basePath) async {
  // Create pubspec.yaml
  await File(path.join(basePath, 'pubspec.yaml'))
      .create(recursive: true)
      .then((file) => file.writeAsString('''
name: test_project
description: A test Flutter project
version: 1.0.0
environment:
  sdk: ">=2.12.0 <4.0.0"
dependencies:
  flutter:
    sdk: flutter
'''));

  // Create main.dart
  await File(path.join(basePath, 'lib/main.dart'))
      .create(recursive: true)
      .then((file) => file.writeAsString('''
import 'package:flutter/material.dart';
void main() {
  runApp(MyApp());
}
'''));

  // Create widget file
  await File(path.join(basePath, 'lib/src/widget.dart'))
      .create(recursive: true)
      .then((file) => file.writeAsString('''
import 'package:flutter/material.dart';
class TestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) => Container();
}
'''));

  // Create test file
  await File(path.join(basePath, 'test/widget_test.dart'))
      .create(recursive: true)
      .then((file) => file.writeAsString('''
import 'package:flutter_test/flutter_test.dart';
void main() {
  testWidgets('Test widget', (WidgetTester tester) async {
    // Test code here
  });
}
'''));
}

// Helper function to create duplicate files
Future<void> _createDuplicateFiles(String basePath) async {
  // Create duplicate main.dart in different location
  await File(path.join(basePath, 'lib/duplicate/main.dart'))
      .create(recursive: true)
      .then((file) => file.writeAsString('''
void main() {
  // Duplicate content
}
'''));
}
