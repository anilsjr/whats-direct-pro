import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/term_conditions_provider.dart';
import '../screens/home/home_screen.dart';

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
    return Center(
      child: Container(
        padding: const EdgeInsets.all(32),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Title
            const Text(
              'Terms & Conditions',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFFE91E63),
              ),
            ),

            // Content
            const Text(
              '\nThis app is made for personal use only. \nBy pressing Continue you have accepted our terms & privacy policy.',
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),

            // Buttons
            Column(
              children: [
                // Continue Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () async {
                      // Set isFirstVisit to false using the provider
                      final provider = Provider.of<TermsConditionsProvider>(
                        context,
                        listen: false,
                      );
                      await provider.toggleFirstVisit();

                      // Call the callback or default action
                      if (onContinue != null) {
                        onContinue!();
                      } else {
                        _onContinue(context);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      shadowColor: Colors.transparent,
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE91E63),
                        letterSpacing: 0.5,
                        decoration: TextDecoration.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 8),

                // Terms & Privacy Policy Button
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed:
                        onTermsPressed ??
                        () => _showTermsAndPrivacyPolicy(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                    ),
                    child: const Text(
                      'TERMS & PRIVACY POLICY',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFE91E63),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ),
              ],
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
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Terms & Privacy Policy'),
          content: const SingleChildScrollView(
            child: Text(
              'Terms of Use:\n\n'
              '1. This application is for personal use only.\n'
              '2. This app is not affiliated with WhatsApp Inc.\n'
              '3. Users are responsible for their own actions.\n'
              '4. The app should not be used for spam or illegal activities.\n\n'
              'Privacy Policy:\n\n'
              '1. We do not collect personal data.\n'
              '2. Phone numbers are processed locally.\n'
              '3. No data is shared with third parties.\n'
              '4. Users are responsible for their privacy settings.',
              style: TextStyle(fontSize: 14),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}
