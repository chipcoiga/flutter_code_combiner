import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:args/args.dart';
import 'package:flutter_code_combiner/flutter_code_combiner.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Input Flutter project directory')
    ..addOption('output', abbr: 'o', help: 'Output file path')
    ..addFlag('help', abbr: 'h', help: 'Show help', negatable: false);

  try {
    final args = parser.parse(arguments);

    if (args['help'] || args['input'] == null) {
      print(
          'Usage: flutter_code_combiner --input <project_dir> --output <output_file>');
      print(parser.usage);
      exit(0);
    }

    final inputDir = args['input'] as String;
    final outputFile = args['output'] as String? ?? 'combined_code.txt';

    final combined = await FlutterCodeCombiner.combineProject(inputDir);

    final output = File(outputFile);
    await output.writeAsString(combined);

    print('Combined code written to: ${output.absolute.path}');
  } catch (e) {
    print('Error: $e');
    exit(1);
  }
}
