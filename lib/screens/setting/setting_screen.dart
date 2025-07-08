import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import '../../provider/theme_provider.dart';
import '../../provider/save_number_provider.dart';
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
    final saveNumberProvider = Provider.of<SaveNumberProvider>(context);

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
                title: const Text(
                  'Dark Theme',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
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
                title: const Text(
                  'Save Number in History',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                trailing: CupertinoSwitch(
                  value: saveNumberProvider.isSaveNumberEnabled,
                  onChanged: (value) {
                    saveNumberProvider.toggleSaveNumber();
                  },
                ),
                // onTap: () {
                //   saveNumberProvider.toggleSaveNumber();
                // },
              ),
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
                title: const Text(
                  'Language',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'English',
                      style: TextStyle(
                        fontSize: 16.0,
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
                title: const Text(
                  'Version',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                trailing: Text(
                  '1.0.0',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppThemes.getSubtleTextColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                ),
              ),
            ),

            // Share The App
            Container(
              margin: const EdgeInsets.only(bottom: 20.0),
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
                title: const Text(
                  'Share The App',
                  style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w500),
                ),
                trailing: Icon(
                  Icons.chevron_right,
                  color: AppThemes.getSubtleTextColor(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                ),
                onTap: () {
                  // Add share app logic here
                },
              ),
            ),

            const Spacer(),

            // Remove History Button
            Container(
              width: double.infinity,
              margin: const EdgeInsets.only(bottom: 20.0),
              child: TextButton(
                onPressed: () {
                  // Add remove history logic here
                },
                child: Text(
                  'Remove History',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: AppThemes.getErrorColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                    fontWeight: FontWeight.w500,
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
