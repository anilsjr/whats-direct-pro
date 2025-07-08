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
              'WhatsApp Direct Pro is a powerful utility app designed to simplify your WhatsApp messaging experience. Say goodbye to cluttering your contact list with temporary numbers and hello to seamless direct messaging.',
              style: TextStyle(fontSize: AppThemes.fontSizeLarge),
            ),
            const SizedBox(height: 16),

            // App Description Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[800]
                    : Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'About This App',
                    style: TextStyle(
                      fontSize: AppThemes.fontSizeExtraLarge,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Whether you\'re reaching out to businesses, making one-time inquiries, or need to contact someone internationally, WhatsApp Direct Pro eliminates the friction of saving and managing temporary contacts. Built with privacy in mind, this app stores no personal data and provides a clean, modern interface that respects your preferences.',
                    style: TextStyle(
                      fontSize: AppThemes.fontSizeMedium,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Features',
              style: TextStyle(
                fontSize: AppThemes.fontSizeTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            _buildFeatureItem(
              context,
              '📱 Direct WhatsApp Messaging',
              'Send messages to any phone number instantly without saving contacts to your phone.',
            ),
            _buildFeatureItem(
              context,
              '🌍 Global Country Support',
              'Select from 200+ countries with their respective country codes and flags.',
            ),
            _buildFeatureItem(
              context,
              '🎨 Theme Customization',
              'Switch between light and dark themes based on your preference.',
            ),
            _buildFeatureItem(
              context,
              '📝 Optional Message Text',
              'Add custom messages or send direct calls to WhatsApp.',
            ),
            _buildFeatureItem(
              context,
              '🔒 Privacy Focused',
              'No data collection, no ads, and optional number history saving.',
            ),
            _buildFeatureItem(
              context,
              '⚡ Fast & Lightweight',
              'Quick app startup and smooth performance across all devices.',
            ),
            const SizedBox(height: 24),
            Text(
              'How it Works',
              style: TextStyle(
                fontSize: AppThemes.fontSizeTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[600]!
                      : Colors.grey[300]!,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            '1',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Select Country & Enter Number',
                          style: TextStyle(
                            fontSize: AppThemes.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: Text(
                      'Choose your country from the dropdown and enter the phone number (with or without country code)',
                      style: TextStyle(
                        fontSize: AppThemes.fontSizeSmall,
                        color: AppThemes.getSubtleTextColor(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            '2',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Add Your Message (Optional)',
                          style: TextStyle(
                            fontSize: AppThemes.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: Text(
                      'Type your message in the text field, or leave it empty to start with a blank chat',
                      style: TextStyle(
                        fontSize: AppThemes.fontSizeSmall,
                        color: AppThemes.getSubtleTextColor(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 24,
                        height: 24,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Center(
                          child: Text(
                            '3',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Tap the WhatsApp Button',
                          style: TextStyle(
                            fontSize: AppThemes.fontSizeMedium,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 36),
                    child: Text(
                      'Hit the green WhatsApp icon to open the chat directly in WhatsApp and start messaging!',
                      style: TextStyle(
                        fontSize: AppThemes.fontSizeSmall,
                        color: AppThemes.getSubtleTextColor(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Why Choose WhatsApp Direct Pro?',
              style: TextStyle(
                fontSize: AppThemes.fontSizeTitle,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.green[900]!.withOpacity(0.3)
                        : Colors.green[50]!,
                    Theme.of(context).brightness == Brightness.dark
                        ? Colors.blue[900]!.withOpacity(0.3)
                        : Colors.blue[50]!,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Perfect for Business & Personal Use',
                        style: TextStyle(
                          fontSize: AppThemes.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• Customer service inquiries without contact clutter\n'
                    '• One-time business communications\n'
                    '• International messaging made simple\n'
                    '• Quick contact for services and support\n'
                    '• Clean interface that respects your time',
                    style: TextStyle(
                      fontSize: AppThemes.fontSizeSmall,
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.security, color: Colors.green, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Privacy & Security First',
                        style: TextStyle(
                          fontSize: AppThemes.fontSizeMedium,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '• No personal data collection or storage\n'
                    '• No ads or tracking\n'
                    '• Optional number history (stored locally)\n'
                    '• Open-source approach to transparency',
                    style: TextStyle(
                      fontSize: AppThemes.fontSizeSmall,
                      height: 1.6,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // App Info Section
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).brightness == Brightness.dark
                    ? Colors.grey[850]
                    : Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Theme.of(context).brightness == Brightness.dark
                      ? Colors.grey[700]!
                      : Colors.grey[200]!,
                ),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            'Version',
                            style: TextStyle(
                              fontSize: AppThemes.fontSizeSmall,
                              color: AppThemes.getSubtleTextColor(
                                Theme.of(context).brightness == Brightness.dark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '1.0.0',
                            style: TextStyle(
                              fontSize: AppThemes.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[600]
                            : Colors.grey[300],
                      ),
                      Column(
                        children: [
                          Text(
                            'Platform',
                            style: TextStyle(
                              fontSize: AppThemes.fontSizeSmall,
                              color: AppThemes.getSubtleTextColor(
                                Theme.of(context).brightness == Brightness.dark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Flutter',
                            style: TextStyle(
                              fontSize: AppThemes.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: 1,
                        height: 40,
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.grey[600]
                            : Colors.grey[300],
                      ),
                      Column(
                        children: [
                          Text(
                            'License',
                            style: TextStyle(
                              fontSize: AppThemes.fontSizeSmall,
                              color: AppThemes.getSubtleTextColor(
                                Theme.of(context).brightness == Brightness.dark,
                              ),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'MIT',
                            style: TextStyle(
                              fontSize: AppThemes.fontSizeMedium,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Spacer(),

            // Enhanced Footer
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.green.withOpacity(0.1),
                    Colors.blue.withOpacity(0.1),
                  ],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Icon(Icons.favorite, color: Colors.red, size: 24),
                  const SizedBox(height: 8),
                  Text(
                    'Made with ❤️ for WhatsApp users worldwide',
                    style: TextStyle(
                      fontSize: AppThemes.fontSizeMedium,
                      fontWeight: FontWeight.w500,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Connecting people, one message at a time',
                    style: TextStyle(
                      fontSize: AppThemes.fontSizeSmall,
                      fontStyle: FontStyle.italic,
                      color: AppThemes.getSubtleTextColor(
                        Theme.of(context).brightness == Brightness.dark,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(
    BuildContext context,
    String title,
    String description,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: AppThemes.fontSizeMedium,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: AppThemes.fontSizeSmall,
                    color: AppThemes.getSubtleTextColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                    height: 1.4,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
