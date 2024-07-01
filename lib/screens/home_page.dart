import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../services/transaction_service.dart';
import '../models/transaction.dart';
import '../models/transaction_type.dart';
import 'investment_calculator_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TransactionService _transactionService = TransactionService();
  final User? user = FirebaseAuth.instance.currentUser;

  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  TransactionType _selectedType = TransactionType.credit;

  Future<void> _addTransaction(MyTransaction transaction) async {
    if (user != null) {
      await _transactionService.addTransaction(transaction, user!.uid);
      _clearTextFields();
    }
  }

  Future<void> _editTransaction(MyTransaction transaction) async {
    if (user != null) {
      await _transactionService.updateTransaction(transaction, user!.uid);
    }
  }

  Future<void> _deleteTransaction(MyTransaction transaction) async {
    if (user != null) {
      await _transactionService.deleteTransaction(transaction.id, user!.uid);
    }
  }

  void _clearTextFields() {
    _amountController.clear();
    _descriptionController.clear();
  }

  void _showAddTransactionSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<TransactionType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  items: TransactionType.values.map((TransactionType type) {
                    return DropdownMenuItem<TransactionType>(
                      value: type,
                      child: Text(type.toShortString()),
                    );
                  }).toList(),
                  onChanged: (TransactionType? newValue) {
                    setState(() {
                      _selectedType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 12.0),
                ElevatedButton(
                  onPressed: () {
                    final transaction = MyTransaction(
                      id: '',
                      amount: double.parse(_amountController.text),
                      description: _descriptionController.text,
                      date: DateTime.now(),
                      type: _selectedType,
                    );
                    _addTransaction(transaction);
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                  ),
                  child: const Text('Adicionar Transação'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _showEditTransactionDialog(BuildContext context, MyTransaction transaction) {
    _amountController.text = transaction.amount.toString();
    _descriptionController.text = transaction.description;
    _selectedType = transaction.type;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Editar Transação'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                TextField(
                  controller: _amountController,
                  decoration: const InputDecoration(
                    labelText: 'Valor',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 12.0),
                TextField(
                  controller: _descriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Descrição',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                ),
                const SizedBox(height: 12.0),
                DropdownButtonFormField<TransactionType>(
                  value: _selectedType,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(12)),
                    ),
                  ),
                  items: TransactionType.values.map((TransactionType type) {
                    return DropdownMenuItem<TransactionType>(
                      value: type,
                      child: Text(type.toShortString()),
                    );
                  }).toList(),
                  onChanged: (TransactionType? newValue) {
                    setState(() {
                      _selectedType = newValue!;
                    });
                  },
                ),
                const SizedBox(height: 12.0),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Excluir'),
              onPressed: () async {
                await _deleteTransaction(transaction);
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Salvar'),
              onPressed: () {
                final editedTransaction = MyTransaction(
                  id: transaction.id,
                  amount: double.parse(_amountController.text),
                  description: _descriptionController.text,
                  date: transaction.date,
                  type: _selectedType,
                );
                _editTransaction(editedTransaction);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  String formatDateTime(DateTime dateTime) {
    return '${DateFormat('dd/MM/yyyy').format(dateTime)} - ${DateFormat('HH\'h\'mm').format(dateTime)}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacementNamed(context, '/login');
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const SizedBox(height: 16.0),
                  Text(
                    'Usuário: ${user?.email ?? 'Usuário desconhecido'}',
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  const SizedBox(height: 16.0),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: AspectRatio(
                aspectRatio: 1.3,
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: StreamBuilder<List<MyTransaction>>(
                    stream: _transactionService.getTransactions(user!.uid),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(child: Text('No data available.'));
                      }
                      final transactions = snapshot.data!;
                      double totalCredit = 0;
                      double totalDebit = 0;

                      for (final transaction in transactions) {
                        switch (transaction.type) {
                          case TransactionType.credit:
                          case TransactionType.salary:
                          case TransactionType.extraIncome:
                          case TransactionType.income:
                            totalCredit += transaction.amount;
                            break;
                          case TransactionType.debit:
                            totalDebit += transaction.amount;
                            break;
                          default:
                            break;
                        }
                      }

                      final netBalance = totalCredit - totalDebit;

                      return Column(
                        children: [
                          ListTile(
                            title: Text(
                              'Saldo Líquido',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            trailing: Text(
                              'R\$ ${netBalance.toStringAsFixed(2)}',
                              style: TextStyle(
                                color: netBalance >= 0 ? Colors.green : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                              ),
                            ),
                          ),
                          Expanded(
                            child: PieChart(
                              PieChartData(
                                sections: [
                                  PieChartSectionData(
                                    value: totalCredit,
                                    color: Color(0xAA1b998b),
                                    title: 'R\$ ${totalCredit.toStringAsFixed(2)}',
                                    radius: 50,
                                  ),
                                  PieChartSectionData(
                                    value: totalDebit,
                                    color: Color(0xAAd7263d),
                                    title: 'R\$ ${totalDebit.toStringAsFixed(2)}',
                                    radius: 50,
                                  ),
                                ],
                                centerSpaceRadius: 40,
                                sectionsSpace: 0,
                                pieTouchData: PieTouchData(enabled: true),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
            ),
            Expanded(
              child: StreamBuilder<List<MyTransaction>>(
                stream: _transactionService.getTransactions(user!.uid),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No transactions found.'));
                  }
                  final transactions = snapshot.data!;
                  return ListView.builder(
                    itemCount: transactions.length,
                    itemBuilder: (context, index) {
                      final transaction = transactions[index];
                      final formattedValue = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$').format(transaction.amount);
                      final formattedDateTime = formatDateTime(transaction.date);

                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        child: ListTile(
                          onTap: () => _showEditTransactionDialog(context, transaction),
                          leading: Icon(
                            transaction.type == TransactionType.debit ? Icons.arrow_downward : Icons.arrow_upward,
                            color: transaction.type == TransactionType.debit ? Colors.red : Colors.green,
                          ),
                          title: Text(
                            transaction.description,
                            style: TextStyle(
                              color: transaction.type == TransactionType.debit ? Colors.red : Colors.green,
                            ),
                          ),
                          subtitle: Text(formattedDateTime),
                          trailing: Text(
                            formattedValue,
                            style: TextStyle(
                              color: transaction.type == TransactionType.debit ? Colors.red : Colors.green,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            onPressed: () => _showAddTransactionSheet(context),
            child: const Icon(Icons.add),
          ),
          const SizedBox(height: 16.0),
          FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => InvestmentCalculatorPage()),
              );
            },
            child: const Icon(Icons.calculate),
          ),
        ],
      ),
    );
  }
}
