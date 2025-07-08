import 'package:flutter/material.dart';
import '../models/country.dart';
import '../theme/custom_theme.dart';

class CountryCodePicker extends StatefulWidget {
  final String selectedCountryCode;
  final Function(Country) onCountrySelected;
  final bool enabled;

  const CountryCodePicker({
    Key? key,
    required this.selectedCountryCode,
    required this.onCountrySelected,
    this.enabled = true,
  }) : super(key: key);

  @override
  State<CountryCodePicker> createState() => _CountryCodePickerState();
}

class _CountryCodePickerState extends State<CountryCodePicker> {
  Country? _selectedCountry;

  @override
  void initState() {
    super.initState();
    _selectedCountry = Countries.getCountryByCode(widget.selectedCountryCode);
  }

  @override
  void didUpdateWidget(CountryCodePicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedCountryCode != widget.selectedCountryCode) {
      _selectedCountry = Countries.getCountryByCode(widget.selectedCountryCode);
    }
  }

  void _showCountryPicker() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _CountryPickerBottomSheet(
        selectedCountry: _selectedCountry!,
        onCountrySelected: (country) {
          setState(() {
            _selectedCountry = country;
          });
          widget.onCountrySelected(country);
          Navigator.pop(context);
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.enabled ? _showCountryPicker : null,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Flag
            Container(
              width: 24,
              height: 16,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(2),
                border: Border.all(
                  color: AppThemes.getBorderColor(
                    Theme.of(context).brightness == Brightness.dark,
                  ),
                  width: 0.5,
                ),
              ),
              child: Center(
                child: Text(
                  _selectedCountry?.flag ?? '🇮🇳',
                  style: const TextStyle(fontSize: 12),
                ),
              ),
            ),
            const SizedBox(width: 8),
            // Country Code
            Text(
              _selectedCountry?.code ?? '+91',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            if (widget.enabled) ...[
              const SizedBox(width: 4),
              Icon(
                Icons.arrow_drop_down,
                color: AppThemes.getSubtleTextColor(
                  Theme.of(context).brightness == Brightness.dark,
                ),
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _CountryPickerBottomSheet extends StatefulWidget {
  final Country selectedCountry;
  final Function(Country) onCountrySelected;

  const _CountryPickerBottomSheet({
    required this.selectedCountry,
    required this.onCountrySelected,
  });

  @override
  State<_CountryPickerBottomSheet> createState() =>
      _CountryPickerBottomSheetState();
}

class _CountryPickerBottomSheetState extends State<_CountryPickerBottomSheet> {
  final TextEditingController _searchController = TextEditingController();
  List<Country> _filteredCountries = Countries.list;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterCountries);
  }

  @override
  void dispose() {
    _searchController.removeListener(_filterCountries);
    _searchController.dispose();
    super.dispose();
  }

  void _filterCountries() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredCountries = Countries.list.where((country) {
        return country.name.toLowerCase().contains(query) ||
            country.code.contains(query);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.75,
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          // Handle bar
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppThemes.getBorderColor(
                Theme.of(context).brightness == Brightness.dark,
              ),
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Text(
                  'Select Country',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                const Spacer(),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                  iconSize: 20,
                ),
              ],
            ),
          ),

          // Search bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Container(
              decoration: BoxDecoration(
                color: AppThemes.getCardBackgroundColor(
                  Theme.of(context).brightness == Brightness.dark,
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  hintText: 'Search countries...',
                  prefixIcon: Icon(
                    Icons.search,
                    color: AppThemes.getSubtleTextColor(
                      Theme.of(context).brightness == Brightness.dark,
                    ),
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Countries list
          Expanded(
            child: ListView.builder(
              itemCount: _filteredCountries.length,
              itemBuilder: (context, index) {
                final country = _filteredCountries[index];
                final isSelected = country.code == widget.selectedCountry.code;

                return ListTile(
                  onTap: () => widget.onCountrySelected(country),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 4,
                  ),
                  leading: Container(
                    width: 32,
                    height: 24,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: AppThemes.getBorderColor(
                          Theme.of(context).brightness == Brightness.dark,
                        ),
                        width: 0.5,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        country.flag,
                        style: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                  title: Text(
                    country.name,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : Theme.of(context).textTheme.bodyLarge?.color,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  trailing: Text(
                    country.code,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color: isSelected
                          ? Theme.of(context).primaryColor
                          : AppThemes.getSubtleTextColor(
                              Theme.of(context).brightness == Brightness.dark,
                            ),
                    ),
                  ),
                  selected: isSelected,
                  selectedTileColor: Theme.of(
                    context,
                  ).primaryColor.withOpacity(0.1),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
