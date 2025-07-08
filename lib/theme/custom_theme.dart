import 'package:flutter/material.dart';

class AppThemes {
  // Font Sizes
  static const double fontSizeExtraSmall = 10.0;
  static const double fontSizeSmall = 12.0;
  static const double fontSizeMedium = 14.0;
  static const double fontSizeLarge = 16.0;
  static const double fontSizeExtraLarge = 18.0;
  static const double fontSizeTitle = 20.0;
  static const double fontSizeHeading = 24.0;
  static const double fontSizeLargeHeading = 28.0;
  static const double fontSizeDisplay = 32.0;

  // Light Theme Colors
  static const Color lightPrimaryText = Color(0xFF808080);
  static const Color lightSecondaryText = Color(0xFFE0E0E0);
  static const Color lightAccentGreen = Color(0xFF71E57E);
  static const Color lightBackground = Colors.white;

  // Additional Light Theme Colors
  static const Color lightCardBackground = Color(0xFFF5F5F5);
  static const Color lightDivider = Color(0xFFE0E0E0);
  static const Color lightError = Color(0xFFE53E3E);
  static const Color lightSuccess = Color(0xFF38A169);
  static const Color lightWarning = Color(0xFFD69E2E);
  static const Color lightInfo = Color(0xFF3182CE);
  static const Color lightSubtleText = Color(0xFF9CA3AF);
  static const Color lightBorder = Color(0xFFD1D5DB);
  static const Color lightShadow = Color(0x1A000000);
  static const Color lightIconColor = Color(0xFF6B7280);
  static const Color lightButtonText = Colors.white;
  static const Color lightDisabled = Color(0xFFE5E7EB);
  static const Color lightHighlight = Color(0xFFF3F4F6);

  // Dark Theme Colors
  static const Color darkPrimaryText = Color(0xFFFFFFFF);
  static const Color darkSecondaryText = Color(0xFFE0E0E0);
  static const Color darkAccentGreen = Color(0xFF71E57E);
  static const Color darkBackground = Color(0xFF1E1E1E);

  // Additional Dark Theme Colors
  static const Color darkCardBackground = Color(0xFF2D2D2D);
  static const Color darkDivider = Color(0xFF3F3F3F);
  static const Color darkError = Color(0xFFFC8181);
  static const Color darkSuccess = Color(0xFF68D391);
  static const Color darkWarning = Color(0xFFF6E05E);
  static const Color darkInfo = Color(0xFF63B3ED);
  static const Color darkSubtleText = Color(0xFFD1D5DB);
  static const Color darkBorder = Color(0xFF4A5568);
  static const Color darkShadow = Color(0x33000000);
  static const Color darkIconColor = Color(0xFFE5E7EB);
  static const Color darkButtonText = Color(0xFF1A202C);
  static const Color darkDisabled = Color(0xFF4A5568);
  static const Color darkHighlight = Color(0xFF2D3748);

