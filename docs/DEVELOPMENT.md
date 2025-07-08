# 🛠️ Development Guide

## Overview

This guide provides comprehensive information for developers working on WhatsApp Direct Pro. It covers setup, development workflow, best practices, and contribution guidelines.

## 🚀 Quick Start

### Prerequisites

Ensure you have the following installed on your development machine:

```bash
# Required
Flutter SDK (3.8.1+)
Dart SDK (3.0+)
Git

# Platform-specific
Android Studio + Android SDK (for Android)
Xcode (for iOS - macOS only)
Chrome (for Web development)
```

### Development Environment Setup

1. **Clone the Repository**

   ```bash
   git clone https://github.com/yourusername/whats_direct_pro.git
   cd whats_direct_pro
   ```

2. **Install Dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate App Icons**

   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Verify Setup**

   ```bash
   flutter doctor
   flutter devices
   ```

5. **Run the App**

   ```bash
   # Development mode with hot reload
   flutter run

   # Specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d chrome
   ```

## 🏗️ Project Structure Deep Dive

### Core Directories

```
lib/
├── main.dart                    # App entry point and configuration
├── models/                      # Data models and business entities
│   └── country.dart            # Country data model
├── provider/                    # State management using Provider pattern
│   ├── theme_provider.dart     # Theme state management
│   └── save_number_provider.dart # Number history management
├── screens/                     # UI screens and pages
│   ├── splash/                 # App initialization screen
│   ├── home/                   # Main functionality
│   ├── setting/                # App preferences
│   └── about/                  # App information
├── theme/                       # Theme configuration and styling
│   └── custom_theme.dart       # Centralized theme definitions
└── widgets/                     # Reusable UI components
    └── country_code_picker.dart # Custom country selector
```

### Supporting Directories

```
assets/                          # Static assets
├── icons/                      # App icons and graphics
│   └── logo.png               # Main app logo
android/                        # Android platform configuration
ios/                           # iOS platform configuration
web/                           # Web platform configuration
windows/                       # Windows desktop configuration
linux/                         # Linux desktop configuration
macos/                         # macOS desktop configuration
docs/                          # Documentation files
test/                          # Test files
```

## 💻 Development Workflow

### 1. Feature Development Process

```bash
# 1. Create feature branch
git checkout -b feature/your-feature-name

# 2. Make changes
# Edit code, add tests, update documentation

# 3. Test locally
flutter test
flutter run

# 4. Commit changes
git add .
git commit -m "feat: add your feature description"

# 5. Push and create PR
git push origin feature/your-feature-name
```

### 2. Code Quality Checks

```bash
# Format code
flutter format .

# Analyze code
flutter analyze

# Run tests
flutter test

# Check test coverage
flutter test --coverage
```

### 3. Hot Reload Development

```bash
# Start app with hot reload
flutter run

# Hot reload (saves state)
r

# Hot restart (resets state)
R

# Quit
q
```

## 🧪 Testing Strategy

### Test Structure

```
test/
├── widget_test.dart            # Widget testing examples
├── unit/                       # Unit tests
│   ├── providers/             # Provider unit tests
│   ├── models/                # Model unit tests
│   └── utils/                 # Utility function tests
├── integration/               # Integration tests
│   └── app_test.dart         # Full app integration tests
└── golden/                    # Golden file tests
    └── widget_golden_test.dart # UI consistency tests
```

### Running Tests

```bash
# All tests
flutter test

# Specific test file
flutter test test/unit/providers/theme_provider_test.dart

# With coverage
flutter test --coverage

# Integration tests
flutter test integration_test/

# Golden tests (update)
flutter test --update-goldens
```

### Writing Tests

#### Unit Test Example

```dart
import 'package:flutter_test/flutter_test.dart';
import 'package:whats_direct_pro/provider/theme_provider.dart';

void main() {
  group('ThemeProvider', () {
    late ThemeProvider themeProvider;

    setUp(() {
      themeProvider = ThemeProvider();
    });

    test('should start with light theme', () {
      expect(themeProvider.isDarkMode, false);
    });

    test('should toggle theme correctly', () {
      themeProvider.toggleTheme();
      expect(themeProvider.isDarkMode, true);
    });
  });
}
```

#### Widget Test Example

```dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:whats_direct_pro/screens/home/home_screen.dart';

void main() {
  testWidgets('HomeScreen displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(home: HomeScreen()),
    );

    expect(find.text('WhatsApp Direct Pro'), findsOneWidget);
    expect(find.byType(TextFormField), findsWidgets);
  });
}
```

## 🎨 Code Style Guidelines

### Dart Style Guide

