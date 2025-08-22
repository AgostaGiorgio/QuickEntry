import 'package:another_telephony/telephony.dart';
import 'package:intl/intl.dart';
import 'package:quick_entry/models/category.dart';
import 'package:quick_entry/services/sms_utils.dart';

class Transaction {
  int id;
  int timestamp;
  String cardAccount;
  double amount;
  String description;
  String primaryCategory;
  String secondaryCategory;
  double reimbursed;
  bool exclude;

  Transaction({
    required this.id,
    required this.timestamp,
    required this.amount,
    required this.description,
    this.primaryCategory = "Unknown",
    this.secondaryCategory = "",
    this.cardAccount = "",
    this.reimbursed = 0.0,
    this.exclude = false,
  });

  Map<String, dynamic> toJson() {
    final dateString = DateFormat("MM/dd/yyyy, HH:mm")
        .format(DateTime.fromMillisecondsSinceEpoch(timestamp));
        
    return {
      'timestamp': dateString,
      'cardAccount': cardAccount,
      'amount': amount,
      'description': description,
      'primaryCategory': primaryCategory,
      'secondaryCategory': secondaryCategory,
      'reimbursed': reimbursed,
      'exclude': exclude,
    };
  }

  static Transaction fromSms(SmsMessage sms, List<Category> categories, List<String> cardAccounts) {
    String extractedCard = extractCardAccountFromText(sms.body ?? '');

    extractedCard = (cardAccounts.contains(extractedCard)) ? extractedCard : "Unknown";
    return Transaction(
        id: sms.id ?? 0,
        timestamp: sms.date ?? sms.dateSent ?? 0,
        amount: extractAmountFromText(sms.body ?? ''),
        cardAccount: extractedCard,
        description: sms.body ?? '');
  }
}
