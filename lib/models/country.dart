class Country {
  final String name;
  final String code;
  final String flag;
  final int phoneNumberLength;

  const Country({
    required this.name,
    required this.code,
    required this.flag,
    required this.phoneNumberLength,
  });
}

// Common countries list with flags
class Countries {
  static const List<Country> list = [
    Country(name: 'Afghanistan', code: '+93', flag: '🇦🇫', phoneNumberLength: 9),
    Country(name: 'Albania', code: '+355', flag: '🇦🇱', phoneNumberLength: 9),
    Country(name: 'Algeria', code: '+213', flag: '🇩🇿', phoneNumberLength: 9),
    Country(name: 'Argentina', code: '+54', flag: '🇦🇷', phoneNumberLength: 10),
    Country(name: 'Australia', code: '+61', flag: '🇦🇺', phoneNumberLength: 9),
    Country(name: 'Austria', code: '+43', flag: '🇦🇹', phoneNumberLength: 10),
    Country(name: 'Bangladesh', code: '+880', flag: '🇧🇩', phoneNumberLength: 10),
    Country(name: 'Belgium', code: '+32', flag: '🇧🇪', phoneNumberLength: 9),
    Country(name: 'Brazil', code: '+55', flag: '🇧🇷', phoneNumberLength: 11),
    Country(name: 'Canada', code: '+1', flag: '🇨🇦', phoneNumberLength: 10),
    Country(name: 'China', code: '+86', flag: '🇨🇳', phoneNumberLength: 11),
    Country(name: 'Egypt', code: '+20', flag: '🇪🇬', phoneNumberLength: 10),
    Country(name: 'France', code: '+33', flag: '🇫🇷', phoneNumberLength: 9),
    Country(name: 'Germany', code: '+49', flag: '🇩🇪', phoneNumberLength: 11),
    Country(name: 'India', code: '+91', flag: '🇮🇳', phoneNumberLength: 10),
    Country(name: 'Indonesia', code: '+62', flag: '🇮🇩', phoneNumberLength: 10),
    Country(name: 'Iran', code: '+98', flag: '🇮🇷', phoneNumberLength: 10),
    Country(name: 'Iraq', code: '+964', flag: '🇮🇶', phoneNumberLength: 10),
    Country(name: 'Italy', code: '+39', flag: '🇮🇹', phoneNumberLength: 10),
    Country(name: 'Japan', code: '+81', flag: '🇯🇵', phoneNumberLength: 10),
    Country(name: 'Jordan', code: '+962', flag: '🇯🇴', phoneNumberLength: 9),
    Country(name: 'Kuwait', code: '+965', flag: '🇰🇼', phoneNumberLength: 8),
    Country(name: 'Lebanon', code: '+961', flag: '🇱🇧', phoneNumberLength: 8),
    Country(name: 'Malaysia', code: '+60', flag: '🇲🇾', phoneNumberLength: 9),
    Country(name: 'Mexico', code: '+52', flag: '🇲🇽', phoneNumberLength: 10),
    Country(name: 'Morocco', code: '+212', flag: '🇲🇦', phoneNumberLength: 9),
    Country(name: 'Netherlands', code: '+31', flag: '🇳🇱', phoneNumberLength: 9),
    Country(name: 'Nigeria', code: '+234', flag: '🇳🇬', phoneNumberLength: 10),
    Country(name: 'Pakistan', code: '+92', flag: '🇵🇰', phoneNumberLength: 10),
    Country(name: 'Philippines', code: '+63', flag: '🇵🇭', phoneNumberLength: 10),
    Country(name: 'Poland', code: '+48', flag: '🇵🇱', phoneNumberLength: 9),
    Country(name: 'Qatar', code: '+974', flag: '🇶🇦', phoneNumberLength: 8),
    Country(name: 'Russia', code: '+7', flag: '🇷🇺', phoneNumberLength: 10),
    Country(name: 'Saudi Arabia', code: '+966', flag: '🇸🇦', phoneNumberLength: 9),
    Country(name: 'Singapore', code: '+65', flag: '🇸🇬', phoneNumberLength: 8),
    Country(name: 'South Africa', code: '+27', flag: '🇿🇦', phoneNumberLength: 9),
    Country(name: 'South Korea', code: '+82', flag: '🇰🇷', phoneNumberLength: 10),
    Country(name: 'Spain', code: '+34', flag: '🇪🇸', phoneNumberLength: 9),
    Country(name: 'Sri Lanka', code: '+94', flag: '🇱🇰', phoneNumberLength: 9),
    Country(name: 'Sudan', code: '+249', flag: '🇸🇩', phoneNumberLength: 9),
    Country(name: 'Sweden', code: '+46', flag: '🇸🇪', phoneNumberLength: 9),
    Country(name: 'Switzerland', code: '+41', flag: '🇨🇭', phoneNumberLength: 9),
    Country(name: 'Syria', code: '+963', flag: '🇸🇾', phoneNumberLength: 9),
    Country(name: 'Thailand', code: '+66', flag: '🇹🇭', phoneNumberLength: 9),
    Country(name: 'Turkey', code: '+90', flag: '🇹🇷', phoneNumberLength: 10),
    Country(name: 'Ukraine', code: '+380', flag: '🇺🇦', phoneNumberLength: 9),
    Country(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪', phoneNumberLength: 9),
    Country(name: 'United Kingdom', code: '+44', flag: '🇬🇧', phoneNumberLength: 10),
    Country(name: 'United States', code: '+1', flag: '🇺🇸', phoneNumberLength: 10),
    Country(name: 'Vietnam', code: '+84', flag: '🇻🇳', phoneNumberLength: 9),
    Country(name: 'Yemen', code: '+967', flag: '🇾🇪', phoneNumberLength: 9),
  ];

  static Country getCountryByCode(String code) {
    return list.firstWhere(
      (country) => country.code == code,
      orElse: () => const Country(name: 'India', code: '+91', flag: '🇮🇳', phoneNumberLength: 10),
    );
  }
}
