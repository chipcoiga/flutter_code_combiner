import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:yaml/yaml.dart';

class CodeCombiner {
  final String projectDir;
  final Set<String> processedFiles = {};
  final StringBuffer combinedCode = StringBuffer();

  CodeCombiner(this.projectDir);

  Future<void> combine() async {
    // Add project information
    await _addProjectInfo();

    // Process lib directory
    await _processDirectory(path.join(projectDir, 'lib'));

    // Process test directory if exists
    final testDir = path.join(projectDir, 'test');
    if (await Directory(testDir).exists()) {
      await _processDirectory(testDir);
    }
  }

  Future<void> _addProjectInfo() async {
    final pubspecFile = File(path.join(projectDir, 'pubspec.yaml'));
    if (await pubspecFile.exists()) {
      final content = await pubspecFile.readAsString();
      final pubspec = loadYaml(content);

      combinedCode.writeln('// Project: ${pubspec['name']}');
      combinedCode.writeln('// Version: ${pubspec['version']}');
      combinedCode.writeln('// Description: ${pubspec['description']}');
      combinedCode.writeln('\n// Dependencies:');

      final deps = pubspec['dependencies'] as YamlMap;
      deps.forEach((key, value) {
        combinedCode.writeln('// - $key: $value');
      });

      combinedCode.writeln('\n// Combined Flutter Code:\n');
    }
  }

  Future<void> _processDirectory(String dirPath) async {
    final dir = Directory(dirPath);
    if (!await dir.exists()) return;

    await for (final entity in dir.list(recursive: true)) {
      if (entity is File && entity.path.endsWith('.dart')) {
        await _processFile(entity);
      }
    }
  }

  Future<void> _processFile(File file) async {
    final relativePath = path.relative(file.path, from: projectDir);
    if (processedFiles.contains(relativePath)) return;

    processedFiles.add(relativePath);

    final content = await file.readAsString();
    combinedCode
      ..writeln('\n// File: $relativePath')
      ..writeln('// ${'-' * 80}')
      ..writeln(content);
  }

  String getResult() => combinedCode.toString();
}

class FlutterCodeCombiner {
  static Future<String> combineProject(String projectPath) async {
    // Verify directory exists
    if (!await Directory(projectPath).exists()) {
      throw FileSystemException('Directory not found', projectPath);
    }

    final combiner = CodeCombiner(projectPath);
    await combiner.combine();
    return combiner.getResult();
  }
}
