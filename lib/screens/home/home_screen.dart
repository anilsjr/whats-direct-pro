import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:whats_direct_pro/screens/about/about_screen.dart';
import 'package:whats_direct_pro/screens/setting/setting_screen.dart'
    show SettingScreen;
import 'package:whats_direct_pro/widgets/country_code_picker.dart';
import 'package:whats_direct_pro/models/country.dart';
import '../../theme/custom_theme.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;
  bool _showCountryPicker = true;
  String _selectedCountryCode = '+91';
  bool _hasOverlayPermission = false;

  //controllers
  final _numberController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> openWhatsApp(String phone, String message) async {
    phone = "$_selectedCountryCode$phone"; // Use selected country code
    final url = Uri.parse(
      'https://wa.me/$phone?text=${Uri.encodeFull(message)}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch WhatsApp';
    }
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      final String number = _numberController.text.trim();
      final String message = _messageController.text.trim();

      try {
        await openWhatsApp(number, message);
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppThemes.getErrorColor(
              Theme.of(context).brightness == Brightness.dark,
            ),
          ),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    _numberController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WhatsApp Direct Pro',
          style: TextStyle(
            // fontSize: AppThemes.fontSizeHeading,
            fontWeight: FontWeight.bold,
          ),
        ),
        // centerTitle: true,
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'about',
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Text('About'),
                ),
              ),
              PopupMenuItem(
                value: 'settings',
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 8.0,
                    horizontal: 16.0,
                  ),
                  child: Text('Settings'),
                ),
              ),
            ],
            onSelected: (value) {
              switch (value) {
                case 'about':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const AboutScreen(),
                    ),
                  );
                  break;
                case 'settings':
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => const SettingScreen(),
                    ),
                  );
              }
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 50),

              // Phone Number Section
              Text(
                'Phone Number',
                style: TextStyle(
                  fontSize: AppThemes.fontSizeLarge,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Phone Number Input with Country Code
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppThemes.getBorderColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // Country Code Section
                    CountryCodePicker(
                      selectedCountryCode: _selectedCountryCode,
                      onCountrySelected: (Country country) {
                        setState(() {
                          _selectedCountryCode = country.code;
                        });
                      },
                      enabled: _showCountryPicker,
                    ),

                    // Divider
                    Container(
                      height: 50,
                      width: 1,
                      color: AppThemes.getBorderColor(
                        Theme.of(context).brightness == Brightness.dark,
                      ),
                    ),

                    // Phone Number Input
                    Expanded(
                      child: TextFormField(
                        controller: _numberController,
                        keyboardType: TextInputType.phone,
                        autovalidateMode: AutovalidateMode.onUserInteraction,
                        decoration: InputDecoration(
                          hintText: 'Enter Phone Number',
                          hintStyle: TextStyle(
                            color: AppThemes.getSubtleTextColor(
                              Theme.of(context).brightness == Brightness.dark,
                            ),
                          ),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 12,
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Phone number is required';
                          }
                          // Remove any non-digit characters
                          final cleanNumber = value.replaceAll(
                            RegExp(r'[^0-9]'),
                            '',
                          );

                          // Check if it contains only digits after cleaning
                          if (!RegExp(r'^[0-9]+$').hasMatch(cleanNumber)) {
                            return 'Phone number can only contain digits';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Show Country Picker Checkbox
              Row(
                children: [
                  Checkbox(
                    value: _showCountryPicker,
                    onChanged: (value) {
                      setState(() {
                        _showCountryPicker = value ?? false;
                      });
                    },
                    activeColor: Theme.of(context).primaryColor,
                  ),
                  Text(
                    'show country picker',
                    style: TextStyle(
                      color: Theme.of(context).primaryColor,

                      fontSize: AppThemes.fontSizeMedium,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Message Section
              Text(
                'Message',
                style: TextStyle(
                  fontSize: AppThemes.fontSizeLarge,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),

              // Message Input
              Container(
                height: 120,
                decoration: BoxDecoration(
                  border: Border.all(
                    color: AppThemes.getBorderColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: TextFormField(
                  controller: _messageController,
                  maxLines: null,
                  expands: true,
                  textAlignVertical: TextAlignVertical.top,
                  decoration: InputDecoration(
                    hintText: 'Enter Your Message (Optional)....',
                    hintStyle: TextStyle(
                      color: AppThemes.getSubtleTextColor(
                        Theme.of(context).brightness == Brightness.dark,
                      ),
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(16),
                  ),
                  validator: (value) {
                    if (value != null && value.length > 10000000000000) {
                      return 'Message is Too Long required';
                    }
                    return null;
                  },
                ),
              ),

              const SizedBox(height: 40),

              // WhatsApp Button
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitForm,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: AppThemes.lightButtonText,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                    child: _isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                AppThemes.lightButtonText,
                              ),
                            ),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SvgPicture.asset(
                                'assets/icons/whatsapp_logo.svg',
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'Send',
                                style: TextStyle(
                                  fontSize: AppThemes.fontSizeLarge,
                                  fontWeight: FontWeight.w600,
                                  color: AppThemes.lightButtonText,
                                ),
                              ),
                            ],
                          ),
                  ),
                ),
              ),

              const Spacer(),
            ],
          ),
        ),
      ),
    );
  }
}
