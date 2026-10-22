import 'package:flutter/material.dart';
import 'package:country_picker/country_picker.dart';
import 'package:phone_numbers_parser/phone_numbers_parser.dart';
import '../main.dart';
import '../config/lang.dart';
import '../utils/app_utils.dart';
import 'settings.dart';
import 'tools.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final phone = TextEditingController(), message = TextEditingController();
  final focus = FocusNode();
  late Country country =
      Country.tryParse(prefs.getString('country') ?? 'IN') ??
      Country.parse('IN');
  late List<String> samples = prefs.getStringList('samples') ?? [];
  String? error;
  bool sending = false;
  @override
  void dispose() {
    phone.dispose();
    message.dispose();
    focus.dispose();
    super.dispose();
  }

  Future<void> choose(Country next) async {
    setState(() => country = next);
    if (!await persist(prefs.setString('country', next.countryCode)) &&
        mounted) {
      notice(context, 'errSave');
    }
  }

  Future<void> editSamples([String? remove]) async {
    final input = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(t(remove == null ? 'addSample' : 'delete')),
        content: remove == null
            ? TextField(
                controller: input,
                autofocus: true,
                maxLength: 500,
                maxLines: 3,
              )
            : Text(remove),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(t('cancel')),
          ),
          TextButton(
            onPressed: () {
              if (remove != null || input.text.trim().isNotEmpty) {
                Navigator.pop(context, remove ?? input.text.trim());
              }
            },
            child: Text(t(remove == null ? 'save' : 'delete')),
          ),
        ],
      ),
    );
    // ponytail: dialog owns a short-lived controller; dispose after its route animation.
    Future.delayed(const Duration(seconds: 1), input.dispose);
    if (result == null || !mounted) return;
    final next = [...samples];
    if (remove != null) {
      next.remove(remove);
    } else if (!next.contains(result)) {
      next.add(result);
    }
    if (await persist(prefs.setStringList('samples', next))) {
      if (mounted) setState(() => samples = next);
    } else if (mounted) {
      notice(context, 'errSave');
    }
  }

  Future<void> send() async {
    if (sending) return;
    final digits = parse(phone.text, country.countryCode);
    if (digits == null) {
      setState(() => error = phoneError(phone.text) ?? 'errInvalid');
      focus.requestFocus();
      return;
    }
    setState(() {
      sending = true;
      error = null;
    });
    final detected = PhoneNumber.parse('+$digits').isoCode.name;
    if (normalize(phone.text).startsWith('+') ||
        normalize(phone.text).startsWith('00')) {
      await choose(Country.parse(detected));
    }
    final opened = await openChat(digits, message.text);
    if (opened) {
      final rows = prefs.getStringList('recent') ?? [];
      rows.removeWhere((row) => row.split('|').elementAtOrNull(1) == digits);
      rows.insert(
        0,
        '$detected|$digits|${DateTime.now().millisecondsSinceEpoch}',
      );
      final saved = await persist(
        prefs.setStringList('recent', rows.take(50).toList()),
      );
      recentTick.value++;
      if (!saved && mounted) notice(context, 'errSave');
    } else if (mounted) {
      notice(context, 'errLaunch');
    }
    if (mounted) setState(() => sending = false);
  }

  @override
  Widget build(BuildContext context) {
    Localizations.localeOf(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('WhatsApp Direct Pro'),
      ),
      body: SafeArea(
        top: false,
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 600),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final compact = constraints.maxHeight < 560;
                final tight = constraints.maxHeight < 500;
                final gap = tight ? 8.0 : (compact ? 12.0 : 16.0);
                final messageLines = tight ? 2 : (compact ? 3 : 4);
                // Scroll only when the keyboard or larger text needs more room.
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: gap),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        t('country'),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 8),
                      Card(
                        margin: EdgeInsets.zero,
                        elevation: 0,
                        child: ListTile(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          leading: Text(
                            country.flagEmoji,
                            style: const TextStyle(fontSize: 28),
                          ),
                          title: Text(
                            country.getTranslatedName(context) ?? country.name,
                          ),
                          subtitle: Text(
                            '+${country.phoneCode}',
                            textDirection: TextDirection.ltr,
                          ),
                          trailing: const Icon(Icons.keyboard_arrow_down),
                          onTap: () => showCountryPicker(
                            context: context,
                            showPhoneCode: true,
                            onSelect: choose,
                          ),
                        ),
                      ),
                      SizedBox(height: gap),
                      TextField(
                        controller: phone,
                        focusNode: focus,
                        textDirection: TextDirection.ltr,
                        keyboardType: TextInputType.phone,
                        autofillHints: const [AutofillHints.telephoneNumber],
                        textInputAction: TextInputAction.next,
                        onChanged: (_) {
                          if (error != null) setState(() => error = null);
                        },
                        decoration: InputDecoration(
                          labelText: t('phone'),
                          hintText: t('phoneHint'),
                          errorText: error == null ? null : t(error!),
                          prefixIcon: const Icon(Icons.phone_outlined),
                        ),
                      ),
                      SizedBox(height: gap),
                      TextField(
                        controller: message,
                        minLines: messageLines,
                        maxLines: messageLines,
                        maxLength: 4000,
                        decoration: InputDecoration(
                          labelText: t('message'),
                          alignLabelWithHint: true,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        t('samples'),
                        style: Theme.of(context).textTheme.labelLarge,
                      ),
                      const SizedBox(height: 4),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          spacing: 8,
                          children: [
                            ActionChip(
                              avatar: const Icon(Icons.add, size: 18),
                              label: Text(t('custom')),
                              onPressed: editSamples,
                            ),
                            for (var i = 1; i <= 5; i++)
                              ActionChip(
                                label: Text(t('s$i')),
                                onPressed: () => message.text = t('s$i'),
                              ),
                            for (final sample in samples)
                              Tooltip(
                                message: t('holdDelete'),
                                child: GestureDetector(
                                  onLongPress: () => editSamples(sample),
                                  child: ActionChip(
                                    label: Text(
                                      sample,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onPressed: () => message.text = sample,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SizedBox(height: gap),
                      FilledButton.icon(
                        onPressed: sending ? null : send,
                        icon: sending
                            ? const SizedBox.square(
                                dimension: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                ),
                              )
                            : const Icon(Icons.send_rounded),
                        label: Text(t('send')),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_outline, size: 14),
                          const SizedBox(width: 6),
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
              },
            ),
          ),
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 64,
        selectedIndex: 0,
        onDestinationSelected: (index) {
          if (index == 1) {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const ToolScreen()),
            );
          } else if (index == 2) {
            FocusManager.instance.primaryFocus?.unfocus();
            Navigator.of(context).push(
              MaterialPageRoute<void>(builder: (_) => const SettingsPage()),
            );
          }
        },
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
      ),
    );
  }
}
