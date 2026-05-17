import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AppOpenAdManager {
  static final AppOpenAdManager _instance = AppOpenAdManager._internal();

  factory AppOpenAdManager() {
    return _instance;
  }

  AppOpenAdManager._internal();

  AppOpenAd? _appOpenAd;
  bool _isAdLoaded = false;
  bool _isShowingAd = false;

  // Uses test ad unit ID in debug mode, and real ad unit ID in release mode
  final String _adUnitId = kReleaseMode 
      ? 'ca-app-pub-8620043813842300/8710334925'
      : 'ca-app-pub-3940256099942544/9257395921';

  /// Load the app open ad
  Future<void> loadAd() async {
    if (_isAdLoaded || _appOpenAd != null) {
      return;
    }

    final completer = Completer<void>();

    await AppOpenAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          _appOpenAd = ad;
          _isAdLoaded = true;
          debugPrint('App Open Ad loaded successfully');
          if (!completer.isCompleted) completer.complete();
        },
        onAdFailedToLoad: (error) {
          _isAdLoaded = false;
          debugPrint('App Open Ad failed to load: $error');
          if (!completer.isCompleted) completer.complete();
        },
      ),
    );

    return completer.future;
  }

  /// Show the app open ad if available
  Future<void> showAdIfAvailable() async {
    if (!_isAdLoaded || _appOpenAd == null || _isShowingAd) {
      return;
    }

    _isShowingAd = true;

    _appOpenAd?.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (ad) {
        debugPrint('App Open Ad showed full screen content');
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        debugPrint('App Open Ad failed to show: $error');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _isAdLoaded = false;
      },
      onAdDismissedFullScreenContent: (ad) {
        debugPrint('App Open Ad dismissed');
        _isShowingAd = false;
        ad.dispose();
        _appOpenAd = null;
        _isAdLoaded = false;
        // Reload the ad for next time
        loadAd();
      },
    );

    try {
      await _appOpenAd?.show();
    } catch (e) {
      debugPrint('Error showing App Open Ad: $e');
      _isShowingAd = false;
    }
  }

  /// Clean up resources
  void dispose() {
    _appOpenAd?.dispose();
    _appOpenAd = null;
    _isAdLoaded = false;
    _isShowingAd = false;
  }
}
