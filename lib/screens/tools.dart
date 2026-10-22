import 'package:flutter/material.dart';
import '../main.dart';
import '../config/lang.dart';
import 'settings.dart';

class ToolScreen extends StatelessWidget {
  const ToolScreen({super.key});

  void navigate(BuildContext context, int index) {
    if (index == 0) {
      Navigator.of(context).pop();
    } else if (index == 2) {
      Navigator.of(
        context,
      ).push(MaterialPageRoute<void>(builder: (_) => const SettingsPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'WhatsApp',
          style: TextStyle(
            color: Color(0xFF25D366),
            fontSize: 25,
            fontWeight: FontWeight.w700,
          ),
        ),
        actions: [
          IconButton(
            tooltip: t('language'),
            onPressed: () => chooseLanguage(context),
            icon: const Icon(Icons.language_outlined),
          ),
          IconButton(
            tooltip: t(theme.value == ThemeMode.dark ? 'light' : 'dark'),
            onPressed: () =>
                chooseTheme(context, theme.value != ThemeMode.dark),
            icon: Icon(
              theme.value == ThemeMode.dark
                  ? Icons.light_mode_outlined
                  : Icons.dark_mode_outlined,
            ),
          ),
        ],
      ),
      body: SafeArea(
        top: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          children: [
            Card(
              margin: EdgeInsets.zero,
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Free Plan',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const Spacer(),
                        Text(
                          'UPGRADE NOW',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 1,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    const Text('Upgrade to Business\nMode to unlock'),
                    const SizedBox(height: 12),
                    Text(
                      'Usage summary:',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '• Bulk Messaging: 0 / 5 (per month)\n'
                      '• Active Reminders: 0 / 3 (per month)\n'
                      '• Templates: 2 / 5\n'
                      '• Personalized Templates: 1 / 3\n'
                      '• Personalized Sends: 0 / 5 (per month)',
                      style: TextStyle(height: 1.65),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 28),
            Text(
              'Workspace',
              style: Theme.of(
                context,
              ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            Text(
              'Manage your messaging and follow-ups.',
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            const SizedBox(height: 12),
            _ToolCard(
              icon: Icons.send_outlined,
              title: 'Bulk Messaging',
              description: 'Send messages to multiple contacts quickly.',
              pro: true,
            ),
            _ToolCard(
              icon: Icons.calendar_month_outlined,
              title: 'Schedule Reminder',
              description: 'Set follow-ups so you never miss a message.',
              pro: true,
            ),
            _ToolCard(
              icon: Icons.access_time,
              title: 'Reminder Manager',
              description: 'View, filter, and manage all reminders.',
            ),
            _ToolCard(
              icon: Icons.edit_outlined,
              title: 'Template Manager',
              description: 'Create and organize reusable message templates.',
              pro: true,
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 64,
        selectedIndex: 1,
        onDestinationSelected: (index) => navigate(context, index),
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

class _ToolCard extends StatelessWidget {
  const _ToolCard({
    required this.icon,
    required this.title,
    required this.description,
    this.pro = false,
  });

  final IconData icon;
  final String title;
  final String description;
  final bool pro;

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Icon(icon, color: colors.outline),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            if (pro)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                decoration: BoxDecoration(
                  color: colors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'PRO',
                  style: TextStyle(
                    color: colors.onPrimary,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
        subtitle: Text(description),
        trailing: Icon(Icons.chevron_right, color: colors.outline),
        onTap: () {},
      ),
    );
  }
}
