import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:whats_direct_pro/src/services/phone_storage_service.dart';
import '../../../core/config/app_theme.dart';

class RecentsScreen extends StatefulWidget {
  const RecentsScreen({super.key});

  @override
  State<RecentsScreen> createState() => _RecentsScreenState();
}

class _RecentsScreenState extends State<RecentsScreen> {
  List<PhoneNumber> _recentNumbers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadRecentNumbers();
  }

  Future<void> _loadRecentNumbers() async {
    setState(() {
      _isLoading = true;
    });

    final numbers = await PhoneStorageService.getRecentPhoneNumbers();
    setState(() {
      _recentNumbers = numbers;
      _isLoading = false;
    });
  }

  Future<void> _openWhatsApp(PhoneNumber phoneNumber, {String message = ''}) async {
    final phone = phoneNumber.fullNumber;
    final url = Uri.parse(
      'https://wa.me/$phone${message.isNotEmpty ? '?text=${Uri.encodeFull(message)}' : ''}',
    );

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Could not launch WhatsApp'),
            backgroundColor: AppThemes.getErrorColor(
              Theme.of(context).brightness == Brightness.dark,
            ),
          ),
        );
      }
    }
  }

  Future<void> _deletePhoneNumber(PhoneNumber phoneNumber) async {
    await PhoneStorageService.deletePhoneNumber(phoneNumber);
    _loadRecentNumbers();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Phone number deleted'),
          backgroundColor: AppThemes.getSuccessColor(
            Theme.of(context).brightness == Brightness.dark,
          ),
        ),
      );
    }
  }

  Future<void> _clearAll() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Recents'),
        content: const Text(
          'Are you sure you want to delete all recent phone numbers?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: TextButton.styleFrom(
              foregroundColor: AppThemes.getErrorColor(
                Theme.of(context).brightness == Brightness.dark,
              ),
            ),
            child: const Text('Delete All'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await PhoneStorageService.clearAllRecentNumbers();
      _loadRecentNumbers();
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('All recent numbers cleared'),
            backgroundColor: AppThemes.getSuccessColor(
              Theme.of(context).brightness == Brightness.dark,
            ),
          ),
        );
      }
    }
  }

  String _formatDate(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays == 0) {
      if (difference.inHours == 0) {
        if (difference.inMinutes == 0) {
          return 'Just now';
        }
        return '${difference.inMinutes} min ago';
      }
      return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday';
    } else if (difference.inDays < 7) {
      return '${difference.inDays} days ago';
    } else {
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recent Numbers'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        actions: [
          if (_recentNumbers.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _clearAll,
              tooltip: 'Clear All',
            ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _recentNumbers.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 64,
                        color: AppThemes.getSubtleTextColor(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'No recent numbers',
                        style: TextStyle(
                          fontSize: AppThemes.fontSizeLarge,
                          color: AppThemes.getSubtleTextColor(
                            Theme.of(context).brightness == Brightness.dark,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your recent phone numbers will appear here',
                        style: TextStyle(
                          fontSize: AppThemes.fontSizeMedium,
                          color: AppThemes.getSubtleTextColor(
                            Theme.of(context).brightness == Brightness.dark,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadRecentNumbers,
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _recentNumbers.length,
                    itemBuilder: (context, index) {
                      final phoneNumber = _recentNumbers[index];
                      return Container(
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
                            vertical: 12.0,
                          ),
                          leading: Container(
                            width: 48,
                            height: 48,
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: Icon(
                              Icons.phone,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          title: Text(
                            phoneNumber.fullNumber,
                            style: TextStyle(
                              fontSize: AppThemes.fontSizeLarge,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          subtitle: Text(
                            _formatDate(phoneNumber.timestamp),
                            style: TextStyle(
                              fontSize: AppThemes.fontSizeSmall,
                              color: AppThemes.getSubtleTextColor(
                                Theme.of(context).brightness == Brightness.dark,
                              ),
                            ),
                          ),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: SvgPicture.asset(
                                  'assets/icons/whatsapp_logo.svg',
                                  width: 24,
                                  height: 24,
                                ),
                                onPressed: () => _openWhatsApp(phoneNumber),
                                tooltip: 'Open WhatsApp',
                              ),
                              IconButton(
                                icon: Icon(
                                  Icons.delete_outline,
                                  color: AppThemes.getErrorColor(
                                    Theme.of(context).brightness == Brightness.dark,
                                  ),
                                ),
                                onPressed: () => _deletePhoneNumber(phoneNumber),
                                tooltip: 'Delete',
                              ),
                            ],
                          ),
                          onTap: () => _openWhatsApp(phoneNumber),
                        ),
                      );
                    },
                  ),
                ),
    );
  }
}
