# Flutter Code Combiner

A powerful Flutter utility that combines your entire Flutter project's source code into a single, well-organized file. Perfect for working with AI tools, code analysis, and Large Language Models like ChatGPT, Claude, or Github Copilot.

## Installation

You can install this package in two ways:

### 1. From pub.dev

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_code_combiner: ^1.0.0-dev.1
```

Then run:
```bash
dart pub get
```

### 2. From Git

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  flutter_code_combiner:
    git:
      url: https://github.com/chipcoiga/flutter_code_combiner.git
      ref: master
```

## Usage

### Command Line Interface (CLI)

1. Activate the package globally:
```bash
dart pub global activate flutter_code_combiner
```

2. Run the command:
```bash
# Basic usage
flutter_code_combiner --input /path/to/flutter/project --output combined_code.txt

# Show help
flutter_code_combiner --help
```

### Programmatic Usage

```dart
import 'package:flutter_code_combiner/flutter_code_combiner.dart';

void main() async {
  try {
    // Combine project files
    final combined = await FlutterCodeCombiner.combineProject('/path/to/flutter/project');
    
    // Use the combined code
    print(combined);
    
    // Or save to file
    await File('combined_code.txt').writeAsString(combined);
  } catch (e) {
    print('Error: $e');
  }
}
```

## Output Format

The combined output includes:
1. Project metadata from pubspec.yaml
2. List of dependencies
3. All Dart files from:
   - lib/ directory
   - test/ directory (if exists)

Example output:
```
// Project: my_flutter_app
// Version: 1.0.0
// Description: A new Flutter project

// Dependencies:
// - flutter: sdk
// - cupertino_icons: ^1.0.2

// Combined Flutter Code:

// File: lib/main.dart
// ----------------
import 'package:flutter/material.dart';
...

// File: lib/src/widget.dart
// ----------------
class MyWidget extends StatelessWidget {
...
```

## Features

- Combines all Flutter/Dart files into a single organized file
- Preserves file structure information in comments
- Includes project metadata and dependencies
- Support for both CLI and programmatic usage
- Works with test files
- AI-friendly output format

## Use Cases

- Generate context for AI code assistants
- Create comprehensive code documentation
- Prepare code for LLM analysis
- Simplify code sharing and review
- Create backups with full project context

## Contributing

1. Fork the repository
2. Create your feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Troubleshooting

Common issues and solutions:

1. **Permission Denied**:
   ```bash
   chmod +x $(which flutter_code_combiner)
   ```

2. **Command Not Found**:
   Make sure the pub cache bin directory is in your PATH.
   ```bash
   export PATH="$PATH":"$HOME/.pub-cache/bin"
   ```

3. **Dart SDK Version Error**:
   Update your Dart SDK or use a compatible version as specified in pubspec.yaml.
