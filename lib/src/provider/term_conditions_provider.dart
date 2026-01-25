import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TermsConditionsProvider extends ChangeNotifier {
  static const String _prefsKey = 'isFirstVisit';
  static const bool _defaultFirstVisit = true;

  bool _isFirstVisit = _defaultFirstVisit;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isFirstVisit => _isFirstVisit;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  bool get hasError => _errorMessage != null;

  Future<void> acceptTermsAndConditions() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _isFirstVisit = false;
      final prefs = await SharedPreferences.getInstance();
      final success = await prefs.setBool(_prefsKey, _isFirstVisit);

      if (!success) {
        throw Exception('Failed to save terms acceptance');
      }

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error accepting terms: ${e.toString()}';
      _isFirstVisit = true; // Revert on error
      notifyListeners();
      rethrow;
    }
  }

  @Deprecated('Use acceptTermsAndConditions() instead')
  Future<void> toggleFirstVisit() async {
    await acceptTermsAndConditions();
  }

  Future<bool> loadFirstVisitFromPrefs() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      final prefs = await SharedPreferences.getInstance();
      _isFirstVisit = prefs.getBool(_prefsKey) ?? _defaultFirstVisit;

      _isLoading = false;
      notifyListeners();
      return _isFirstVisit;
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error loading terms state: ${e.toString()}';
      _isFirstVisit = _defaultFirstVisit; // Use default on error
      notifyListeners();
      return _defaultFirstVisit;
    }
  }

  Future<void> resetTermsAcceptance() async {
    try {
      _isLoading = true;
      _errorMessage = null;
      notifyListeners();

      _isFirstVisit = _defaultFirstVisit;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_prefsKey);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Error resetting terms state: ${e.toString()}';
      notifyListeners();
    }
  }

  /// Clear any error state.
  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
