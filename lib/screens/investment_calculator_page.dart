import 'package:flutter/material.dart';

class InvestmentCalculatorPage extends StatefulWidget {
  @override
  _InvestmentCalculatorPageState createState() => _InvestmentCalculatorPageState();
}

class _InvestmentCalculatorPageState extends State<InvestmentCalculatorPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _initialAmountController = TextEditingController();
  final TextEditingController _monthlyContributionController = TextEditingController();
  final TextEditingController _annualInterestController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();

  double _futureValue = 0.0;

  void _calculateFutureValue() {
    if (_formKey.currentState!.validate()) {
      final double initialAmount = double.parse(_initialAmountController.text);
      final double monthlyContribution = double.parse(_monthlyContributionController.text);
      final double annualInterestRate = double.parse(_annualInterestController.text) / 100;
      final int years = int.parse(_yearsController.text);

      final double monthlyInterestRate = annualInterestRate / 12;
      final int totalMonths = years * 12;

      double futureValue = initialAmount;
      for (int i = 0; i < totalMonths; i++) {
        futureValue = (futureValue + monthlyContribution) * (1 + monthlyInterestRate);
      }

      setState(() {
        _futureValue = futureValue;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Investment Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _initialAmountController,
                decoration: const InputDecoration(
                  labelText: 'Initial Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the initial amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _monthlyContributionController,
                decoration: const InputDecoration(
                  labelText: 'Monthly Contribution',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the monthly contribution';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _annualInterestController,
                decoration: const InputDecoration(
                  labelText: 'Annual Interest Rate (%)',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the annual interest rate';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              TextFormField(
                controller: _yearsController,
                decoration: const InputDecoration(
                  labelText: 'Number of Years',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12)),
                  ),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter the number of years';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 24.0),
              ElevatedButton(
                onPressed: _calculateFutureValue,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 24.0),
              Text(
                'Future Value: R\$ ${_futureValue.toStringAsFixed(2)}',
                style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
