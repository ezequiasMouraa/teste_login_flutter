import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/transaction.dart' as app;

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> addTransaction(app.MyTransaction transaction, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .add(transaction.toFirestore());
  }

  Future<void> updateTransaction(app.MyTransaction transaction, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(transaction.id)
        .update(transaction.toFirestore());
  }

  Future<void> deleteTransaction(String transactionId, String userId) async {
    await _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .doc(transactionId)
        .delete();
  }

  Stream<List<app.MyTransaction>> getTransactions(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('transactions')
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) => app.MyTransaction.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList());
  }
}
