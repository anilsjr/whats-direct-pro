import 'package:shared_preferences/shared_preferences.dart';

class CountryPreferenceService {
  static const String _countryCodeKey = 'selected_country_code';
  static const String _showCountryPickerKey = 'show_country_picker';
  static const String _defaultCountryCode = '+91';

  // Save the selected country code
  static Future<void> saveCountryCode(String countryCode) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_countryCodeKey, countryCode);
    } catch (e) {
      print('Error saving country code: $e');
    }
  }

  // Get the saved country code
  static Future<String> getCountryCode() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString(_countryCodeKey) ?? _defaultCountryCode;
    } catch (e) {
      print('Error getting country code: $e');
      return _defaultCountryCode;
    }
  }

  // Save the show country picker preference
  static Future<void> saveShowCountryPicker(bool showCountryPicker) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_showCountryPickerKey, showCountryPicker);
    } catch (e) {
      print('Error saving show country picker preference: $e');
    }
  }

  // Get the show country picker preference
  static Future<bool> getShowCountryPicker() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getBool(_showCountryPickerKey) ?? true; // Default to true
    } catch (e) {
      print('Error getting show country picker preference: $e');
      return true;
    }
  }

  // Clear all country preferences
  static Future<void> clearPreferences() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_countryCodeKey);
      await prefs.remove(_showCountryPickerKey);
    } catch (e) {
      print('Error clearing country preferences: $e');
    }
  }
}
