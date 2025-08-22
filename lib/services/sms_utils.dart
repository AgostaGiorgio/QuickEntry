RegExp AMOUNT_REGEX = RegExp(r'\d+\.\d+');
RegExp OUTCOME_REGEX = RegExp(r'(Purchase|Payment) of');
RegExp CARD_ACCOUNT_REGEX = RegExp(r'ending\s+(\d{4})');

double extractAmountFromText(String text) {
  text = text.replaceAll(",", "");
  Match? match = AMOUNT_REGEX.firstMatch(text);

  double amount = 0;
  if (match != null) {
    amount = double.parse(match.group(0)!);
  }

  return amount;
}

String extractCardAccountFromText(String text) {
  Match? match = CARD_ACCOUNT_REGEX.firstMatch(text);
  return match != null ? match.group(1)! : "";
}

bool isOutcome(String smsContent) {
  return smsContent.contains(OUTCOME_REGEX);
}