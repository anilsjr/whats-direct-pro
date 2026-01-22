import 'package:google_mobile_ads/google_mobile_ads.dart';

class InterstitialAdController {
  InterstitialAd? _interstitialAd;
  bool _isLoading = false;
  bool _isShowing = false;

  static const String _adUnitId = 'ca-app-pub-3940256099942544/1033173712';

  void load() {
    if (_isLoading || _interstitialAd != null) {
      return;
    }
    _isLoading = true;
    InterstitialAd.load(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isLoading = false;
        },
        onAdFailedToLoad: (error) {
          _interstitialAd = null;
          _isLoading = false;
        },
      ),
    );
  }

  void showIfAvailable() {
    if (_isShowing) {
      return;
    }
    final ad = _interstitialAd;
    if (ad == null) {
      load();
      return;
    }
    _isShowing = true;
    ad.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        _isShowing = false;
        load();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        _isShowing = false;
        load();
      },
      onAdShowedFullScreenContent: (ad) {
        _isShowing = true;
      },
    );
    ad.show();
  }

  void dispose() {
    _interstitialAd?.dispose();
    _interstitialAd = null;
  }
}
