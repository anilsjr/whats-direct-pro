import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SaveNumberProvider extends ChangeNotifier {
  bool _isSaveNumberEnabled = false;

  bool get isSaveNumberEnabled => _isSaveNumberEnabled;

  Future<void> toggleSaveNumber() async {
    _isSaveNumberEnabled = !_isSaveNumberEnabled;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isSaveNumberEnabled', _isSaveNumberEnabled);
  }

  Future<void> loadSavedNumberFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isSaveNumberEnabled = prefs.getBool('isSaveNumberEnabled') ?? false;
    notifyListeners();
  }

  Future<void> saveNumber(String number) async {
    if (_isSaveNumberEnabled) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('savedNumber', number);
    }
  }

  Future<String?> getSavedNumber() async {
    if (_isSaveNumberEnabled) {
      final prefs = await SharedPreferences.getInstance();
      return prefs.getString('savedNumber');
    }
    return null;
  }

  Future<void> clearSavedNumber() async {
    if (_isSaveNumberEnabled) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('savedNumber');
    }
  }
}
