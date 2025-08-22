// ignore_for_file: use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:quick_entry/models/transaction.dart';
import 'package:quick_entry/services/coda_service.dart';
import 'package:quick_entry/state/last_date_saved_notifier.dart';
import 'package:quick_entry/ui/home_screen/components/transaction_editor.dart';
import 'package:quick_entry/ui/style.dart';

class TransactionCard extends ConsumerWidget {
  final Transaction transaction;
  final bool isSaved;

  const TransactionCard({super.key, required this.transaction, required this.isSaved});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final date = DateFormat('dd MMM yyyy, HH:mm')
        .format(DateTime.fromMillisecondsSinceEpoch(transaction.timestamp));

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: () => _showTransactionDialog(context, transaction),
        child: Padding(
          padding: DEFAULT_CARD_PADDING,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(child: Text(transaction.description)),
                  Text(
                    "${transaction.amount.toStringAsFixed(2)} AED",
                    style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(date,
                  style: TextStyle(color: Colors.grey[600], fontSize: 13)),
              const SizedBox(height: 6),
              Row(
                children: [
                  Expanded(
                    child: Wrap(
                      spacing: 6,
                      children: [
                        Chip(
                          label: Text(transaction.cardAccount),
                          backgroundColor: Colors.orange.shade50,
                          labelStyle: const TextStyle(color: Colors.orange),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                        ),
                        Chip(
                          label: Text(transaction.primaryCategory),
                          backgroundColor: Colors.blue.shade50,
                          labelStyle: const TextStyle(color: Colors.blue),
                          padding: const EdgeInsets.symmetric(horizontal: 0),
                        ),
                        if (transaction.secondaryCategory.isNotEmpty)
                          Chip(
                            label: Text(transaction.secondaryCategory),
                            backgroundColor: Colors.purple.shade50,
                            labelStyle: const TextStyle(color: Colors.purple),
                            padding: const EdgeInsets.symmetric(horizontal: 0),
                          ),
                      ],
                    ),
                  ),
                  CircleAvatar(
                    backgroundColor: (isSaved) ? Colors.grey :Theme.of(context).colorScheme.primary,
                    child: IconButton(
                      icon: const Icon(Icons.send, color: Colors.white),
                      onPressed: () => _sendTransaction(context, ref),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showTransactionDialog(BuildContext context, Transaction tx) {
    if (isSaved) {
      return;
    }

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return TransactionEditor(transaction: tx);
      },
    );
  }

  Future<void> _sendTransaction(BuildContext context, WidgetRef ref) async {
    if (isSaved) {
      return;
    }

    try {
      final response = await CodaService.saveTransaction(transaction);

      if (response.statusCode == 200 || response.statusCode == 201 || response.statusCode == 202) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text("✅ Transaction sent successfully"),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        ref.read(lastDateSavedProvider.notifier).updateLastDate(transaction);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text("⚠️ Failed: ${response.statusCode}"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("❌ Error: $e"),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }
}
