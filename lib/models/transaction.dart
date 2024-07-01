import 'transaction_type.dart';

class MyTransaction {
  final String id;
  final double amount;
  final String description;
  final DateTime date;
  final TransactionType type;

  MyTransaction({
    required this.id,
    required this.amount,
    required this.description,
    required this.date,
    required this.type,
  });

  factory MyTransaction.fromFirestore(Map<String, dynamic> data, String id) {
    return MyTransaction(
      id: id,
      amount: data['amount'] ?? 0.0,
      description: data['description'] ?? '',
      date: DateTime.parse(data['date']),
      type: TransactionTypeExtension.fromString(data['type'] ?? 'credit'),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'amount': amount,
      'description': description,
      'date': date.toIso8601String(),
      'type': type.toShortString(),
    };
  }
}
