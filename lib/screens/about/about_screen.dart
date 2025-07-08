import "package:flutter/material.dart";
import '../../theme/custom_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'WhatsApp Direct Pro',
              style: TextStyle(
                fontSize: AppThemes.fontSizeHeading,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Version 1.0.0',
              style: TextStyle(fontSize: AppThemes.fontSizeExtraLarge),
            ),
            const SizedBox(height: 16),
            Text(
              'This app allows you to send messages directly to WhatsApp contacts without saving their numbers.',
              style: TextStyle(fontSize: AppThemes.fontSizeLarge),
            ),
          ],
        ),
      ),
    );
  }
}