  static final ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    primaryColor: lightAccentGreen,
    scaffoldBackgroundColor: lightBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: lightBackground,
      foregroundColor: lightPrimaryText,
      elevation: 0,
      shadowColor: lightShadow,
    ),
    cardTheme: const CardThemeData(
      color: lightCardBackground,
      elevation: 2,
      shadowColor: lightShadow,
    ),
    dividerTheme: const DividerThemeData(color: lightDivider, thickness: 1),
    iconTheme: const IconThemeData(color: lightIconColor),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeDisplay,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeLargeHeading,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeHeading,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeHeading,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeExtraLarge,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeExtraLarge,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: TextStyle(
        color: lightSecondaryText,
        fontSize: fontSizeLarge,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(color: lightPrimaryText, fontSize: fontSizeLarge),
      bodyMedium: TextStyle(color: lightPrimaryText, fontSize: fontSizeMedium),
      bodySmall: TextStyle(color: lightSecondaryText, fontSize: fontSizeSmall),
      labelLarge: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: lightPrimaryText,
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: lightSecondaryText,
        fontSize: fontSizeExtraSmall,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: lightAccentGreen,
        foregroundColor: lightButtonText,
        shadowColor: lightShadow,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: lightAccentGreen),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderSide: BorderSide(color: lightBorder)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightAccentGreen),
      ),
      errorBorder: OutlineInputBorder(
        borderSide: BorderSide(color: lightError),
      ),
    ),
    colorScheme: ColorScheme.light(
      primary: lightAccentGreen,
      secondary: lightSecondaryText,
      surface: lightBackground,
      onSurface: lightPrimaryText,
      error: lightError,
      onError: lightButtonText,
      outline: lightBorder,
      shadow: lightShadow,
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    primaryColor: darkAccentGreen,
    scaffoldBackgroundColor: darkBackground,
    appBarTheme: const AppBarTheme(
      backgroundColor: darkBackground,
      foregroundColor: darkPrimaryText,
      elevation: 0,
      shadowColor: darkShadow,
    ),
    cardTheme: const CardThemeData(
      color: darkCardBackground,
      elevation: 2,
      shadowColor: darkShadow,
    ),
    dividerTheme: const DividerThemeData(color: darkDivider, thickness: 1),
    iconTheme: const IconThemeData(color: darkIconColor),
    textTheme: const TextTheme(
      displayLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeDisplay,
        fontWeight: FontWeight.bold,
      ),
      displayMedium: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeLargeHeading,
        fontWeight: FontWeight.bold,
      ),
      displaySmall: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeHeading,
        fontWeight: FontWeight.w600,
      ),
      headlineLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeHeading,
        fontWeight: FontWeight.w600,
      ),
      headlineMedium: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w500,
      ),
      headlineSmall: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeExtraLarge,
        fontWeight: FontWeight.w500,
      ),
      titleLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeTitle,
        fontWeight: FontWeight.w500,
      ),
      titleMedium: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeExtraLarge,
        fontWeight: FontWeight.w400,
      ),
      titleSmall: TextStyle(
        color: darkSecondaryText,
        fontSize: fontSizeLarge,
        fontWeight: FontWeight.w400,
      ),
      bodyLarge: TextStyle(color: darkPrimaryText, fontSize: fontSizeLarge),
      bodyMedium: TextStyle(color: darkPrimaryText, fontSize: fontSizeMedium),
      bodySmall: TextStyle(color: darkSecondaryText, fontSize: fontSizeSmall),
      labelLarge: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeMedium,
        fontWeight: FontWeight.w500,
      ),
      labelMedium: TextStyle(
        color: darkPrimaryText,
        fontSize: fontSizeSmall,
        fontWeight: FontWeight.w500,
      ),
      labelSmall: TextStyle(
        color: darkSecondaryText,
        fontSize: fontSizeExtraSmall,
        fontWeight: FontWeight.w500,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: darkAccentGreen,
        foregroundColor: darkButtonText,
        shadowColor: darkShadow,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(foregroundColor: darkAccentGreen),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      border: OutlineInputBorder(borderSide: BorderSide(color: darkBorder)),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(color: darkAccentGreen),
      ),
      errorBorder: OutlineInputBorder(borderSide: BorderSide(color: darkError)),
    ),
    colorScheme: ColorScheme.dark(
      primary: darkAccentGreen,
      secondary: darkSecondaryText,
      surface: darkBackground,
      onSurface: darkPrimaryText,
      error: darkError,
      onError: darkButtonText,
      outline: darkBorder,
      shadow: darkShadow,
    ),
  );

  // Utility methods to access theme colors
  static Color getErrorColor(bool isDark) => isDark ? darkError : lightError;
  static Color getSuccessColor(bool isDark) =>
      isDark ? darkSuccess : lightSuccess;
  static Color getWarningColor(bool isDark) =>
      isDark ? darkWarning : lightWarning;
  static Color getInfoColor(bool isDark) => isDark ? darkInfo : lightInfo;
  static Color getSubtleTextColor(bool isDark) =>
      isDark ? darkSubtleText : lightSubtleText;
  static Color getBorderColor(bool isDark) => isDark ? darkBorder : lightBorder;
  static Color getCardBackgroundColor(bool isDark) =>
      isDark ? darkCardBackground : lightCardBackground;
  static Color getHighlightColor(bool isDark) =>
      isDark ? darkHighlight : lightHighlight;
  static Color getDisabledColor(bool isDark) =>
      isDark ? darkDisabled : lightDisabled;

  // Utility methods to access font sizes
  static double getBodyFontSize() => fontSizeMedium;
  static double getTitleFontSize() => fontSizeTitle;
  static double getHeadingFontSize() => fontSizeHeading;
  static double getSmallFontSize() => fontSizeSmall;
  static double getLargeFontSize() => fontSizeLarge;
  static double getDisplayFontSize() => fontSizeDisplay;
}
