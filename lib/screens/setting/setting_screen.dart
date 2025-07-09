import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';
import '../../theme/custom_theme.dart';

class SettingScreen extends StatefulWidget {
  const SettingScreen({super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Dark Theme Setting
            Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.lightShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                title: Text(
                  'Dark Theme',
                  style: TextStyle(
                    fontSize: AppThemes.fontSizeLarge,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: CupertinoSwitch(
                  value: themeProvider.isDarkMode,
                  onChanged: (value) {
                    themeProvider.toggleTheme();
                  },
                ),
                // onTap: () {
                //   themeProvider.toggleTheme();
                // },
              ),
            ),

            // Save Number in History Setting
            Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.lightShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                title: Text(
                  'Follw ME',
                  style: TextStyle(
                    fontSize: AppThemes.fontSizeLarge,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppThemes.getSubtleTextColor(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
                onTap: () async {
                  final linkedinAppUrl = Uri.parse('linkedin://in/anilvk');
                  final linkedinWebUrl = Uri.parse(
                    'https://www.linkedin.com/in/anilvk',
                  );
                  if (await canLaunchUrl(linkedinAppUrl)) {
                    final launched = await launchUrl(linkedinAppUrl);
                    if (!launched) {
                      // Fallback to website if app did not open
                      if (await canLaunchUrl(linkedinWebUrl)) {
                        await launchUrl(linkedinWebUrl);
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Could not open LinkedIn website.'),
                          ),
                        );
                      }
                    }
                  } else if (await canLaunchUrl(linkedinWebUrl)) {
                    await launchUrl(linkedinWebUrl);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Could not open LinkedIn website.'),
                      ),
                    );
                  }
                },
              ),
              // Add this import at the top of the file
            ),

            // Language Setting
            Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.lightShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                title: Text(
                  'Language',
                  style: TextStyle(
                    fontSize: AppThemes.fontSizeLarge,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'English',
                      style: TextStyle(
                        fontSize: AppThemes.fontSizeLarge,
                        color: AppThemes.getSubtleTextColor(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8.0),
                    Icon(
                      Icons.chevron_right,
                      color: AppThemes.getSubtleTextColor(
                        Theme.of(context).brightness == Brightness.dark,
                      ),
                    ),
                  ],
                ),
                // onTap: () {
                //   // Add language selection logic here
                // },
              ),
            ),

            // Version Info
            Container(
              margin: const EdgeInsets.only(bottom: 12.0),
              decoration: BoxDecoration(
                color: Theme.of(context).cardColor,
                borderRadius: BorderRadius.circular(12.0),
                boxShadow: [
                  BoxShadow(
                    color: AppThemes.lightShadow,
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 20.0,
                  vertical: 8.0,
                ),
                title: Text(
                  'Version',
                  style: TextStyle(
                    fontSize: AppThemes.fontSizeLarge,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                trailing: Text(
                  '1.0.0',
                  style: TextStyle(
                    fontSize: AppThemes.fontSizeLarge,
                    color: AppThemes.getSubtleTextColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
