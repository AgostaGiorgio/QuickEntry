// ignore_for_file: prefer_collection_literals

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_entry/models/category.dart';
import 'package:quick_entry/models/transaction.dart';
import 'package:quick_entry/state/cards_notifier.dart';
import 'package:quick_entry/state/categories_notifier.dart';
import 'package:quick_entry/state/sms_notifier.dart';
import 'package:quick_entry/ui/style.dart';

class TransactionEditor extends ConsumerStatefulWidget {
  final Transaction transaction;

  const TransactionEditor({super.key, required this.transaction});

  @override
  ConsumerState<TransactionEditor> createState() => _TransactionEditorState();
}

class _TransactionEditorState extends ConsumerState<TransactionEditor> {
  late TextEditingController _descriptionController;
  late TextEditingController _amountController;
  late TextEditingController _reimbursedController;
  late String _selectedPrimaryCategory;
  late String _selectedSecondaryCategory;
  late String _selectedCardAccount;
  late bool _isExcluded;

  @override
  void initState() {
    super.initState();
    _descriptionController =
        TextEditingController(text: widget.transaction.description);
    _amountController =
        TextEditingController(text: widget.transaction.amount.toString());
    _reimbursedController =
        TextEditingController(text: widget.transaction.reimbursed.toString());
    _selectedPrimaryCategory = widget.transaction.primaryCategory;
    _selectedSecondaryCategory = widget.transaction.secondaryCategory;
    _selectedCardAccount = widget.transaction.cardAccount;
    _isExcluded = widget.transaction.exclude;
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    _reimbursedController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<String> cards = ref.watch(cardsProvider);
    List<Category> categories = ref.watch(categoriesProvider);

    return AlertDialog(
      title: const Text("Edit Transaction"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _descriptionController,
              decoration: const InputDecoration(labelText: "Description"),
            ),
            TextField(
              controller: _amountController,
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _reimbursedController,
              decoration: const InputDecoration(labelText: "Reimbursed Amount"),
              keyboardType: TextInputType.number,
            ),
            DEFAULT_WIDGET_VERTICAL_SPACE,
            DropdownButtonFormField<String>(
              value: _selectedCardAccount,
              items: [widget.transaction.cardAccount, ...cards].toSet()
                  .map((card) => DropdownMenuItem(
                        value: card,
                        child: Text(card),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCardAccount = value ?? "";
                });
              },
              decoration: const InputDecoration(labelText: "Card Account"),
            ),
            DropdownButtonFormField<String>(
              value: _selectedPrimaryCategory,
              items: categories
                  .where((cat) => cat.isPrimary)
                  .map((cat) => cat.name)
                  .map((cat) => DropdownMenuItem(
                        value: cat,
                        child: Text(cat),
                      ))
                  .toList(),
              onChanged: (value) {
                setState(() {
                  _selectedPrimaryCategory = value ?? "";
                });
              },
              decoration: const InputDecoration(labelText: "Primary Category"),
            ),
            DropdownButtonFormField<String>(
              value: _selectedSecondaryCategory,
              items: [
                const DropdownMenuItem(
                  value: "",
                  child: Text("None"),
                ),
                ...categories
                    .where(
                        (cat) => cat.name == _selectedPrimaryCategory)
                    .first
                    .subcategories
                    .map((cat) => DropdownMenuItem(
                          value: cat,
                          child: Text(cat),
                        ))
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSecondaryCategory = value ?? "";
                });
              },
              decoration:
                  const InputDecoration(labelText: "Secondary Category"),
            ),
            const SizedBox(height: 8),
            SwitchListTile(
              value: _isExcluded,
              onChanged: (val) {
                setState(() {
                  _isExcluded = val;
                });
              },
              title: const Text("Exclude from stats"),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () {
            widget.transaction.description = _descriptionController.text;
            widget.transaction.amount =
                double.tryParse(_amountController.text) ?? 0;
            widget.transaction.reimbursed =
                double.tryParse(_reimbursedController.text) ?? 0;
            widget.transaction.primaryCategory = _selectedPrimaryCategory;
            widget.transaction.secondaryCategory = _selectedSecondaryCategory;
            widget.transaction.cardAccount = _selectedCardAccount;
            widget.transaction.exclude = _isExcluded;

            ref
                .read(smsProvider.notifier)
                .updateTransaction(widget.transaction);
            Navigator.pop(context);
          },
          child: const Text("Save"),
        ),
      ],
    );
  }
}
