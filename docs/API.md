# 🚀 API Documentation

## Overview

WhatsApp Direct Pro primarily uses local functionality and system APIs. This document outlines the APIs and external integrations used in the application.

## 📱 External APIs & Integrations

### 1. WhatsApp URL Scheme API

**Purpose**: Launch WhatsApp with pre-filled message and phone number

**Implementation**: Using `url_launcher` package

**URL Format**:

```
https://wa.me/{phone}?text={message}
```

**Usage**:

```dart
Future<void> openWhatsApp(String phone, String message) async {
  final url = Uri.parse(
    'https://wa.me/$phone?text=${Uri.encodeFull(message)}',
  );

  if (await canLaunchUrl(url)) {
    await launchUrl(url, mode: LaunchMode.externalApplication);
  } else {
    throw 'Could not launch WhatsApp';
  }
}
```

**Parameters**:

- `phone` (required): Phone number with country code (e.g., "919876543210")
- `text` (optional): Pre-filled message text (URL encoded)

**Response**: Launches WhatsApp app or web version

### 2. SharedPreferences API

**Purpose**: Store user preferences locally

**Implementation**: Using `shared_preferences` package

**Stored Data**:

```dart
// Theme preference
static const String _isDarkModeKey = 'isDarkMode';

// Number history preference
static const String _saveNumberKey = 'saveNumber';

// Saved numbers list
static const String _savedNumbersKey = 'savedNumbers';
```

**Methods**:

```dart
// Save preference
await _prefs.setBool(_isDarkModeKey, isDarkMode);

// Read preference
bool isDarkMode = _prefs.getBool(_isDarkModeKey) ?? false;

// Save string list
await _prefs.setStringList(_savedNumbersKey, numbers);

// Read string list
List<String> numbers = _prefs.getStringList(_savedNumbersKey) ?? [];
```

## 🛠️ Internal APIs

### 1. Theme Provider API

**Purpose**: Manage application theme state

**Class**: `ThemeProvider`

**Methods**:

#### `toggleTheme()`

```dart
void toggleTheme()
```

- **Description**: Toggles between light and dark theme
- **Side Effects**: Updates UI and saves preference to SharedPreferences
- **Usage**: Called from settings switch

#### `loadThemePreference()`

```dart
Future<void> loadThemePreference()
```

- **Description**: Loads saved theme preference from storage
- **Returns**: Future that completes when preference is loaded
- **Usage**: Called during app initialization

**Properties**:

```dart
bool get isDarkMode // Current theme state (read-only)
```

**Example Usage**:

```dart
// Access provider
final themeProvider = Provider.of<ThemeProvider>(context);

// Toggle theme
themeProvider.toggleTheme();

// Check current theme
if (themeProvider.isDarkMode) {
  // Dark theme is active
}
```

### 2. Save Number Provider API

**Purpose**: Manage number history functionality

**Class**: `SaveNumberProvider`

**Methods**:

#### `toggleSaveNumber()`

```dart
void toggleSaveNumber()
```

- **Description**: Toggles number saving preference
- **Side Effects**: Updates setting and saves to SharedPreferences

#### `saveNumber(String number)`

```dart
void saveNumber(String number)
```

- **Description**: Saves a phone number to history
- **Parameters**: `number` - Phone number to save
- **Conditions**: Only saves if `isSaveNumberEnabled` is true

#### `getSavedNumbers()`

```dart
List<String> getSavedNumbers()
```

- **Description**: Retrieves list of saved numbers
- **Returns**: List of saved phone numbers

#### `clearHistory()`

```dart
Future<void> clearHistory()
```

- **Description**: Clears all saved numbers
- **Returns**: Future that completes when history is cleared

**Properties**:

```dart
bool get isSaveNumberEnabled // Current saving preference (read-only)
```

### 3. Country Data API

**Purpose**: Provide country information for phone number formatting

**Class**: `Countries`

**Methods**:

#### `getCountryByCode(String code)`

```dart
static Country? getCountryByCode(String code)
```

- **Description**: Finds country by country code
- **Parameters**: `code` - Country code (e.g., "+91")
- **Returns**: Country object or null if not found

**Properties**:

```dart
static List<Country> get list // All available countries (read-only)
```

**Country Model**:

```dart
class Country {
  final String name;    // Country name (e.g., "India")
  final String code;    // Country code (e.g., "+91")
  final String flag;    // Flag emoji (e.g., "🇮🇳")

  const Country({
    required this.name,
    required this.code,
    required this.flag,
  });
}
```

### 4. Theme Data API

**Purpose**: Provide centralized theme configuration

**Class**: `AppThemes`

**Font Size Constants**:

