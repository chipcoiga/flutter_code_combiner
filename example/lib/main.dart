import 'dart:io';
import 'package:flutter_code_combiner/flutter_code_combiner.dart';

void main() async {
  // Example 1: Basic usage
  final combined = await FlutterCodeCombiner.combineProject('./');
  print(combined);

  // Example 2: Save to file
  final outputFile = File('combined_flutter_code.txt');
  await outputFile.writeAsString(combined);
  print('Code saved to: ${outputFile.absolute.path}');

  // Example 3: Error handling
  try {
    await FlutterCodeCombiner.combineProject('/invalid/path');
  } catch (e) {
    print('Error: $e');
  }
}
