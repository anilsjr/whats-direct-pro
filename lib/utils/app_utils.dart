import 'package:flutter/material.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import '../config/lang.dart';

class AppTopBar extends StatelessWidget implements PreferredSizeWidget {
  const AppTopBar({
    super.key,
    required this.title,
    required this.isDark,
    required this.onLanguage,
    required this.onTheme,
  });

  final String title;
  final bool isDark;
  final VoidCallback onLanguage;
  final VoidCallback onTheme;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: const TextStyle(
          color: Color(0xFF25D366),
          fontSize: 22,
          fontWeight: FontWeight.w700,
        ),
      ),
      actions: [
        IconButton(
          tooltip: t('language'),
          onPressed: onLanguage,
          icon: const Icon(Icons.language_outlined),
        ),
        IconButton(
          tooltip: t(isDark ? 'light' : 'dark'),
          onPressed: onTheme,
          icon: Icon(
            isDark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
          ),
        ),
      ],
    );
  }
}

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onDestinationSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onDestinationSelected;

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      height: 64,
      selectedIndex: selectedIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: [
        NavigationDestination(
          icon: const Icon(Icons.chat_outlined),
          selectedIcon: const Icon(Icons.chat),
          label: t('home'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.build_outlined),
          selectedIcon: const Icon(Icons.build),
          label: t('tools'),
        ),
        NavigationDestination(
          icon: const Icon(Icons.settings_outlined),
          label: t('settings'),
        ),
      ],
    );
  }
}

String normalize(String raw) =>
    String.fromCharCodes(
      raw.runes.map((r) {
        for (final zero in [0x660, 0x6f0, 0xff10]) {
          if (r >= zero && r <= zero + 9) return 48 + r - zero;
        }
        return r;
      }),
    ).replaceAll(
      RegExp(
        r'[\s\u0085\u00a0\u1680\u2000-\u200b\u2028\u2029\u202f\u205f\u3000.\-\u2010-\u2015\u2212\ufe58\ufe63\uff0d]',
      ),
      '',
    );

String? phoneError(String raw) {
  final n = normalize(raw);
  if (n.isEmpty || n == '+' || n == '00') return 'errEmpty';
  int depth = 0;
  for (final r in n.runes) {
    if (r == 40 && ++depth > 1) return 'errParens';
    if (r == 41 && --depth < 0) return 'errParens';
  }
  if (depth != 0) return 'errParens';
  if (RegExp(r'[^0-9+()]').hasMatch(n)) return 'errChars';
  if ('+'.allMatches(n).length > 1 || (n.contains('+') && !n.startsWith('+'))) {
    return 'errAmbiguous';
  }
  return null;
}

String? parse(String raw, String iso) {
  if (phoneError(raw) != null) return null;
  var n = normalize(raw).replaceAll(RegExp(r'[()]'), '');
  if (n.startsWith('00')) n = '+${n.substring(2)}';
  try {
    final p = PhoneNumber.parse(
      n,
      destinationCountry: n.startsWith('+') ? null : IsoCode.values.byName(iso),
    );
    final digits = p.international.substring(1);
    return p.isValid() && digits.length <= 15 ? digits : null;
  } catch (_) {
    return null;
  }
}

Future<bool> openChat(String digits, [String message = '']) async {
  try {
    return await launchUrl(
      Uri.parse('https://wa.me/$digits?text=${Uri.encodeComponent(message)}'),
      mode: LaunchMode.externalApplication,
    );
  } catch (_) {
    return false;
  }
}
