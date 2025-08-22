import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_entry/state/theme_notifier.dart';
import 'package:quick_entry/ui/cards_screen/cards_screen.dart';
import 'package:quick_entry/ui/categories_screen/categories_screen.dart';
import 'package:quick_entry/ui/home_screen/home_screen.dart';
import 'package:quick_entry/ui/settings_screen/settings_screen.dart';

class QuickEntryApp extends ConsumerWidget {
  const QuickEntryApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeProvider);

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'QuickEntry',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: themeMode,
      initialRoute: "/",
      routes: {
        '/': (context) => const HomeScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/settings/categories': (context) => const CategoriesScreen(),
        '/settings/cards': (context) => const CardsScreen(),
      },
    );
  }
}
