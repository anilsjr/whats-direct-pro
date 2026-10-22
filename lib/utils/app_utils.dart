import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:url_launcher/url_launcher.dart';

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
