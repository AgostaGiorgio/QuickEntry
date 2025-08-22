import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_entry/state/categories_notifier.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categories = ref.watch(categoriesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView(
        children: categories.map((entry) {
          return ListTile(
            title: Text(entry.name),
            subtitle: (entry.subcategories.isNotEmpty) ? Text(entry.subcategories.join(', ')) : null,
          );
        }).toList(),
      ),
    );
  }
}
