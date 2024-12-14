import 'dart:io';
import 'package:args/args.dart';
import 'package:flutter_code_combiner/flutter_code_combiner.dart';
import 'package:logging/logging.dart';

void main(List<String> arguments) async {
  // Setup logging
  Logger.root.level = Level.INFO;
  Logger.root.onRecord.listen((record) {
    stderr.writeln('${record.level.name}: ${record.message}');
  });

  final logger = Logger('flutter_code_combiner');
  final parser = ArgParser()
    ..addOption('input', abbr: 'i', help: 'Input Flutter project directory')
    ..addOption('output', abbr: 'o', help: 'Output file path')
    ..addFlag('help', abbr: 'h', help: 'Show help', negatable: false);

  try {
    final args = parser.parse(arguments);

    if (args['help'] || args['input'] == null) {
      stderr.writeln(
          'Usage: flutter_code_combiner --input <project_dir> --output <output_file>');
      stderr.writeln(parser.usage);
      exit(0);
    }

    final inputDir = args['input'] as String;
    final outputFile = args['output'] as String? ?? 'combined_code.txt';

    final combined = await FlutterCodeCombiner.combineProject(inputDir);

    final output = File(outputFile);
    await output.writeAsString(combined);

    logger.info('Combined code written to: ${output.absolute.path}');
  } catch (e) {
    logger.severe('Error: $e');
    exit(1);
  }
}
