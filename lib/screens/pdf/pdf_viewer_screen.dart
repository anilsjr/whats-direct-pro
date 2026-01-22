import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path/path.dart' as path;
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

import 'package:whats_direct_pro/ads_units/banner_ad.dart';
import 'package:whats_direct_pro/ads_units/interstitial_ad_controller.dart';
import 'package:whats_direct_pro/theme/custom_theme.dart';

class PdfViewerScreen extends StatefulWidget {
  final String filePath;
  final String? displayName;

  const PdfViewerScreen({
    super.key,
    required this.filePath,
    this.displayName,
  });

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  late final PdfViewerController _pdfController;
  late final TextEditingController _searchController;
  PdfTextSearchResult _searchResult = PdfTextSearchResult();
  late final InterstitialAdController _interstitialAdController;
  Timer? _adTimer;
  bool _isSearching = false;
  bool _loadFailed = false;
  String? _loadError;

  @override
  void initState() {
    super.initState();
    _pdfController = PdfViewerController();
    _searchController = TextEditingController();
    _interstitialAdController = InterstitialAdController()..load();
    _adTimer = Timer.periodic(
      const Duration(seconds: 30),
      (_) => _interstitialAdController.showIfAvailable(),
    );
  }

  @override
  void dispose() {
    _adTimer?.cancel();
    _interstitialAdController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _startSearch() {
    setState(() {
      _isSearching = true;
    });
  }

  void _stopSearch() {
    _searchResult.clear();
    _searchController.clear();
    setState(() {
      _isSearching = false;
    });
  }

  void _runSearch() {
    final query = _searchController.text.trim();
    if (query.isEmpty) {
      _searchResult.clear();
      setState(() {});
      return;
    }
    _searchResult = _pdfController.searchText(query);
    if (!_searchResult.hasResult) {
      _showSnackBar('No results found.');
    }
    setState(() {});
  }

  void _showSnackBar(String message) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppThemes.getErrorColor(isDark),
      ),
    );
  }

  String get _title {
    final name = widget.displayName?.trim();
    if (name != null && name.isNotEmpty) {
      return name;
    }
    return path.basename(widget.filePath);
  }

  Widget _buildErrorState(String message) {
    return Column(
      children: [
        const BannerAdWidget(),
        Expanded(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final file = File(widget.filePath);
    final isMissing = !_loadFailed && !file.existsSync();
    final errorMessage = _loadError ??
        (isMissing ? 'Unable to locate the PDF file.' : null);

    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? Builder(
                builder: (context) {
                  final appBarColor =
                      Theme.of(context).appBarTheme.foregroundColor ??
                          Theme.of(context).colorScheme.onSurface;
                  return TextField(
                    controller: _searchController,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    style: TextStyle(color: appBarColor),
                    cursorColor: appBarColor,
                    decoration: InputDecoration(
                      hintText: 'Search in PDF',
                      hintStyle: TextStyle(color: appBarColor.withOpacity(0.7)),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _runSearch(),
                  );
                },
              )
            : Text(_title),
        actions: _isSearching
            ? [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _runSearch,
                ),
                if (_searchResult.hasResult)
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_up),
                    onPressed: _searchResult.previousInstance,
                  ),
                if (_searchResult.hasResult)
                  IconButton(
                    icon: const Icon(Icons.keyboard_arrow_down),
                    onPressed: _searchResult.nextInstance,
                  ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _stopSearch,
                ),
              ]
            : [
                IconButton(
                  icon: const Icon(Icons.search),
                  onPressed: _startSearch,
                ),
              ],
      ),
      body: _loadFailed || isMissing
          ? _buildErrorState(
              errorMessage ?? 'Unable to open this PDF.',
            )
          : Column(
              children: [
                const BannerAdWidget(),
                Expanded(
                  child: SfPdfViewer.file(
                    file,
                    controller: _pdfController,
                    onDocumentLoadFailed: (details) {
                      if (!mounted) {
                        return;
                      }
                      setState(() {
                        _loadFailed = true;
                        _loadError = details.description;
                      });
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
