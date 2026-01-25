import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/term_conditions_provider.dart';
import '../screens/home/home_screen.dart';
import '../theme/custom_theme.dart';

class TermsAndConditionsWidget extends StatelessWidget {
  final VoidCallback? onContinue;
  final VoidCallback? onTermsPressed;

  const TermsAndConditionsWidget({
    Key? key,
    this.onContinue,
    this.onTermsPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Terms & Conditions',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: primaryColor,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 24),
            // Header with Icon
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(
                    Icons.verified_user_outlined,
                    color: primaryColor,
                    size: 28,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Text(
                    'Terms & Conditions',
                    style: TextStyle(
                      fontSize: AppThemes.fontSizeLargeHeading,
                      fontWeight: FontWeight.bold,
                      color: isDark 
                          ? AppThemes.darkPrimaryText 
                          : AppThemes.lightPrimaryText,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Content Text
            RichText(
              text: TextSpan(
                style: TextStyle(
                  fontSize: AppThemes.fontSizeLarge,
                  color: isDark 
                      ? AppThemes.darkSecondaryText 
                      : AppThemes.lightSecondaryText,
                  height: 1.7,
                  letterSpacing: 0.2,
                ),
                children: [
                  const TextSpan(text: 'This app is made for '),
                  TextSpan(
                    text: 'personal use',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ' only.\n\nBy pressing '),
                  TextSpan(
                    text: 'Continue',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: ', you acknowledge that you have read and accepted our '),
                  TextSpan(
                    text: 'terms & privacy policy',
                    style: TextStyle(
                      color: primaryColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const TextSpan(text: '.'),
                ],
              ),
            ),
            const SizedBox(height: 32),
            // Divider
            Divider(
              color: AppThemes.getBorderColor(isDark),
              thickness: 1,
              height: 1,
            ),
            const SizedBox(height: 24),
            // Primary Button - CONTINUE
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  final provider = Provider.of<TermsConditionsProvider>(
                    context,
                    listen: false,
                  );
                  try {
                    await provider.acceptTermsAndConditions();

                    if (onContinue != null) {
                      onContinue!();
                    } else {
                      _onContinue(context);
                    }
                  } catch (e) {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Error: ${e.toString()}'),
                          backgroundColor: AppThemes.getErrorColor(isDark),
                        ),
                      );
                    }
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: primaryColor,
                  foregroundColor: isDark 
                      ? AppThemes.darkButtonText 
                      : AppThemes.lightButtonText,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Continue',
                      style: TextStyle(
                        fontSize: AppThemes.fontSizeLarge,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.5,
                        color: isDark 
                            ? AppThemes.darkButtonText 
                            : AppThemes.lightButtonText,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Icon(
                      Icons.arrow_forward, 
                      size: 20,
                      color: isDark 
                          ? AppThemes.darkButtonText 
                          : AppThemes.lightButtonText,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Secondary Button - Terms & Privacy Policy
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed:
                    onTermsPressed ??
                    () => _showTermsAndPrivacyPolicy(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: primaryColor,
                  side: BorderSide(
                    color: primaryColor.withOpacity(0.5),
                    width: 1.5,
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.description_outlined, 
                      size: 18,
                      color: primaryColor,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Terms & Privacy Policy',
                      style: TextStyle(
                        fontSize: AppThemes.fontSizeMedium,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 0.3,
                        color: primaryColor,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static void _onContinue(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (_) => const HomeScreen()));
  }

  static void _showTermsAndPrivacyPolicy(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final primaryColor = Theme.of(context).primaryColor;
    
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.5),
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Container(
            constraints: const BoxConstraints(maxWidth: 500, maxHeight: 600),
            decoration: BoxDecoration(
              color: isDark 
                  ? AppThemes.darkCardBackground 
                  : AppThemes.lightCardBackground,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Header Section
                Container(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
                  decoration: BoxDecoration(
                    color: primaryColor.withOpacity(0.1),
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: primaryColor,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.description_outlined,
                          color: isDark 
                              ? AppThemes.darkButtonText 
                              : AppThemes.lightButtonText,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Text(
                          'Terms & Privacy Policy',
                          style: TextStyle(
                            fontSize: AppThemes.fontSizeHeading,
                            fontWeight: FontWeight.bold,
                            color: isDark 
                                ? AppThemes.darkPrimaryText 
                                : AppThemes.lightPrimaryText,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          Icons.close,
                          color: AppThemes.getSubtleTextColor(isDark),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
                // Content Section
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Terms of Use Section
                        _buildSectionHeader(
                          context,
                          'Terms of Use',
                          Icons.gavel_outlined,
                          isDark,
                        ),
                        const SizedBox(height: 12),
                        _buildListItem(
                          context,
                          'This application is for personal use only.',
                          isDark,
                        ),
                        _buildListItem(
                          context,
                          'This app is not affiliated with WhatsApp Inc.',
                          isDark,
                        ),
                        _buildListItem(
                          context,
                          'Users are responsible for their own actions.',
                          isDark,
                        ),
                        _buildListItem(
                          context,
                          'The app should not be used for spam or illegal activities.',
                          isDark,
                        ),
                        const SizedBox(height: 24),
                        // Divider
                        Divider(
                          color: AppThemes.getBorderColor(isDark),
                          thickness: 1,
                          height: 1,
                        ),
                        const SizedBox(height: 24),
                        // Privacy Policy Section
                        _buildSectionHeader(
                          context,
                          'Privacy Policy',
                          Icons.privacy_tip_outlined,
                          isDark,
                        ),
                        const SizedBox(height: 12),
                        _buildListItem(
                          context,
                          'We do not collect personal data.',
                          isDark,
                        ),
                        _buildListItem(
                          context,
                          'Phone numbers are processed locally.',
                          isDark,
                        ),
                        _buildListItem(
                          context,
                          'No data is shared with third parties.',
                          isDark,
                        ),
                        _buildListItem(
                          context,
                          'Users are responsible for their privacy settings.',
                          isDark,
                        ),
                      ],
                    ),
                  ),
                ),
                // Footer Section with Button
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: AppThemes.getHighlightColor(isDark),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                    ),
                  ),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primaryColor,
                        foregroundColor: isDark 
                            ? AppThemes.darkButtonText 
                            : AppThemes.lightButtonText,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 0,
                      ),
                      child: Text(
                        'Close',
                        style: TextStyle(
                          fontSize: AppThemes.fontSizeLarge,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.5,
                          color: isDark 
                              ? AppThemes.darkButtonText 
                              : AppThemes.lightButtonText,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Widget _buildSectionHeader(
    BuildContext context,
    String title,
    IconData icon,
    bool isDark,
  ) {
    final primaryColor = Theme.of(context).primaryColor;
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Text(
          title,
          style: TextStyle(
            fontSize: AppThemes.fontSizeExtraLarge,
            fontWeight: FontWeight.bold,
            color: isDark 
                ? AppThemes.darkPrimaryText 
                : AppThemes.lightPrimaryText,
            letterSpacing: 0.3,
          ),
        ),
      ],
    );
  }

  static Widget _buildListItem(BuildContext context, String text, bool isDark) {
    final primaryColor = Theme.of(context).primaryColor;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6, right: 12),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: primaryColor,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Text(
              text,
              style: TextStyle(
                fontSize: AppThemes.fontSizeMedium,
                height: 1.6,
                color: isDark 
                    ? AppThemes.darkSecondaryText 
                    : AppThemes.lightSecondaryText,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

}
