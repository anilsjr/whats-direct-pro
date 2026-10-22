import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final noAds = ValueNotifier(false);
bool busy = false,
    _ready = false,
    _loadingTab = false,
    _loadingOpen = false,
    _disposed = false;
InterstitialAd? _tab;
AppOpenAd? _open;
DateTime? _lastTab, _lastOpen, _loadedOpen, _coldDeadline;
int _generation = 0;
bool get _mobile =>
    !kIsWeb &&
    (defaultTargetPlatform == TargetPlatform.android ||
        defaultTargetPlatform == TargetPlatform.iOS);
String _id(String kind) {
  final android = defaultTargetPlatform == TargetPlatform.android;
  if (!kDebugMode) {
    return switch (kind) {
      'banner' => const String.fromEnvironment('ADMOB_BANNER_ID'),
      'tab' => const String.fromEnvironment('ADMOB_INTERSTITIAL_ID'),
      _ => const String.fromEnvironment('ADMOB_APP_OPEN_ID'),
    };
  }
  final suffix = android
      ? {'banner': '6300978111', 'tab': '8691691433', 'open': '9257395921'}
      : {'banner': '2934735716', 'tab': '5135589807', 'open': '5575463023'};
  return 'ca-app-pub-3940256099942544/${suffix[kind]}';
}

Future<void> initAds() async {
  if (noAds.value) {
    noAds.addListener(_changed);
    return;
  }
  noAds.addListener(_changed);
  _coldDeadline = DateTime.now().add(const Duration(seconds: 4));
  await _start();
}

Future<void> _start() async {
  if (noAds.value) return;
  if (!_mobile || _disposed) return;
  try {
    await MobileAds.instance.initialize();
    _ready = true;
    _loadTab();
    await showAppOpen(cold: true);
  } catch (_) {
    /* Ads never prevent app use. */
  }
}

void _changed() {
  _generation++;
  _tab?.dispose();
  _tab = null;
  _open?.dispose();
  _open = null;
  _loadingTab = false;
  _loadingOpen = false;
  if (!noAds.value) {
    if (_ready) {
      _loadTab();
    } else {
      unawaited(_start());
    }
  }
}

void _loadTab() {
  if (noAds.value) return;
  if (!_ready || _disposed || _loadingTab || _tab != null || _id('tab').isEmpty)
    return;
  _loadingTab = true;
  final generation = _generation;
  InterstitialAd.load(
    adUnitId: _id('tab'),
    request: const AdRequest(),
    adLoadCallback: InterstitialAdLoadCallback(
      onAdLoaded: (ad) {
        if (generation != _generation || _disposed || noAds.value) {
          ad.dispose();
          return;
        }
        _loadingTab = false;
        _tab = ad;
      },
      onAdFailedToLoad: (_) {
        if (generation == _generation) _loadingTab = false;
      },
    ),
  ).catchError((_) {
    if (generation == _generation) _loadingTab = false;
  });
}

void showTabAd() {
  if (noAds.value) return;
  // ponytail: 60-second ceiling; tune placement and frequency before production.
  const gap = Duration(seconds: 60);
  if (busy || (_lastTab != null && DateTime.now().difference(_lastTab!) < gap)) {
    return;
  }
  final ad = _tab;
  if (ad == null) {
    _loadTab();
    return;
  }
  _tab = null;
  busy = true;
  ad.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (_) => _lastTab = DateTime.now(),
    onAdDismissedFullScreenContent: (ad) {
      ad.dispose();
      busy = false;
      _loadTab();
    },
    onAdFailedToShowFullScreenContent: (ad, _) {
      ad.dispose();
      busy = false;
      _loadTab();
    },
  );
  unawaited(
    ad.show().catchError((_) {
      ad.dispose();
      busy = false;
      _loadTab();
    }),
  );
}

Future<void> showAppOpen({bool cold = false}) async {
  if (noAds.value) return;
  const gap = Duration(hours: 4);
  if (!_ready ||
      _disposed ||
      busy ||
      _loadingOpen ||
      _id('open').isEmpty ||
      (_lastOpen != null && DateTime.now().difference(_lastOpen!) < gap))
    return;
  if (_open != null && DateTime.now().difference(_loadedOpen!) >= gap) {
    _open!.dispose();
    _open = null;
  }
  final generation = _generation;
  final deadline = cold
      ? (_coldDeadline ?? DateTime.now())
      : DateTime.now().add(const Duration(seconds: 4));
  if (_open == null) {
    _loadingOpen = true;
    final done = Completer<void>();
    AppOpenAd.load(
      adUnitId: _id('open'),
      request: const AdRequest(),
      adLoadCallback: AppOpenAdLoadCallback(
        onAdLoaded: (ad) {
          if (generation != _generation || noAds.value || _disposed) {
            ad.dispose();
          } else {
            _open = ad;
            _loadedOpen = DateTime.now();
            _loadingOpen = false;
          }
          if (!done.isCompleted) done.complete();
        },
        onAdFailedToLoad: (_) {
          if (generation == _generation) _loadingOpen = false;
          if (!done.isCompleted) done.complete();
        },
      ),
    ).catchError((_) {
      if (generation == _generation) _loadingOpen = false;
      if (!done.isCompleted) done.complete();
    });
    final remaining = deadline.difference(DateTime.now());
    if (remaining.isNegative) return;
    await done.future.timeout(remaining, onTimeout: () {});
  }
  if (_open == null ||
      busy ||
      noAds.value ||
      _disposed ||
      WidgetsBinding.instance.lifecycleState != AppLifecycleState.resumed ||
      generation != _generation ||
      (cold && DateTime.now().isAfter(deadline)))
    return;
  final ad = _open!;
  _open = null;
  busy = true;
  ad.fullScreenContentCallback = FullScreenContentCallback(
    onAdShowedFullScreenContent: (_) => _lastOpen = DateTime.now(),
    onAdDismissedFullScreenContent: (ad) {
      ad.dispose();
      busy = false;
    },
    onAdFailedToShowFullScreenContent: (ad, _) {
      ad.dispose();
      busy = false;
    },
  );
  try {
    await ad.show();
  } catch (_) {
    ad.dispose();
    busy = false;
  }
}

void disposeAds() {
  _disposed = true;
  _generation++;
  noAds.removeListener(_changed);
  _tab?.dispose();
  _open?.dispose();
}

class BannerBox extends StatefulWidget {
  const BannerBox({super.key});
  @override
  State<BannerBox> createState() => _BannerBoxState();
}

class _BannerBoxState extends State<BannerBox> {
  BannerAd? ad;
  bool loaded = false;
  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    if (noAds.value) return;
    if (!_mobile || _id('banner').isEmpty) return;
    try {
      await MobileAds.instance.initialize();
      if (!mounted || noAds.value) return;
      ad = BannerAd(
        size: AdSize.banner,
        adUnitId: _id('banner'),
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            if (mounted && !noAds.value) {
              setState(() => loaded = true);
            } else {
              ad.dispose();
            }
          },
          onAdFailedToLoad: (ad, _) {
            ad.dispose();
            if (mounted) {
              setState(() {
                this.ad = null;
                loaded = false;
              });
            }
          },
        ),
        request: const AdRequest(),
      );
      await ad!.load();
    } catch (_) {
      /* Fail silently. */
    }
  }

  @override
  void dispose() {
    ad?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => !loaded || ad == null
      ? const SizedBox.shrink()
      : SafeArea(
          top: false,
          bottom: false,
          child: SizedBox(
            width: ad!.size.width.toDouble(),
            height: ad!.size.height.toDouble(),
            child: AdWidget(ad: ad!),
          ),
        );
}
