import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../config/lang.dart';

String normalize(String raw) => String.fromCharCodes(raw.runes.map((r) {
  for (final zero in [0x660, 0x6f0, 0xff10]) { if (r >= zero && r <= zero + 9) return 48 + r - zero; }
  return r;
})).replaceAll(RegExp(r'[\s\u0085\u00a0\u1680\u2000-\u200b\u2028\u2029\u202f\u205f\u3000.\-\u2010-\u2015\u2212\ufe58\ufe63\uff0d]'), '');
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
  if ('+'.allMatches(n).length > 1 || (n.contains('+') && !n.startsWith('+'))) return 'errAmbiguous';
  return null;
}
String? parse(String raw, String iso) {
  if (phoneError(raw) != null) return null;
  var n = normalize(raw).replaceAll(RegExp(r'[()]'), '');
  if (n.startsWith('00')) n = '+${n.substring(2)}';
  try {
    final p = PhoneNumber.parse(n, destinationCountry: n.startsWith('+') ? null : IsoCode.values.byName(iso));
    final digits = p.international.substring(1);
    return p.isValid() && digits.length <= 15 ? digits : null;
  } catch (_) { return null; }
}
Future<bool> openChat(String digits, [String message = '']) async {
  try { return await launchUrl(Uri.parse('https://wa.me/$digits?text=${Uri.encodeComponent(message)}'), mode: LaunchMode.externalApplication); } catch (_) { return false; }
}
class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}
class _HomePageState extends State<HomePage> {
  final phone = TextEditingController(), message = TextEditingController();
  final focus = FocusNode();
  late Country country = Country.tryParse(prefs.getString('country') ?? 'IN') ?? Country.parse('IN');
  late List<String> samples = prefs.getStringList('samples') ?? [];
  String? error;
  bool sending = false;
  @override
  void dispose() { phone.dispose(); message.dispose(); focus.dispose(); super.dispose(); }
  Future<void> choose(Country next) async {
    setState(() => country = next);
    if (!await persist(prefs.setString('country', next.countryCode)) && mounted) notice(context, 'errSave');
  }
  Future<void> editSamples([String? remove]) async {
    final input = TextEditingController();
    final result = await showDialog<String>(context: context, builder: (context) => AlertDialog(title: Text(t(remove == null ? 'addSample' : 'delete')), content: remove == null ? TextField(controller: input, autofocus: true, maxLength: 500, maxLines: 3) : Text(remove), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(t('cancel'))), TextButton(onPressed: () { if (remove != null || input.text.trim().isNotEmpty) Navigator.pop(context, remove ?? input.text.trim()); }, child: Text(t(remove == null ? 'save' : 'delete')))]));
    // ponytail: dialog owns a short-lived controller; dispose after its route animation.
    Future.delayed(const Duration(seconds: 1), input.dispose);
    if (result == null || !mounted) return;
    final next = [...samples];
    if (remove != null) { next.remove(remove); } else if (!next.contains(result)) { next.add(result); }
    if (await persist(prefs.setStringList('samples', next))) { if (mounted) setState(() => samples = next); } else if (mounted) { notice(context, 'errSave'); }
  }
  Future<void> send() async {
    if (sending) return;
    final digits = parse(phone.text, country.countryCode);
    if (digits == null) { setState(() => error = phoneError(phone.text) ?? 'errInvalid'); focus.requestFocus(); return; }
    setState(() { sending = true; error = null; });
    final detected = PhoneNumber.parse('+$digits').isoCode.name;
    if (normalize(phone.text).startsWith('+') || normalize(phone.text).startsWith('00')) await choose(Country.parse(detected));
    final opened = await openChat(digits, message.text);
    if (opened) {
      final rows = prefs.getStringList('recent') ?? [];
      rows.removeWhere((row) => row.split('|').elementAtOrNull(1) == digits);
      rows.insert(0, '$detected|$digits|${DateTime.now().millisecondsSinceEpoch}');
      final saved = await persist(prefs.setStringList('recent', rows.take(50).toList()));
      recentTick.value++;
      if (!saved && mounted) notice(context, 'errSave');
    } else if (mounted) { notice(context, 'errLaunch'); }
    if (mounted) setState(() => sending = false);
  }
  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Scaffold(appBar: AppBar(title: const Text('WhatsApp Direct Pro')), body: SafeArea(top: false, child: Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 600), child: ListView(padding: const EdgeInsets.all(24), children: [
    Align(alignment: AlignmentDirectional.centerStart, child: Container(padding: const EdgeInsets.all(16), decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer, borderRadius: BorderRadius.circular(22)), child: Icon(Icons.forum_rounded, size: 36, color: Theme.of(context).colorScheme.primary))),
    const SizedBox(height: 22), Text(t('hero'), style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold)), const SizedBox(height: 8), Text(t('tagline'), style: Theme.of(context).textTheme.bodyLarge),
    const SizedBox(height: 28), Text(t('country'), style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 8),
    Card(margin: EdgeInsets.zero, elevation: 0, child: ListTile(shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)), leading: Text(country.flagEmoji, style: const TextStyle(fontSize: 28)), title: Text(country.getTranslatedName(context) ?? country.name), subtitle: Text('+${country.phoneCode}', textDirection: TextDirection.ltr), trailing: const Icon(Icons.keyboard_arrow_down), onTap: () => showCountryPicker(context: context, showPhoneCode: true, onSelect: choose))),
    const SizedBox(height: 20), TextField(controller: phone, focusNode: focus, textDirection: TextDirection.ltr, keyboardType: TextInputType.phone, autofillHints: const [AutofillHints.telephoneNumber], onChanged: (_) { if (error != null) setState(() => error = null); }, decoration: InputDecoration(labelText: t('phone'), hintText: t('phoneHint'), errorText: error == null ? null : t(error!), prefixIcon: const Icon(Icons.phone_outlined))),
    const SizedBox(height: 20), TextField(controller: message, minLines: 4, maxLines: 8, maxLength: 4000, decoration: InputDecoration(labelText: t('message'), alignLabelWithHint: true)),
    const SizedBox(height: 12), Text(t('samples'), style: Theme.of(context).textTheme.labelLarge), const SizedBox(height: 8),
    SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(spacing: 8, children: [ActionChip(avatar: const Icon(Icons.add, size: 18), label: Text(t('custom')), onPressed: editSamples), for (var i = 1; i <= 5; i++) ActionChip(label: Text(t('s$i')), onPressed: () => message.text = t('s$i')), for (final sample in samples) Tooltip(message: t('holdDelete'), child: GestureDetector(onLongPress: () => editSamples(sample), child: ActionChip(label: Text(sample, overflow: TextOverflow.ellipsis), onPressed: () => message.text = sample)))])),
    const SizedBox(height: 28), FilledButton.icon(onPressed: sending ? null : send, icon: sending ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)) : const Icon(Icons.send_rounded), label: Text(t('send'))), const SizedBox(height: 16), Row(mainAxisAlignment: MainAxisAlignment.center, children: [const Icon(Icons.lock_outline, size: 14), const SizedBox(width: 6), Flexible(child: Text(t('privacy'), style: Theme.of(context).textTheme.bodySmall))]),
  ])))));
  }
}



