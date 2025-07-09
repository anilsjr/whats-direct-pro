import 'package:flutter/material.dart';
import 'package:whats_direct_pro/theme/custom_theme.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset('assets/icons/logo.png', width: 120, height: 120),
              SizedBox(height: 50),
              Text(
                'WhatsApp Direct Pro',
                style: TextStyle(
                  fontSize: AppThemes.fontSizeHeading,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Version 1.0.0',
                style: TextStyle(fontSize: AppThemes.fontSizeLarge),
              ),
              const SizedBox(height: 20),
              Text(
                'Send WhatsApp messages without saving contacts. Simple, fast, and private.',
                style: TextStyle(fontSize: AppThemes.fontSizeMedium),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
