class Country {
  final String name;
  final String code;
  final String flag;

  const Country({required this.name, required this.code, required this.flag});
}

// Common countries list with flags
class Countries {
  static const List<Country> list = [
    Country(name: 'Afghanistan', code: '+93', flag: '🇦🇫'),
    Country(name: 'Albania', code: '+355', flag: '🇦🇱'),
    Country(name: 'Algeria', code: '+213', flag: '🇩🇿'),
    Country(name: 'Argentina', code: '+54', flag: '🇦🇷'),
    Country(name: 'Australia', code: '+61', flag: '🇦🇺'),
    Country(name: 'Austria', code: '+43', flag: '🇦🇹'),
    Country(name: 'Bangladesh', code: '+880', flag: '🇧🇩'),
    Country(name: 'Belgium', code: '+32', flag: '🇧🇪'),
    Country(name: 'Brazil', code: '+55', flag: '🇧🇷'),
    Country(name: 'Canada', code: '+1', flag: '🇨🇦'),
    Country(name: 'China', code: '+86', flag: '🇨🇳'),
    Country(name: 'Egypt', code: '+20', flag: '🇪🇬'),
    Country(name: 'France', code: '+33', flag: '🇫🇷'),
    Country(name: 'Germany', code: '+49', flag: '🇩🇪'),
    Country(name: 'India', code: '+91', flag: '🇮🇳'),
    Country(name: 'Indonesia', code: '+62', flag: '🇮🇩'),
    Country(name: 'Iran', code: '+98', flag: '🇮🇷'),
    Country(name: 'Iraq', code: '+964', flag: '🇮🇶'),
    Country(name: 'Italy', code: '+39', flag: '🇮🇹'),
    Country(name: 'Japan', code: '+81', flag: '🇯🇵'),
    Country(name: 'Jordan', code: '+962', flag: '🇯🇴'),
    Country(name: 'Kuwait', code: '+965', flag: '🇰🇼'),
    Country(name: 'Lebanon', code: '+961', flag: '🇱🇧'),
    Country(name: 'Malaysia', code: '+60', flag: '🇲🇾'),
    Country(name: 'Mexico', code: '+52', flag: '🇲🇽'),
    Country(name: 'Morocco', code: '+212', flag: '🇲🇦'),
    Country(name: 'Netherlands', code: '+31', flag: '🇳🇱'),
    Country(name: 'Nigeria', code: '+234', flag: '🇳🇬'),
    Country(name: 'Pakistan', code: '+92', flag: '🇵🇰'),
    Country(name: 'Philippines', code: '+63', flag: '🇵🇭'),
    Country(name: 'Poland', code: '+48', flag: '🇵🇱'),
    Country(name: 'Qatar', code: '+974', flag: '🇶🇦'),
    Country(name: 'Russia', code: '+7', flag: '🇷🇺'),
    Country(name: 'Saudi Arabia', code: '+966', flag: '🇸🇦'),
    Country(name: 'Singapore', code: '+65', flag: '🇸🇬'),
    Country(name: 'South Africa', code: '+27', flag: '🇿🇦'),
    Country(name: 'South Korea', code: '+82', flag: '🇰🇷'),
    Country(name: 'Spain', code: '+34', flag: '🇪🇸'),
    Country(name: 'Sri Lanka', code: '+94', flag: '🇱🇰'),
    Country(name: 'Sudan', code: '+249', flag: '🇸🇩'),
    Country(name: 'Sweden', code: '+46', flag: '🇸🇪'),
    Country(name: 'Switzerland', code: '+41', flag: '🇨🇭'),
    Country(name: 'Syria', code: '+963', flag: '🇸🇾'),
    Country(name: 'Thailand', code: '+66', flag: '🇹🇭'),
    Country(name: 'Turkey', code: '+90', flag: '🇹🇷'),
    Country(name: 'Ukraine', code: '+380', flag: '🇺🇦'),
    Country(name: 'United Arab Emirates', code: '+971', flag: '🇦🇪'),
    Country(name: 'United Kingdom', code: '+44', flag: '🇬🇧'),
    Country(name: 'United States', code: '+1', flag: '🇺🇸'),
    Country(name: 'Vietnam', code: '+84', flag: '🇻🇳'),
    Country(name: 'Yemen', code: '+967', flag: '🇾🇪'),
  ];

  static Country getCountryByCode(String code) {
    return list.firstWhere(
      (country) => country.code == code,
      orElse: () => const Country(name: 'India', code: '+91', flag: '🇮🇳'),
    );
  }
}
