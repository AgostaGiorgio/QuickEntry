import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_entry/state/theme_notifier.dart';
import 'package:quick_entry/ui/settings_screen/components/theme_option.dart';
import 'package:quick_entry/ui/style.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: DEFAULT_PADDING,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          children: [
            ListTile(
              title: const Text('Theme', style: CONFIG_SECTION_TITLE_STYLE),
              subtitle: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ThemeOption(
                      title: 'System',
                      value: ThemeMode.system,
                      groupValue: themeMode),
                  ThemeOption(
                      title: 'Light',
                      value: ThemeMode.light,
                      groupValue: themeMode),
                  ThemeOption(
                      title: 'Dark',
                      value: ThemeMode.dark,
                      groupValue: themeMode),
                ],
            ),
            ),
            const Divider(),
            ListTile(
              title: const Text("Categories", style: CONFIG_SECTION_TITLE_STYLE),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/settings/categories'),
            ),
            const Divider(),
            ListTile(
              title: const Text("Cards", style: CONFIG_SECTION_TITLE_STYLE),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => Navigator.pushNamed(context, '/settings/cards'),
            ),
            const Divider(),
          ],
        ),
      ),
    );
  }
}
