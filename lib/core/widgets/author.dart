import 'package:flutter/gestures.dart' show TapGestureRecognizer;
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_direct_pro/core/config/app_theme.dart' show AppThemes;

Widget buildBy(BuildContext context) {
  final isDark = Theme.of(context).brightness == Brightness.dark;

  return Center(
    child: RichText(
      text: TextSpan(
        style: TextStyle(
          color: isDark
              ? AppThemes.darkPrimaryText
              : AppThemes.lightPrimaryText,
          fontSize: AppThemes.fontSizeMedium,
        ),
        children: [
          const TextSpan(text: 'Developed by '),
          TextSpan(
            text: 'Anil Vishwakarma',
            style: TextStyle(
              color: isDark
                  ? AppThemes.darkAccentGreen
                  : AppThemes.lightAccentGreen,
              fontWeight: FontWeight.bold,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                // Handle tap on developer name
                launchUrl(Uri.parse('https://anilsjr.github.io/portfolio'));
              },
          ),
        ],
      ),
    ),
  );
}
