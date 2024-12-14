# Changelog

## 1.0.0

Initial release of flutter_code_combiner.

### Features
* Combine multiple Flutter/Dart files into a single file
* Support for processing entire Flutter project structure
* CLI tool for command-line usage
* Programmatic API for integration into other tools
* Preserve file structure information in comments
* Include project metadata and dependencies
* Support for test files
* AI-friendly output format

### Implementation Details
* Command-line interface with input/output options
* File processing with proper error handling
* Support for recursive directory scanning
* Handling of pubspec.yaml for project metadata
* Maintain original file paths in comments
* Skip duplicate files
* Process both lib/ and test/ directories

### Bug Fixes
* N/A - Initial release

### Dependencies
* Flutter SDK: ">=2.12.0 <4.0.0"
* path: ^1.8.0
* yaml: ^3.1.0
* args: ^2.3.0

## 1.0.1

Update Readme, add example
