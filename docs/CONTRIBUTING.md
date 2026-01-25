# 🤝 Contributing to WhatsApp Direct Pro

Thank you for your interest in contributing to WhatsApp Direct Pro! This document provides guidelines and information for contributors.

## 📋 Table of Contents

- [Code of Conduct](#code-of-conduct)
- [Getting Started](#getting-started)
- [How to Contribute](#how-to-contribute)
- [Development Workflow](#development-workflow)
- [Coding Standards](#coding-standards)
- [Testing Guidelines](#testing-guidelines)
- [Documentation](#documentation)
- [Pull Request Process](#pull-request-process)
- [Issue Reporting](#issue-reporting)
- [Community Guidelines](#community-guidelines)

## 📜 Code of Conduct

This project follows a Code of Conduct to ensure a welcoming environment for all contributors:

### Our Pledge

- **Be respectful**: Treat everyone with respect and kindness
- **Be inclusive**: Welcome contributors from all backgrounds
- **Be collaborative**: Work together towards common goals
- **Be professional**: Maintain professional communication

### Unacceptable Behavior

- Harassment, discrimination, or offensive language
- Personal attacks or trolling
- Publishing private information without permission
- Any conduct that would be inappropriate in a professional setting

### Enforcement

Instances of unacceptable behavior may be reported to the project maintainers. All complaints will be reviewed and investigated promptly and fairly.

## 🚀 Getting Started

### Prerequisites

Before contributing, ensure you have:

1. **Flutter Development Environment**

   ```bash
   flutter --version  # Should be 3.8.1 or higher
   dart --version     # Should be 3.0 or higher
   ```

2. **Git Configuration**

   ```bash
   git config --global user.name "Your Name"
   git config --global user.email "your.email@example.com"
   ```

3. **IDE Setup**
   - VS Code with Flutter and Dart extensions
   - OR Android Studio with Flutter plugin
   - OR any editor with Dart/Flutter support

### First-Time Setup

1. **Fork the Repository**

   - Go to the [WhatsApp Direct Pro repository](https://github.com/yourusername/whats_direct_pro)
   - Click "Fork" in the top-right corner
   - Clone your fork locally

2. **Set Up Local Development**

   ```bash
   git clone https://github.com/YOUR_USERNAME/whats_direct_pro.git
   cd whats_direct_pro
   git remote add upstream https://github.com/ORIGINAL_OWNER/whats_direct_pro.git
   ```

3. **Install Dependencies**

   ```bash
   flutter pub get
   flutter pub run flutter_launcher_icons
   ```

4. **Verify Setup**
   ```bash
   flutter doctor
   flutter test
   flutter run
   ```

## 🛠️ How to Contribute

### Types of Contributions

We welcome various types of contributions:

#### 🐛 Bug Fixes

- Fix existing issues
- Improve error handling
- Resolve performance problems
- Platform-specific fixes

#### ✨ New Features

- Add new functionality
- Enhance existing features
- Improve user experience
- Add platform support

#### 📚 Documentation

- Improve existing documentation
- Add missing documentation
- Create tutorials and guides
- Fix typos and clarity issues

#### 🎨 Design Improvements

- UI/UX enhancements
- Accessibility improvements
- Visual design updates
- Animation and interaction improvements

#### 🧪 Testing

- Add unit tests
- Improve test coverage
- Add integration tests
- Performance testing

#### 🔧 Infrastructure

- CI/CD improvements
- Build process enhancements
- Development tooling
- Code quality improvements

### Finding Issues to Work On

1. **Good First Issues**: Look for issues labeled `good first issue`
2. **Help Wanted**: Issues labeled `help wanted` need community support
3. **Bug Reports**: Issues labeled `bug` need fixing
4. **Feature Requests**: Issues labeled `enhancement` for new features

## 🔄 Development Workflow

### 1. Create a Feature Branch

```bash
# Update your main branch
git checkout main
git pull upstream main

# Create a new branch
git checkout -b feature/your-feature-name
# OR
git checkout -b fix/issue-description
# OR
git checkout -b docs/documentation-update
```

### 2. Make Your Changes

- Write clean, well-documented code
- Follow coding standards (see below)
- Add tests for new functionality
- Update documentation as needed

### 3. Test Your Changes

```bash
# Run all tests
flutter test

# Run specific tests
flutter test test/unit/providers/theme_provider_test.dart

# Test on different platforms
flutter run -d android
flutter run -d ios
flutter run -d chrome
```

### 4. Commit Your Changes

Use conventional commit messages:

```bash
# Format: type(scope): description
git commit -m "feat(theme): add dark mode toggle animation"
git commit -m "fix(validation): correct phone number validation regex"
git commit -m "docs(readme): update installation instructions"
```

**Commit Types:**

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes (formatting, etc.)
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes

### 5. Push and Create Pull Request

```bash
git push origin feature/your-feature-name
```

Then create a Pull Request through GitHub's interface.

## 📝 Coding Standards

### Dart Style Guidelines

Follow the [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style):

```dart
// ✅ Good: Use lowerCamelCase for variables and functions
String phoneNumber = '+1234567890';
void sendMessage() { }

// ✅ Good: Use UpperCamelCase for classes and enums
class CountryCodePicker extends StatefulWidget { }
enum ThemeMode { light, dark }

// ✅ Good: Use descriptive names
final TextEditingController phoneNumberController = TextEditingController();

// ❌ Bad: Unclear abbreviations
final TextEditingController pnCtrl = TextEditingController();
```

### Flutter-Specific Guidelines

```dart
// ✅ Prefer const constructors
const Text('Static text')

// ✅ Use meaningful widget names
class CountryCodePicker extends StatefulWidget { }

// ✅ Organize imports properly
import 'dart:async';                    // Dart SDK
import 'package:flutter/material.dart'; // Flutter
import 'package:provider/provider.dart'; // Third-party
import '../models/country.dart';        // Relative imports

// ✅ Use proper widget hierarchy
class ExampleWidget extends StatelessWidget {
  const ExampleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Example')),
      body: Column(
        children: [
          // Widget children
        ],
      ),
    );
  }
}
```

### Code Organization

```dart
class ExampleStatefulWidget extends StatefulWidget {
  // 1. Constructor and final fields
  const ExampleStatefulWidget({
    Key? key,
    required this.title,
    this.onTap,
  }) : super(key: key);

  final String title;
  final VoidCallback? onTap;

  // 2. createState method
  @override
  _ExampleStatefulWidgetState createState() => _ExampleStatefulWidgetState();
}

class _ExampleStatefulWidgetState extends State<ExampleStatefulWidget> {
  // 3. State variables (grouped by type)
  bool _isLoading = false;
  String _errorMessage = '';

  // 4. Controllers and focus nodes
  final _textController = TextEditingController();
  final _focusNode = FocusNode();

  // 5. Lifecycle methods (in order)
  @override
  void initState() {
    super.initState();
    _initializeWidget();
  }

  @override
  void didUpdateWidget(ExampleStatefulWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Handle widget updates
  }

  @override
  void dispose() {
    _textController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  // 6. Helper methods (private)
  void _initializeWidget() {
    // Initialization logic
  }

  void _handleSubmit() {
    // Submit logic
  }

  Future<void> _loadData() async {
    // Async operations
  }

  // 7. Build method (last)
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget tree
    );
  }
}
```

### Naming Conventions

```dart
// ✅ Files: lowercase_with_underscores
// country_code_picker.dart
// theme_provider.dart

// ✅ Classes: UpperCamelCase
class CountryCodePicker { }
class ThemeProvider { }

// ✅ Variables and functions: lowerCamelCase
String phoneNumber;
void sendMessage();

// ✅ Constants: lowerCamelCase or SCREAMING_SNAKE_CASE
const double fontSizeLarge = 16.0;
const String API_BASE_URL = 'https://api.example.com';

// ✅ Private members: start with underscore
String _privateVariable;
void _privateMethod();
```

## 🧪 Testing Guidelines

### Test Structure

Write tests for all new functionality:

```dart
// test/unit/providers/theme_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:whats_direct_pro/provider/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    tearDown(() {
      // Cleanup if needed
    });

    test('should initialize with light theme', () {
      expect(themeProvider.isDarkMode, false);
    });

    test('should toggle theme correctly', () {
      // Arrange
      expect(themeProvider.isDarkMode, false);

      // Act
      themeProvider.toggleTheme();

      // Assert
      expect(themeProvider.isDarkMode, true);
    });

    test('should notify listeners when theme changes', () {
      // Arrange
      bool notified = false;
      themeProvider.addListener(() => notified = true);

      // Act
      themeProvider.toggleTheme();

      // Assert
      expect(notified, true);
    });
  });
}
```

### Widget Testing

```dart
// test/widget/home_screen_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:whats_direct_pro/screens/home/home_screen.dart';
import 'package:whats_direct_pro/provider/theme_provider.dart';

void main() {
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ],
        child: MaterialApp(
          home: HomeScreen(),
        ),
      ),
    );

    // Assert
    expect(find.text('WhatsApp Direct Pro'), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
    expect(find.text('Phone Number'), findsOneWidget);
  });

  testWidgets('should validate phone number input', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(/* setup widget */);

    // Act
    await tester.enterText(find.byType(TextFormField).first, '123');
    await tester.tap(find.text('WhatsApp'));
    await tester.pump();

    // Assert
    expect(find.text('Please enter a Valid phone number'), findsOneWidget);
  });
}
```

### Test Coverage

Aim for high test coverage:

```bash
# Run tests with coverage
flutter test --coverage

# View coverage report
genhtml coverage/lcov.info -o coverage/html
open coverage/html/index.html
```

**Coverage Targets:**

- **Unit Tests**: 90%+ coverage for business logic
- **Widget Tests**: Cover all major user interactions
- **Integration Tests**: Cover critical user flows

## 📚 Documentation

### Code Documentation

````dart
/// A custom widget for selecting country codes with search functionality.
///
/// This widget displays a list of countries with their flags, names, and codes.
/// Users can search through the list and select a country.
///
/// Example usage:
/// ```dart
/// CountryCodePicker(
///   selectedCountryCode: '+91',
///   onCountrySelected: (country) {
///     print('Selected: ${country.name}');
///   },
///   enabled: true,
/// )
/// ```
class CountryCodePicker extends StatefulWidget {
  /// The currently selected country code (e.g., '+91' for India).
  final String selectedCountryCode;

  /// Callback function invoked when a country is selected.
  ///
  /// The callback receives a [Country] object containing the selected
  /// country's information including name, code, and flag.
  final Function(Country) onCountrySelected;

  /// Whether the picker is enabled for user interaction.
  ///
  /// When disabled, the picker will not respond to user taps and
  /// will appear visually disabled.
  final bool enabled;

  /// Creates a [CountryCodePicker] widget.
  ///
  /// The [selectedCountryCode] and [onCountrySelected] parameters are required.
  /// The [enabled] parameter defaults to `true`.
  const CountryCodePicker({
    Key? key,
    required this.selectedCountryCode,
    required this.onCountrySelected,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}
````

### README Updates

When adding new features, update the README:

```markdown
## ✨ Features

### Core Features

- 📞 **Direct WhatsApp Messaging** - Send messages to any number instantly
- 🌍 **Country Code Picker** - Select from 200+ countries with flags
- 💬 **Message Composition** - Optional message text with validation
- 📱 **Quick Launch** - Direct WhatsApp integration
- 🆕 **Your New Feature** - Description of your new feature
```

## 🔍 Pull Request Process

### Before Submitting

1. **Check existing issues**: Ensure your change addresses an existing issue or create one
2. **Follow coding standards**: Use the coding guidelines above
3. **Add tests**: Include appropriate tests for your changes
4. **Update documentation**: Update relevant documentation
5. **Test thoroughly**: Test on multiple platforms if possible

### Pull Request Template

When creating a PR, use this template:

```markdown
## Description

Brief description of changes and why they were made.

## Type of Change

- [ ] Bug fix (non-breaking change which fixes an issue)
- [ ] New feature (non-breaking change which adds functionality)
- [ ] Breaking change (fix or feature that would cause existing functionality to not work as expected)
- [ ] Documentation update

## Related Issue

Fixes #[issue number]

## Testing

- [ ] Unit tests added/updated
- [ ] Widget tests added/updated
- [ ] Manual testing completed
- [ ] Tested on multiple platforms

## Screenshots (if applicable)

Add screenshots to help reviewers understand the changes.

## Checklist

- [ ] Code follows the style guidelines
- [ ] Self-review of code completed
- [ ] Code is commented where necessary
- [ ] Documentation updated
- [ ] Tests added and passing
- [ ] No breaking changes (or clearly documented)
```

### Review Process

1. **Automated Checks**: CI/CD will run tests and checks
2. **Code Review**: Maintainers will review your code
3. **Feedback**: Address any requested changes
4. **Approval**: Once approved, your PR will be merged
5. **Cleanup**: Delete your feature branch after merge

### Review Criteria

Reviewers will check for:

- **Functionality**: Does the code work as expected?
- **Code Quality**: Is the code clean and well-structured?
- **Testing**: Are there adequate tests?
- **Documentation**: Is documentation updated?
- **Performance**: Does it impact app performance?
- **Accessibility**: Does it maintain accessibility standards?
- **Platform Compatibility**: Does it work across platforms?

## 🐛 Issue Reporting

### Bug Reports

Use this template for bug reports:

```markdown
## Bug Description

A clear and concise description of what the bug is.

## Steps to Reproduce

1. Go to '...'
2. Click on '....'
3. Scroll down to '....'
4. See error

## Expected Behavior

A clear description of what you expected to happen.

## Actual Behavior

A clear description of what actually happened.

## Screenshots

If applicable, add screenshots to help explain your problem.

## Environment

- **Device**: [e.g. iPhone 13, Samsung Galaxy S21]
- **OS**: [e.g. iOS 15.0, Android 12]
- **App Version**: [e.g. 1.0.0]
- **Flutter Version**: [e.g. 3.8.1]

## Additional Context

Add any other context about the problem here.
```

### Feature Requests

Use this template for feature requests:

```markdown
## Feature Description

A clear and concise description of the feature you'd like to see.

## Problem Statement

What problem does this feature solve? Is your feature request related to a problem?

## Proposed Solution

Describe the solution you'd like to see implemented.

## Alternative Solutions

Describe any alternative solutions or features you've considered.

## Additional Context

Add any other context, screenshots, or examples about the feature request.

## Implementation Notes

If you have ideas about how this could be implemented, share them here.
```

## 🌟 Community Guidelines

### Communication

- **Be respectful**: Treat all community members with respect
- **Be patient**: Remember that people volunteer their time
- **Be helpful**: Help others when you can
- **Be constructive**: Provide actionable feedback

### Getting Help

1. **Check documentation**: Read existing docs first
2. **Search issues**: Look for existing discussions
3. **Ask questions**: Use GitHub Discussions for questions
4. **Be specific**: Provide detailed information when asking for help

### Recognition

Contributors are recognized in several ways:

- **Contributors file**: Listed in CONTRIBUTORS.md
- **Release notes**: Mentioned in changelog
- **GitHub profile**: Contributions show on your GitHub profile
- **Community recognition**: Acknowledged in community communications

## 🎉 Thank You!

Thank you for contributing to WhatsApp Direct Pro! Your contributions help make this project better for everyone. Whether you're fixing a small typo or adding a major feature, every contribution is valued and appreciated.

### Questions?

If you have any questions about contributing, feel free to:

- Open a [GitHub Discussion](https://github.com/yourusername/whats_direct_pro/discussions)
- Create an [issue](https://github.com/yourusername/whats_direct_pro/issues) with the `question` label
- Reach out to the maintainers

Happy coding! 🚀
