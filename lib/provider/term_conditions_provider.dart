import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsConditionsProvider extends ChangeNotifier {
  bool _isFirstVisit = true;

  bool get isFirstVisit => _isFirstVisit;

  Future<void> toggleFirstVisit() async {
    _isFirstVisit = !_isFirstVisit;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isFirstVisit', _isFirstVisit);
  }

  Future<void> loadFirstVisitFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    _isFirstVisit = prefs.getBool('isFirstVisit') ?? true;
    notifyListeners();
  }
}
