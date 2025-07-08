# 📱 WhatsApp Direct Pro

<div align="center">
  <img src="assets/icons/logo.png" alt="WhatsApp Direct Pro Logo" width="128" height="128">
  
  [![Flutter](https://img.shields.io/badge/Flutter-3.8.1+-02569B?style=for-the-badge&logo=flutter&logoColor=white)](https://flutter.dev)
  [![Dart](https://img.shields.io/badge/Dart-3.0+-0175C2?style=for-the-badge&logo=dart&logoColor=white)](https://dart.dev)
  [![License](https://img.shields.io/badge/License-MIT-green?style=for-the-badge)](LICENSE)
  
  *Send WhatsApp messages directly without saving contacts*
</div>

## 📋 Table of Contents

- [Overview](#-overview)
- [Features](#-features)
- [Screenshots](#-screenshots)
- [Installation](#-installation)
- [Usage](#-usage)
- [Architecture](#-architecture)
- [Dependencies](#-dependencies)
- [Development](#-development)
- [Contributing](#-contributing)
- [License](#-license)

## 🎯 Overview

WhatsApp Direct Pro is a Flutter-based mobile application that allows users to send WhatsApp messages directly to any phone number without the need to save the contact first. The app provides a clean, modern interface with support for dark/light themes and maintains a history of previously contacted numbers.

### 🌟 Key Highlights

- **Direct Messaging**: Send WhatsApp messages without saving contacts
- **Country Code Support**: Comprehensive country code picker with flags
- **Theme Support**: Light and dark theme with system preference detection
- **Number History**: Optional saving and management of contacted numbers
- **Modern UI**: Clean, Material Design 3 compliant interface
- **Cross-Platform**: Available for Android, iOS, Web, and Desktop

## ✨ Features

### Core Features

- 📞 **Direct WhatsApp Messaging** - Send messages to any number instantly
- 🌍 **Country Code Picker** - Select from 200+ countries with flags
- 💬 **Message Composition** - Optional message text with validation
- 📱 **Quick Launch** - Direct WhatsApp integration

### UI/UX Features

- 🎨 **Dual Theme Support** - Light and dark themes
- 📐 **Responsive Design** - Adapts to different screen sizes
- 🎯 **Consistent Typography** - Unified font system across the app
- 🔄 **Smooth Animations** - Polished user experience

### Settings & Preferences

- 🌙 **Theme Toggle** - Switch between light/dark modes
- 📝 **Number History** - Toggle saving of contacted numbers
- 🌐 **Language Support** - Ready for internationalization
- 🗑️ **History Management** - Clear saved numbers

## 📱 Screenshots

<div align="center">
  <table>
    <tr>
      <td align="center">
        <img src="docs/screenshots/home_light.png" width="200" alt="Home Screen - Light">
        <br><em>Home Screen (Light)</em>
      </td>
      <td align="center">
        <img src="docs/screenshots/home_dark.png" width="200" alt="Home Screen - Dark">
        <br><em>Home Screen (Dark)</em>
      </td>
      <td align="center">
        <img src="docs/screenshots/settings.png" width="200" alt="Settings">
        <br><em>Settings Screen</em>
      </td>
    </tr>
  </table>
</div>

## 🚀 Installation

### Prerequisites

- Flutter SDK (3.8.1 or higher)
- Dart SDK (3.0 or higher)
- Android Studio / VS Code
- Android SDK (for Android development)
- Xcode (for iOS development on macOS)

### Getting Started

1. **Clone the repository**

   ```bash
   git clone https://github.com/yourusername/whats_direct_pro.git
   cd whats_direct_pro
   ```

2. **Install dependencies**

   ```bash
   flutter pub get
   ```

3. **Generate launcher icons**

   ```bash
   flutter pub run flutter_launcher_icons
   ```

4. **Run the app**

   ```bash
   # For development
   flutter run

   # For specific platform
   flutter run -d android
   flutter run -d ios
   flutter run -d chrome
   ```

### Building for Production

```bash
# Android APK
flutter build apk --release

# Android App Bundle
flutter build appbundle --release

# iOS
flutter build ios --release

# Web
flutter build web --release
```

## 📖 Usage

### Basic Usage

1. **Launch the App**: Open WhatsApp Direct Pro
2. **Enter Number**: Input the phone number (with or without country code)
3. **Select Country**: Use the country picker if needed
4. **Compose Message**: Add your message (optional)
5. **Send**: Tap the WhatsApp button to open WhatsApp

### Advanced Features

- **Theme Switching**: Access settings to toggle between light/dark modes
- **Number History**: Enable/disable saving of contacted numbers
- **Quick Actions**: Use the floating settings button for quick access

## 🏗️ Architecture

The app follows a clean architecture pattern with clear separation of concerns:

```
lib/
├── main.dart                 # App entry point
├── models/                   # Data models
│   └── country.dart         # Country model and data
├── provider/                 # State management
│   ├── theme_provider.dart  # Theme state management
│   └── save_number_provider.dart # Number history management
├── screens/                  # UI screens
│   ├── splash/              # Splash screen
│   ├── home/                # Main home screen
│   ├── settings/            # Settings screen
│   └── about/               # About screen
├── theme/                    # Theme configuration
│   └── custom_theme.dart    # Custom theme definitions
└── widgets/                  # Reusable widgets
    └── country_code_picker.dart # Country selection widget
```

### Key Components

#### 🎨 Theme System

- **Custom Theme**: Centralized theme management with consistent colors and fonts
- **Font Sizes**: Predefined font scale for consistency
- **Color Palette**: Comprehensive light/dark color schemes

#### 🗃️ State Management

- **Provider Pattern**: Used for theme and settings state
- **SharedPreferences**: Persistent storage for user preferences

#### 🧩 Widgets

- **Country Code Picker**: Custom widget with search functionality
- **Responsive Design**: Adapts to different screen sizes

## 📦 Dependencies

### Core Dependencies

- **`flutter`**: UI framework
- **`provider`**: State management
- **`url_launcher`**: WhatsApp integration
- **`shared_preferences`**: Local data persistence
- **`cupertino_icons`**: iOS-style icons

### Development Dependencies

- **`flutter_test`**: Testing framework
- **`flutter_launcher_icons`**: App icon generation

## 🛠️ Development

### Project Setup

1. **IDE Setup**: Configure your IDE with Flutter and Dart plugins
2. **Emulator**: Set up Android/iOS emulator or use physical device
3. **Debugging**: Use Flutter DevTools for debugging and performance

### Code Style

- Follow [Dart Style Guide](https://dart.dev/guides/language/effective-dart/style)
- Use `flutter format` for consistent formatting
- Implement proper null safety

### Testing

```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Run with coverage
flutter test --coverage
```

### Hot Reload

```bash
# Start with hot reload
flutter run

# In terminal, press:
# 'r' for hot reload
# 'R' for hot restart
# 'q' to quit
```

## 🤝 Contributing

We welcome contributions! Please follow these steps:

1. **Fork the repository**
2. **Create a feature branch**: `git checkout -b feature/amazing-feature`
3. **Commit changes**: `git commit -m 'Add amazing feature'`
4. **Push to branch**: `git push origin feature/amazing-feature`
5. **Open a Pull Request**

### Contribution Guidelines

- Follow the existing code style
- Add tests for new features
- Update documentation as needed
- Ensure all tests pass before submitting

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 📞 Support

For support and questions:

- **Issues**: [GitHub Issues](https://github.com/yourusername/whats_direct_pro/issues)
- **Discussions**: [GitHub Discussions](https://github.com/yourusername/whats_direct_pro/discussions)
- **Email**: your.email@example.com

## 🙏 Acknowledgments

- Flutter team for the amazing framework
- Material Design for UI guidelines
- Contributors and community members

---

<div align="center">
  Made with ❤️ by <a href="https://github.com/yourusername">Your Name</a>
</div>
