import 'package:another_telephony/telephony.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:quick_entry/models/category.dart';
import 'package:quick_entry/models/transaction.dart';
import 'package:quick_entry/services/sms_utils.dart';
import 'package:quick_entry/state/cards_notifier.dart';
import 'package:quick_entry/state/categories_notifier.dart';
import 'package:quick_entry/state/last_date_saved_notifier.dart';

final smsProvider = StateNotifierProvider<SmsNotifier, List<Transaction>>((ref) {
  final CategoriesNotifier categoriesNotifier = ref.watch(categoriesProvider.notifier);
  final CardsNotifier cardsNotifier = ref.watch(cardsProvider.notifier);
  final LastDateSavedNotifier lastDateSavedNotifier = ref.watch(lastDateSavedProvider.notifier);
  return SmsNotifier(categoriesNotifier, cardsNotifier, lastDateSavedNotifier);
});

class SmsNotifier extends StateNotifier<List<Transaction>> {
  final CategoriesNotifier _categoriesNotifier;
  final CardsNotifier _cardsNotifier;
  final LastDateSavedNotifier _lastDateSavedNotifier;

  late final Telephony telephony;

  SmsNotifier(this._categoriesNotifier, this._cardsNotifier, this._lastDateSavedNotifier) : super([]) {
    telephony = Telephony.instance;

    _loadSms();
  }

  void _loadSms() async {
    DateTime lastDateAsDateTime = DateTime.fromMillisecondsSinceEpoch(_lastDateSavedNotifier.state);
    String dateFilter = DateTime(lastDateAsDateTime.year, lastDateAsDateTime.month, lastDateAsDateTime.day)
    .millisecondsSinceEpoch
        .toString();

    final List<SmsMessage> messages = await telephony.getInboxSms(
      columns: [SmsColumn.ID, SmsColumn.BODY, SmsColumn.DATE_SENT],
      filter:
          SmsFilter.where(SmsColumn.DATE_SENT).greaterThan(dateFilter),
      sortOrder: [OrderBy(SmsColumn.DATE_SENT)],
    );

    List<Category> categories = _categoriesNotifier.state;
    List<String> cardAccounts = _cardsNotifier.state;

    List<Transaction> transactions = messages
        .where((sms) => isOutcome(sms.body ?? ''))
        .map((sms) => Transaction.fromSms(sms, categories, cardAccounts))
        .toList()
        .reversed
        .toList();
    state = transactions;
  }

  void updateTransaction(Transaction updatedTransaction) {
    final index = state.indexWhere(
        (tx) => tx.timestamp == updatedTransaction.timestamp);
    if (index != -1) {
      state[index] = updatedTransaction;
      state = List.from(state);
    }
  }
}
