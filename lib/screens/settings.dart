import 'package:introduction_screen/introduction_screen.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../config/lang.dart';
import '../config/ads.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});
  @override
  State<SettingsPage> createState() => _SettingsPageState();
}
class _SettingsPageState extends State<SettingsPage> {
  bool changingReminders = false;
  Future<void> changeReminders(bool enabled) async {
    setState(() => changingReminders = true);
    final ok = await updateReminders(enabled, request: enabled);
    if (!mounted) return;
    setState(() => changingReminders = false);
    if (!ok) notice(context, 'errNotify');
  }
  Future<void> language() async { await chooseLanguage(context); if (mounted) setState(() {}); }
  Future<void> toggle(String key, bool value) async {
    if (!await persist(prefs.setBool(key, value))) { if (mounted) notice(context, 'errSave'); return; }
    if (key == 'dark') { theme.value = value ? ThemeMode.dark : ThemeMode.light; } else { noAds.value = value; }
    if (mounted) setState(() {});
  }
  Future<void> more() async {
    // ponytail: developer page is configured at build time until a store account exists.
    const id = String.fromEnvironment('PLAY_DEVELOPER_ID');
    if (id.isEmpty) { notice(context, 'storePending'); return; }
    try { if (await launchUrl(Uri.https('play.google.com', '/store/apps/dev', {'id': id}), mode: LaunchMode.externalApplication)) return; } catch (_) { /* Launcher failures are shown below. */ }
    if (mounted) notice(context, 'errLaunch');
  }
  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Scaffold(appBar: AppBar(title: Text(t('settings'))), body: ListView(padding: const EdgeInsets.all(16), children: [
    Card(elevation: 0, child: Column(children: [SwitchListTile(secondary: const Icon(Icons.dark_mode_outlined), title: Text(t('dark')), value: theme.value == ThemeMode.dark, onChanged: (v) => toggle('dark', v)), const Divider(height: 1), ListTile(leading: const Icon(Icons.language), title: Text(t('language')), subtitle: Text(prefs.getBool('systemLanguage') == true ? t('systemDefault') : names[lang.value.languageCode]!), trailing: const Icon(Icons.chevron_right), onTap: language)])),
    const SizedBox(height: 12), Card(elevation: 0, child: Column(children: [ListTile(leading: const Icon(Icons.apps_rounded), title: Text(t('moreApps')), trailing: const Icon(Icons.open_in_new, size: 20), onTap: more), const Divider(height: 1),
    // ponytail: free toggle for now; upgrade path = in_app_purchase remove ads.
    SwitchListTile(secondary: const Icon(Icons.block_outlined), title: Text(t('stopAds')), value: noAds.value, onChanged: (v) => toggle('noAds', v))])),
    const SizedBox(height: 12), ValueListenableBuilder(valueListenable: reminders, builder: (_, enabled, child) => Card(elevation: 0, child: SwitchListTile(secondary: const Icon(Icons.notifications_none_rounded), title: Text(t('reminders')), subtitle: Text(t('reminderTimes')), value: enabled, onChanged: changingReminders ? null : changeReminders))),
    const SizedBox(height: 32), const Icon(Icons.chat_rounded, size: 36), const SizedBox(height: 12), const Center(child: Text('WhatsApp Direct Pro')), const SizedBox(height: 6), Center(child: Text('${t('version')} 1.0.0', style: Theme.of(context).textTheme.bodySmall)),
  ]));
  }
}




class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onDone});
  final VoidCallback onDone;
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}
class _OnboardingPageState extends State<OnboardingPage> {
  bool finishing = false;
  Future<void> finish() async {
    if (finishing) return;
    setState(() => finishing = true);
    final allow = await showDialog<bool>(context: context, builder: (context) => AlertDialog(icon: const Icon(Icons.notifications_none_rounded, size: 36), title: Text(t('reminders')), content: Text(t('notifyExplain')), actions: [TextButton(onPressed: () => Navigator.pop(context, false), child: Text(t('later'))), FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(t('allow')))]));
    if (!mounted) return;
    if (allow == null) { setState(() => finishing = false); return; }
    if (allow && !await updateReminders(true, request: true) && mounted) notice(context, 'errNotify');
    if (!await persist(prefs.setBool('onboarded', true))) { if (mounted) { notice(context, 'errSave'); setState(() => finishing = false); } return; }
    if (mounted) widget.onDone();
  }
  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    final colors = Theme.of(context).colorScheme;
    return Scaffold(body: SafeArea(child: Column(children: [
      Padding(padding: const EdgeInsetsDirectional.fromSTEB(16, 12, 16, 0), child: Row(children: [Expanded(child: OutlinedButton.icon(onPressed: finishing ? null : () => chooseLanguage(context), icon: const Icon(Icons.language), label: Text(names[lang.value.languageCode]!))), const SizedBox(width: 12), IconButton.filledTonal(tooltip: t(theme.value == ThemeMode.dark ? 'light' : 'dark'), onPressed: finishing ? null : () => chooseTheme(context, theme.value != ThemeMode.dark), icon: Icon(theme.value == ThemeMode.dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined))])),
      Expanded(child: AbsorbPointer(absorbing: finishing, child: IntroductionScreen(globalBackgroundColor: Theme.of(context).scaffoldBackgroundColor, showBackButton: true, back: Text(t('back')), next: Text(t('next')), done: finishing ? const SizedBox.square(dimension: 20, child: CircularProgressIndicator(strokeWidth: 2)) : Text(t('getStarted')), onDone: finish,
        dotsDecorator: DotsDecorator(activeColor: colors.primary, color: colors.outlineVariant, activeSize: const Size(24, 8), size: const Size(8, 8), activeShape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8))),
        pages: [for (final i in [1, 2]) PageViewModel(title: t('introTitle$i'), bodyWidget: Column(children: [Text(t('introBody$i'), textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge), const SizedBox(height: 24), for (final key in (i == 1 ? ['introNumber', 'introPrivacy'] : ['introSamples', 'introRecent'])) Padding(padding: const EdgeInsets.symmetric(vertical: 8), child: Row(children: [Icon(Icons.check_circle_outline, color: colors.primary), const SizedBox(width: 12), Expanded(child: Text(t(key)))]))]),
          image: Center(child: Container(padding: const EdgeInsets.all(36), decoration: BoxDecoration(color: colors.primaryContainer, borderRadius: BorderRadius.circular(40)), child: Icon(i == 1 ? Icons.forum_rounded : Icons.auto_awesome_rounded, size: 80, color: colors.onPrimaryContainer))),
          decoration: PageDecoration(titleTextStyle: Theme.of(context).textTheme.headlineMedium!.copyWith(fontWeight: FontWeight.bold), bodyTextStyle: Theme.of(context).textTheme.bodyLarge!, contentMargin: const EdgeInsets.symmetric(horizontal: 28), imagePadding: const EdgeInsets.all(20)))],
      ))),
    ])));
  }
}