```dart
static const double fontSizeExtraSmall = 10.0;
static const double fontSizeSmall = 12.0;
static const double fontSizeMedium = 14.0;
static const double fontSizeLarge = 16.0;
static const double fontSizeExtraLarge = 18.0;
static const double fontSizeTitle = 20.0;
static const double fontSizeHeading = 24.0;
static const double fontSizeLargeHeading = 28.0;
static const double fontSizeDisplay = 32.0;
```

**Color Methods**:

```dart
static Color getPrimaryTextColor(bool isDark)
static Color getSecondaryTextColor(bool isDark)
static Color getBackgroundColor(bool isDark)
static Color getCardBackgroundColor(bool isDark)
static Color getBorderColor(bool isDark)
static Color getErrorColor(bool isDark)
static Color getSuccessColor(bool isDark)
// ... and more
```

**Theme Data**:

```dart
static ThemeData get lightTheme // Complete light theme
static ThemeData get darkTheme  // Complete dark theme
```

**Utility Methods**:

```dart
static double getBodyFontSize()    // Returns fontSizeMedium
static double getTitleFontSize()   // Returns fontSizeTitle
static double getHeadingFontSize() // Returns fontSizeHeading
// ... and more
```

## 📊 Error Handling

### WhatsApp Launch Errors

```dart
try {
  await openWhatsApp(number, message);
} catch (e) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Error: $e'),
      backgroundColor: AppThemes.getErrorColor(isDark),
    ),
  );
}
```

**Common Errors**:

- WhatsApp not installed
- Invalid URL format
- Network connectivity issues

### Form Validation

```dart
String? validatePhoneNumber(String? value) {
  if (value == null || value.isEmpty) {
    return 'Phone number is required';
  }
  if (value.length < 10 || value.length > 15) {
    return 'Please enter a valid phone number';
  }
  return null;
}
```

## 🔧 Configuration

### URL Launcher Configuration

**Android** (`android/app/src/main/AndroidManifest.xml`):

```xml
<queries>
  <intent>
    <action android:name="android.intent.action.VIEW" />
    <data android:scheme="https" />
  </intent>
</queries>
```

**iOS** (`ios/Runner/Info.plist`):

```xml
<key>LSApplicationQueriesSchemes</key>
<array>
  <string>https</string>
  <string>whatsapp</string>
</array>
```

### SharedPreferences Configuration

No additional configuration required. Works out of the box on all platforms.

## 🚦 Rate Limiting & Best Practices

### WhatsApp URL Scheme

- **Rate Limiting**: No explicit limits, but avoid spam
- **Best Practice**: Validate phone numbers before launching
- **User Experience**: Show loading states when launching

### SharedPreferences

- **Performance**: Use sparingly for frequently accessed data
- **Best Practice**: Load preferences once during app startup
- **Data Size**: Keep stored data minimal

## 🔮 Future API Integrations

### Potential Additions

1. **Contact Validation API**: Verify phone number validity
2. **Analytics API**: Track usage patterns (with user consent)
3. **Cloud Backup**: Sync settings across devices
4. **Push Notifications**: For app updates or features

### Architecture Readiness

The current architecture supports easy addition of new APIs through:

- **Repository Pattern**: Ready for data source abstraction
- **Provider Pattern**: Easy state management for new features
- **Dependency Injection**: Future support for service injection

## 📝 API Usage Examples

### Complete WhatsApp Flow

```dart
class WhatsAppService {
  static Future<void> sendMessage({
    required String countryCode,
    required String number,
    String? message,
  }) async {
    // Combine country code and number
    final fullNumber = '$countryCode$number';

    // Validate number
    if (!_isValidNumber(fullNumber)) {
      throw 'Invalid phone number format';
    }

    // Launch WhatsApp
    final url = Uri.parse(
      'https://wa.me/$fullNumber${message != null ? '?text=${Uri.encodeFull(message)}' : ''}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  static bool _isValidNumber(String number) {
    // Remove any non-digit characters except +
    final cleaned = number.replaceAll(RegExp(r'[^\d+]'), '');
    return cleaned.length >= 10 && cleaned.length <= 15;
  }
}
```

### Theme Integration Example

```dart
class ThemedWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      color: AppThemes.getBackgroundColor(isDark),
      child: Text(
        'Themed Text',
        style: TextStyle(
          fontSize: AppThemes.fontSizeLarge,
          color: AppThemes.getPrimaryTextColor(isDark),
        ),
      ),
    );
  }
}
```

This API documentation provides a comprehensive overview of all the APIs and integrations used in WhatsApp Direct Pro, making it easy for developers to understand and extend the application.
