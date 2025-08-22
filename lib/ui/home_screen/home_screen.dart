import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_entry/state/sms_notifier.dart';
import 'package:quick_entry/state/transactions_saved_notifier.dart';
import 'package:quick_entry/ui/home_screen/components/transaction_card.dart';
import 'package:quick_entry/ui/style.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final messages = ref.watch(smsProvider);
    final savedIds = ref.watch(transactionSavedProvider);

    return Scaffold(
        appBar: AppBar(
          title: const Text('QuickEntry'),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                Navigator.pushNamed(context, '/settings');
              },
            ),
          ],
        ),
        body: Padding(
            padding: DEFAULT_PADDING,
            child:  ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context, index) {
            final tx = messages[index];
            final bool isSaved = savedIds.contains(tx.id);
            return TransactionCard(transaction: tx, isSaved: isSaved);
          },
        ),));
  }
}
