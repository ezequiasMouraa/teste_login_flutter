// models/transaction_type.dart
enum TransactionType {
  credit,
  debit,
  salary,
  extraIncome, income,
}

extension TransactionTypeExtension on TransactionType {
  String toShortString() {
    return toString().split('.').last;
  }

  static TransactionType fromString(String value) {
    return TransactionType.values.firstWhere((e) => e.toShortString() == value);
  }
}
