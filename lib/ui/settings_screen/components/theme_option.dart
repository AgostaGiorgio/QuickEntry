import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_entry/state/theme_notifier.dart';

class ThemeOption extends ConsumerWidget {
  const ThemeOption({
    super.key,
    required this.title,
    required this.value,
    required this.groupValue,
  });

  final String title;
  final ThemeMode value;
  final ThemeMode groupValue;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Radio<ThemeMode>(
          value: value,
          groupValue: groupValue,
          onChanged: (mode) {
            if (mode != null && mode != groupValue) {
              ref.read(themeProvider.notifier).setTheme(mode);
            }
          },
        ),
        Text(title),
      ],
    );
  }
}