Follow the [official Dart style guide](https://dart.dev/guides/language/effective-dart/style):

```dart
// Good: Use lowerCamelCase for variables, functions, parameters
String phoneNumber = '+1234567890';
void sendMessage() { }

// Good: Use UpperCamelCase for classes, enums, typedefs
class CountryCodePicker extends StatefulWidget { }
enum ThemeMode { light, dark }

// Good: Use lowercase_with_underscores for libraries, packages
import 'package:whats_direct_pro/theme/custom_theme.dart';
```

### Flutter-Specific Guidelines

```dart
// Prefer const constructors
const Text('Hello World')

// Use meaningful widget names
class CountryCodePicker extends StatefulWidget { }

// Organize imports
import 'dart:async';                    // Dart SDK
import 'package:flutter/material.dart'; // Flutter
import 'package:provider/provider.dart'; // Third-party
import '../models/country.dart';        // Relative imports
```

### Code Organization

```dart
class ExampleWidget extends StatefulWidget {
  // 1. Constructor and final fields
  const ExampleWidget({
    Key? key,
    required this.title,
  }) : super(key: key);

  final String title;

  // 2. createState method
  @override
  _ExampleWidgetState createState() => _ExampleWidgetState();
}

class _ExampleWidgetState extends State<ExampleWidget> {
  // 3. State variables
  bool _isLoading = false;
  final _controller = TextEditingController();

  // 4. Lifecycle methods
  @override
  void initState() {
    super.initState();
    // Initialization code
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  // 5. Helper methods
  void _handleSubmit() {
    // Implementation
  }

  // 6. Build method
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Widget tree
    );
  }
}
```

## 🏛️ Architecture Patterns

### State Management with Provider

```dart
// 1. Create a ChangeNotifier
class ThemeProvider extends ChangeNotifier {
  bool _isDarkMode = false;

  bool get isDarkMode => _isDarkMode;

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners();
  }
}

// 2. Provide at app level
MultiProvider(
  providers: [
    ChangeNotifierProvider(create: (_) => ThemeProvider()),
  ],
  child: MyApp(),
)

// 3. Consume in widgets
Consumer<ThemeProvider>(
  builder: (context, themeProvider, child) {
    return Switch(
      value: themeProvider.isDarkMode,
      onChanged: (_) => themeProvider.toggleTheme(),
    );
  },
)
```

### Theme Management

```dart
// Centralized theme access
class AppThemes {
  static Color getPrimaryTextColor(bool isDark) {
    return isDark ? darkPrimaryText : lightPrimaryText;
  }
}

// Usage in widgets
Text(
  'Hello World',
  style: TextStyle(
    color: AppThemes.getPrimaryTextColor(
      Theme.of(context).brightness == Brightness.dark,
    ),
  ),
)
```

### Error Handling

```dart
// Repository pattern for API calls
class WhatsAppService {
  static Future<void> openWhatsApp(String phone, String message) async {
    try {
      final url = Uri.parse('https://wa.me/$phone?text=${Uri.encodeFull(message)}');

      if (await canLaunchUrl(url)) {
        await launchUrl(url, mode: LaunchMode.externalApplication);
      } else {
        throw WhatsAppException('Could not launch WhatsApp');
      }
    } catch (e) {
      throw WhatsAppException('Error opening WhatsApp: $e');
    }
  }
}

// Custom exception
class WhatsAppException implements Exception {
  final String message;
  WhatsAppException(this.message);

  @override
  String toString() => 'WhatsAppException: $message';
}
```

## 🔧 Build Configuration

### Build Commands

```bash
# Development builds
flutter run --debug
flutter run --profile
flutter run --release

# Production builds
flutter build apk --release
flutter build appbundle --release
flutter build ios --release
flutter build web --release

# Build for specific architecture
flutter build apk --target-platform android-arm64
flutter build apk --split-per-abi
```

### Build Configuration Files

#### `pubspec.yaml` Configuration

```yaml
name: whats_direct_pro
description: Send WhatsApp messages without saving contacts
version: 1.0.0+1

environment:
  sdk: ^3.8.1

dependencies:
  flutter:
    sdk: flutter
  # Add dependencies here

dev_dependencies:
  flutter_test:
    sdk: flutter
  # Add dev dependencies here

flutter:
  uses-material-design: true
  assets:
    - assets/icons/
```

#### Android Configuration (`android/app/build.gradle`)

```gradle
android {
    compileSdkVersion 34

    defaultConfig {
        applicationId "com.yourcompany.whats_direct_pro"
        minSdkVersion 21
        targetSdkVersion 34
        versionCode 1
        versionName "1.0.0"
    }
}
```

#### iOS Configuration (`ios/Runner/Info.plist`)

```xml
<key>CFBundleDisplayName</key>
<string>WhatsApp Direct Pro</string>
<key>CFBundleVersion</key>
<string>1.0.0</string>
```

## 🚀 Deployment

### Android Deployment

1. **Generate Signing Key**

   ```bash
   keytool -genkey -v -keystore ~/upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
   ```

2. **Configure Signing** (`android/key.properties`)

   ```properties
   storePassword=yourStorePassword
   keyPassword=yourKeyPassword
   keyAlias=upload
   storeFile=upload-keystore.jks
   ```

3. **Build Release**
   ```bash
   flutter build appbundle --release
   ```

### iOS Deployment

1. **Configure Xcode Project**

   - Open `ios/Runner.xcworkspace`
   - Configure signing & capabilities
   - Set deployment target

2. **Build for App Store**
   ```bash
   flutter build ios --release
   ```

### Web Deployment

```bash
# Build for web
flutter build web --release

# Deploy to Firebase Hosting (example)
firebase deploy --only hosting
```

## 📊 Performance Optimization

### Best Practices

1. **Widget Performance**

   ```dart
   // Use const constructors
   const Text('Static text')

   // Use keys for dynamic lists
   ListView.builder(
     itemBuilder: (context, index) => ListTile(
       key: ValueKey(items[index].id),
       // ...
     ),
   )
   ```

2. **Image Optimization**

   ```dart
   // Use appropriate image formats
   Image.asset('assets/icons/logo.png')

   // Cache network images
   CachedNetworkImage(imageUrl: url)
   ```

3. **State Management**
   ```dart
   // Use Selector for specific updates
   Selector<ThemeProvider, bool>(
     selector: (context, provider) => provider.isDarkMode,
     builder: (context, isDarkMode, child) {
       // Only rebuilds when isDarkMode changes
     },
   )
   ```

### Performance Monitoring

```bash
# Profile performance
flutter run --profile

# Analyze bundle size
flutter build apk --analyze-size

# Memory profiling
flutter run --profile --enable-software-rendering
```

## 🐛 Debugging

### Debug Tools

```bash
# Flutter Inspector
flutter run
# Then press 'I' in terminal or use IDE tools

# Debug console
print('Debug message');
debugPrint('Debug message with stack trace');

# Assert for development
assert(phoneNumber.isNotEmpty, 'Phone number cannot be empty');
```

### Common Issues

1. **Hot Reload Issues**

   ```bash
   # Full restart
   flutter run --hot
   # Press 'R' for hot restart
   ```

2. **Dependency Conflicts**

   ```bash
   flutter pub deps
   flutter pub upgrade
   flutter clean && flutter pub get
   ```

3. **Platform Issues**
   ```bash
   # Clean and rebuild
   flutter clean
   flutter pub get
   flutter run
   ```

## 📝 Documentation

### Code Documentation

```dart
/// A custom widget for selecting country codes.
///
/// This widget displays a country flag, name, and code,
/// and allows users to search and select from available countries.
class CountryCodePicker extends StatefulWidget {
  /// The currently selected country code (e.g., '+91').
  final String selectedCountryCode;

  /// Callback function called when a country is selected.
  final Function(Country) onCountrySelected;

  /// Whether the picker is enabled for interaction.
  final bool enabled;

  const CountryCodePicker({
    Key? key,
    required this.selectedCountryCode,
    required this.onCountrySelected,
    this.enabled = true,
  }) : super(key: key);
}
```

### Generate Documentation

```bash
# Generate API documentation
dart doc

# Serve documentation locally
dart doc --serve
```

## 🤝 Contributing

### Contribution Workflow

1. **Fork the repository**
2. **Create a feature branch**

   ```bash
   git checkout -b feature/your-feature-name
   ```

3. **Make your changes**

   - Follow code style guidelines
   - Add tests for new functionality
   - Update documentation

4. **Test your changes**

   ```bash
   flutter test
   flutter analyze
   ```

5. **Commit your changes**

   ```bash
   git commit -m "feat: add your feature description"
   ```

6. **Push and create pull request**
   ```bash
   git push origin feature/your-feature-name
   ```

### Commit Message Format

```
type(scope): description

body (optional)

footer (optional)
```

Types:

- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation changes
- `style`: Code style changes
- `refactor`: Code refactoring
- `test`: Adding or updating tests
- `chore`: Build process or auxiliary tool changes

Examples:

```
feat(theme): add dark mode support
fix(validation): correct phone number validation
docs(readme): update installation instructions
```

## 🔍 Troubleshooting

### Common Development Issues

1. **Flutter Version Issues**

   ```bash
   flutter --version
   flutter upgrade
   flutter doctor
   ```

2. **Dependency Issues**

   ```bash
   flutter pub cache repair
   flutter clean
   flutter pub get
   ```

3. **Platform-Specific Issues**

   ```bash
   # Android
   flutter clean
   cd android && ./gradlew clean

   # iOS
   cd ios && rm -rf Pods/ Podfile.lock
   flutter clean && flutter pub get
   cd ios && pod install
   ```

### Getting Help

- **Flutter Documentation**: https://docs.flutter.dev
- **Stack Overflow**: Tag questions with `flutter`
- **GitHub Issues**: For project-specific issues
- **Flutter Community**: Discord, Reddit, etc.

This development guide provides everything needed to contribute effectively to WhatsApp Direct Pro!
