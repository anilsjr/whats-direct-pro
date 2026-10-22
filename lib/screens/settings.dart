import 'package:flutter/material.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:url_launcher/url_launcher.dart';
import '../main.dart';
import '../config/lang.dart';

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

  Future<void> language() async {
    await chooseLanguage(context);
    if (mounted) setState(() {});
  }

  Future<void> more() async {
    try {
      if (await launchUrl(
        Uri.parse(
          'https://play.google.com/store/apps/developer?id=KRISHH+APPS+SOLUTIONS',
        ),
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {
      // Report launcher failures through the same localized message.
    }
    if (mounted) notice(context, 'errLaunch');
  }

  Future<void> rateUs() async {
    try {
      final review = InAppReview.instance;
      if (await review.isAvailable()) {
        await review.requestReview();
        return;
      }
    } catch (_) {
      // Fall back to the store listing when the native review flow fails.
    }
    try {
      if (await launchUrl(
        Uri.parse(
          'https://play.google.com/store/apps/details?id=com.messagedirect.whatsappdirectmessageapp',
        ),
        mode: LaunchMode.externalApplication,
      )) {
        return;
      }
    } catch (_) {
      // Report launcher failures through the same localized message.
    }
    if (mounted) notice(context, 'errLaunch');
  }

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(leading: const BackButton(), title: Text(t('settings'))),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: Column(
                    children: [
                      SwitchListTile(
                        secondary: const Icon(Icons.dark_mode_outlined),
                        title: Text(t('dark')),
                        value: theme.value == ThemeMode.dark,
                        onChanged: (value) => chooseTheme(context, value),
                      ),
                      const Divider(height: 1),
                      ListTile(
                        leading: const Icon(Icons.language),
                        title: Text(t('language')),
                        subtitle: Text(
                          prefs.getBool('systemLanguage') == true
                              ? t('systemDefault')
                              : names[lang.value.languageCode]!,
                        ),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: language,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: ListTile(
                    leading: const Icon(Icons.apps_rounded),
                    title: Text(t('moreApps')),
                    trailing: const Icon(Icons.open_in_new, size: 20),
                    onTap: more,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  margin: EdgeInsets.zero,
                  elevation: 0,
                  child: ListTile(
                    leading: const Icon(Icons.star_outline_rounded),
                    title: Text(t('rateUs')),
                    trailing: const Icon(Icons.open_in_new, size: 20),
                    onTap: rateUs,
                  ),
                ),
                const SizedBox(height: 16),
                ValueListenableBuilder(
                  valueListenable: reminders,
                  builder: (_, enabled, child) => Card(
                    margin: EdgeInsets.zero,
                    elevation: 0,
                    child: SwitchListTile(
                      secondary: const Icon(Icons.notifications_none_rounded),
                      title: Text(t('reminders')),
                      subtitle: Text(t('reminderTimes')),
                      value: enabled,
                      onChanged: changingReminders ? null : changeReminders,
                    ),
                  ),
                ),
                const SizedBox(height: 36),
                const Icon(Icons.chat_rounded, size: 32),
                const SizedBox(height: 12),
                const Center(child: Text('WhatsApp Direct Pro')),
                const SizedBox(height: 6),
                Center(
                  child: Text(
                    '${t('version')} 1.0.0',
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key, required this.onDone});
  final VoidCallback onDone;
  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final pages = PageController();
  int page = 0;
  bool finishing = false;

  @override
  void dispose() {
    pages.dispose();
    super.dispose();
  }

  Future<void> finish() async {
    if (finishing) return;
    setState(() => finishing = true);
    final allow = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t('reminders')),
        content: Text(t('notifyExplain')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(t('later')),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(t('allow')),
          ),
        ],
      ),
    );
    if (!mounted) return;
    if (allow == null) {
      setState(() => finishing = false);
      return;
    }
    if (allow && !await updateReminders(true, request: true) && mounted) {
      notice(context, 'errNotify');
    }
    if (!await persist(prefs.setBool('onboarded', true))) {
      if (mounted) {
        notice(context, 'errSave');
        setState(() => finishing = false);
      }
      return;
    }
    if (mounted) widget.onDone();
  }

  void move(int index) {
    pages.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  // Preview messages are decorative and never enter chat history.
  Widget preview(int index, double width) {
    final colors = Theme.of(context).colorScheme;
    if (index == 0) {
      return SizedBox(
        width: width,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: colors.primaryContainer,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.forum_rounded,
                size: 48,
                color: colors.onPrimaryContainer,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.lock_outline, size: 16, color: colors.primary),
                const SizedBox(width: 8),
                Flexible(
                  child: Text(
                    t('privacy'),
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
    return SizedBox(
      width: width,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          for (var i = 1; i <= 3; i++)
            Align(
              alignment: i == 2
                  ? AlignmentDirectional.centerEnd
                  : AlignmentDirectional.centerStart,
              child: Container(
                constraints: BoxConstraints(maxWidth: width * .85),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: i == 2
                      ? colors.primaryContainer
                      : colors.surfaceContainerHighest,
                  borderRadius: BorderRadiusDirectional.only(
                    topStart: const Radius.circular(18),
                    topEnd: const Radius.circular(18),
                    bottomStart: Radius.circular(i == 2 ? 18 : 4),
                    bottomEnd: Radius.circular(i == 2 ? 4 : 18),
                  ),
                ),
                child: Text(
                  t('s$i'),
                  style: TextStyle(
                    color: i == 2
                        ? colors.onPrimaryContainer
                        : colors.onSurface,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget introduction(int index) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxHeight < 440;
        final width = (constraints.maxWidth - 48).clamp(0.0, 360.0);
        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    height: compact ? 112 : 180,
                    child: ExcludeSemantics(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        child: preview(index, width),
                      ),
                    ),
                  ),
                  SizedBox(height: compact ? 16 : 24),
                  Text(
                    t('introTitle${index + 1}'),
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(t('introBody${index + 1}'), textAlign: TextAlign.center),
                  SizedBox(height: compact ? 12 : 20),
                  for (final key
                      in (index == 0
                          ? ['introNumber', 'introPrivacy']
                          : ['introSamples', 'introRecent']))
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Icon(
                            Icons.check_circle_outline,
                            size: 20,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: 10),
                          Expanded(child: Text(t(key))),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(20, 12, 20, 4),
                  child: Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: AlignmentDirectional.centerStart,
                          child: OutlinedButton.icon(
                            onPressed: finishing
                                ? null
                                : () => chooseLanguage(context),
                            icon: const Icon(Icons.language, size: 20),
                            label: Text(names[lang.value.languageCode]!),
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: t(
                          theme.value == ThemeMode.dark ? 'light' : 'dark',
                        ),
                        onPressed: finishing
                            ? null
                            : () => chooseTheme(
                                context,
                                theme.value != ThemeMode.dark,
                              ),
                        icon: Icon(
                          theme.value == ThemeMode.dark
                              ? Icons.light_mode_outlined
                              : Icons.dark_mode_outlined,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: AbsorbPointer(
                    absorbing: finishing,
                    child: PageView(
                      controller: pages,
                      onPageChanged: (index) => setState(() => page = index),
                      children: [introduction(0), introduction(1)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                  child: Column(
                    children: [
                      Semantics(
                        label: '${page + 1}/2',
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            for (var i = 0; i < 2; i++)
                              Container(
                                width: page == i ? 20 : 6,
                                height: 6,
                                margin: const EdgeInsets.symmetric(
                                  horizontal: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: page == i
                                      ? Theme.of(context).colorScheme.primary
                                      : Theme.of(
                                          context,
                                        ).colorScheme.outlineVariant,
                                  borderRadius: BorderRadius.circular(3),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          if (page == 1)
                            TextButton(
                              onPressed: finishing ? null : () => move(0),
                              child: Text(t('back')),
                            ),
                          const Spacer(),
                          Flexible(
                            flex: 2,
                            child: FilledButton(
                              style: FilledButton.styleFrom(
                                minimumSize: const Size(144, 52),
                              ),
                              onPressed: finishing
                                  ? null
                                  : () => page == 0 ? move(1) : finish(),
                              child: Text(
                                t(page == 0 ? 'next' : 'getStarted'),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
