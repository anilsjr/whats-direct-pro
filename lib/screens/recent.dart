import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'home.dart';
import '../main.dart';
import '../config/lang.dart';

class RecentPage extends StatefulWidget {
  const RecentPage({super.key});
  @override
  State<RecentPage> createState() => _RecentPageState();
}
class _RecentPageState extends State<RecentPage> {
  List<String> rows = [];
  final opening = <String>{};
  @override
  void initState() { super.initState(); reload(); recentTick.addListener(reload); }
  void reload() => setState(() => rows = (prefs.getStringList('recent') ?? []).where((r) { final p = r.split('|'); return p.length == 3 && Country.tryParse(p[0]) != null && RegExp(r'^\d{5,15}$').hasMatch(p[1]) && int.tryParse(p[2]) != null; }).toList());
  @override
  void dispose() { recentTick.removeListener(reload); super.dispose(); }
  String age(String raw) {
    final date = DateTime.fromMillisecondsSinceEpoch(int.parse(raw));
    final elapsed = DateTime.now().difference(date);
    if (elapsed.inMinutes < 1) return t('now');
    if (elapsed.inHours < 1) return t('minAgo', {'n': '${elapsed.inMinutes}'});
    final now = DateTime.now();
    final days = DateTime(now.year, now.month, now.day).difference(DateTime(date.year, date.month, date.day)).inDays;
    if (days == 1) return t('yesterday');
    if (elapsed.inHours < 24) return t('hAgo', {'n': '${elapsed.inHours}'});
    if (days <= 7) return t('dAgo', {'n': '$days'});
    return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year}';
  }
  Future<void> open(String digits) async {
    if (!opening.add(digits)) return;
    if (!await openChat(digits) && mounted) notice(context, 'errLaunch');
    opening.remove(digits);
  }
  Future<bool> remove(String row) async {
    final next = <String>[...?prefs.getStringList('recent')]..remove(row);
    final saved = await persist(prefs.setStringList('recent', next));
    if (!saved && mounted) notice(context, 'errSave');
    return saved;
  }
  Future<void> clear() async {
    final yes = await showDialog<bool>(context: context, builder: (context) => AlertDialog(title: Text(t('clearAll')), content: Text(t('clearConfirm')), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t('cancel'))), FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(t('clearAll')))]));
    if (yes != true) return;
    if (await persist(prefs.remove('recent'))) { if (mounted) reload(); } else if (mounted) { notice(context, 'errSave'); }
  }
  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Scaffold(appBar: AppBar(title: Text(t('recent')), actions: [if (rows.isNotEmpty) TextButton(onPressed: clear, child: Text(t('clearAll')))]), body: rows.isEmpty ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.history_rounded, size: 72, color: Theme.of(context).colorScheme.outline), const SizedBox(height: 20), Text(t('noRecent'))])) : ListView.builder(padding: const EdgeInsets.all(16), itemCount: rows.length, itemBuilder: (context, i) {
    final row = rows[i], p = row.split('|'), country = Country.parse(p[0]);
    return Dismissible(key: ValueKey(row), direction: DismissDirection.endToStart, confirmDismiss: (_) => remove(row), onDismissed: (_) => setState(() => rows.remove(row)), background: Container(alignment: AlignmentDirectional.centerEnd, padding: const EdgeInsets.all(24), color: Theme.of(context).colorScheme.errorContainer, child: Icon(Icons.delete_outline, semanticLabel: t('delete'))), child: Card(elevation: 0, child: ListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8), leading: CircleAvatar(child: Text(country.flagEmoji)), title: Text('+${p[1]}', textDirection: TextDirection.ltr), subtitle: Text('${country.getTranslatedName(context) ?? country.name} · ${age(p[2])}'), onTap: () => open(p[1]), trailing: IconButton(tooltip: t('send'), icon: const Icon(Icons.chat_outlined), onPressed: () => open(p[1])))));
  }));
  }
}



