import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class PhoneNumber {
  final String phoneNumber;
  final String countryCode;
  final DateTime timestamp;

  PhoneNumber({
    required this.phoneNumber,
    required this.countryCode,
    required this.timestamp,
  });

  Map<String, dynamic> toJson() {
    return {
      'phoneNumber': phoneNumber,
      'countryCode': countryCode,
      'timestamp': timestamp.toIso8601String(),
    };
  }

  factory PhoneNumber.fromJson(Map<String, dynamic> json) {
    return PhoneNumber(
      phoneNumber: json['phoneNumber'],
      countryCode: json['countryCode'],
      timestamp: DateTime.parse(json['timestamp']),
    );
  }

  String get fullNumber => '$countryCode'+ '-'+ '$phoneNumber';
}

class PhoneStorageService {
  static const String _key = 'recent_phone_numbers';
  static const int _maxRecentNumbers = 50; // Limit to 50 recent numbers

  // Save a phone number to recent list
  static Future<void> savePhoneNumber(
    String phoneNumber,
    String countryCode,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> phoneListJson = prefs.getStringList(_key) ?? [];

      // Create new phone number entry
      final newPhone = PhoneNumber(
        phoneNumber: phoneNumber,
        countryCode: countryCode,
        timestamp: DateTime.now(),
      );

      // Convert existing list to PhoneNumber objects
      List<PhoneNumber> phoneNumbers = phoneListJson
          .map((json) => PhoneNumber.fromJson(jsonDecode(json)))
          .toList();

      // Remove duplicate if exists (same phone number and country code)
      phoneNumbers.removeWhere(
        (phone) =>
            phone.phoneNumber == phoneNumber &&
            phone.countryCode == countryCode,
      );

      // Add new phone number at the beginning
      phoneNumbers.insert(0, newPhone);

      // Limit to max recent numbers
      if (phoneNumbers.length > _maxRecentNumbers) {
        phoneNumbers = phoneNumbers.sublist(0, _maxRecentNumbers);
      }

      // Convert back to JSON strings
      final updatedList = phoneNumbers
          .map((phone) => jsonEncode(phone.toJson()))
          .toList();

      await prefs.setStringList(_key, updatedList);
    } catch (e) {
      // Handle error silently or log it
      print('Error saving phone number: $e');
    }
  }

  // Get all recent phone numbers
  static Future<List<PhoneNumber>> getRecentPhoneNumbers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> phoneListJson = prefs.getStringList(_key) ?? [];

      return phoneListJson
          .map((json) => PhoneNumber.fromJson(jsonDecode(json)))
          .toList();
    } catch (e) {
      print('Error getting recent phone numbers: $e');
      return [];
    }
  }

  // Delete a specific phone number
  static Future<void> deletePhoneNumber(PhoneNumber phoneNumber) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final List<String> phoneListJson = prefs.getStringList(_key) ?? [];

      final phoneNumbers = phoneListJson
          .map((json) => PhoneNumber.fromJson(jsonDecode(json)))
          .toList();

      phoneNumbers.removeWhere(
        (phone) =>
            phone.phoneNumber == phoneNumber.phoneNumber &&
            phone.countryCode == phoneNumber.countryCode &&
            phone.timestamp == phoneNumber.timestamp,
      );

      final updatedList = phoneNumbers
          .map((phone) => jsonEncode(phone.toJson()))
          .toList();

      await prefs.setStringList(_key, updatedList);
    } catch (e) {
      print('Error deleting phone number: $e');
    }
  }

  // Clear all recent phone numbers
  static Future<void> clearAllRecentNumbers() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_key);
    } catch (e) {
      print('Error clearing recent phone numbers: $e');
    }
  }
}
