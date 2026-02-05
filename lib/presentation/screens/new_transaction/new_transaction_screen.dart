import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // Necessário para TextInputFormatter
import 'package:oriz_app/core/extensions/transaction_category_extension.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/core/utils/currency_input.dart';
import 'package:oriz_app/domain/entities/transaction.dart';
import 'package:oriz_app/domain/enum/transaction_category.dart';
import 'package:oriz_app/domain/enum/transaction_type.dart';
import 'package:oriz_app/presentation/controllers/transaction_controller.dart';

class AddTransactionScreen extends StatefulWidget {
  final TransactionController controller;

  const AddTransactionScreen({super.key, required this.controller});

  @override
  State<AddTransactionScreen> createState() => _AddTransactionScreenState();
}

class _AddTransactionScreenState extends State<AddTransactionScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();

  TransactionType _selectedType = TransactionType.expense;
  TransactionCategory _selectedCategory = TransactionCategory.mercado;

  @override
  void dispose() {
    _descriptionController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  double _parseCurrencyToDouble(String text) {
    String onlyDigits = text.replaceAll(RegExp(r'[^\d]'), '');
    return (double.tryParse(onlyDigits) ?? 0.0) / 100;
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final double amount = _parseCurrencyToDouble(_amountController.text);

      if (amount <= 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('O valor deve ser maior que zero')),
        );
        return;
      }

      final newTransaction = Transaction(
        id: Random().nextDouble().toString(),
        description: _descriptionController.text,
        amount: amount,
        date: DateTime.now(),
        type: _selectedType,
        category: _selectedCategory,
      );

      widget.controller.addTransaction(newTransaction);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(title: const Text('Nova Transação')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SegmentedButton<TransactionType>(
                segments: const [
                  ButtonSegment(
                    value: TransactionType.expense,
                    label: Text('Saída'),
                    icon: Icon(Icons.arrow_downward),
                  ),
                  ButtonSegment(
                    value: TransactionType.income,
                    label: Text('Entrada'),
                    icon: Icon(Icons.arrow_upward),
                  ),
                ],
                selected: {_selectedType},
                onSelectionChanged: (newSelection) {
                  setState(() => _selectedType = newSelection.first);
                },
              ),
              const SizedBox(height: 24),

              TextFormField(
                controller: _descriptionController,
                textCapitalization: TextCapitalization.sentences,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: 'Descrição',
                  hintText: 'Ex: Compra no mercado',
                  border: OutlineInputBorder(),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Informe a descrição'
                    : null,
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _amountController,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
                decoration: const InputDecoration(
                  labelText: 'Valor',
                  hintText: 'R\$ 0,00',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) return 'Informe o valor';
                  final double amount = _parseCurrencyToDouble(value);
                  if (amount <= 0) return 'Valor inválido';
                  return null;
                },
              ),

              const SizedBox(height: 16),

              DropdownButtonFormField<TransactionCategory>(
                initialValue: _selectedCategory,
                decoration: const InputDecoration(
                  labelText: 'Categoria',
                  border: OutlineInputBorder(),
                ),
                items: TransactionCategory.values.map((cat) {
                  return DropdownMenuItem(
                    value: cat,
                    child: Row(
                      children: [
                        Icon(cat.icon, size: 22, color: cat.color),
                        const SizedBox(width: 10),
                        Text(
                          cat.name,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) =>
                    setState(() => _selectedCategory = value!),
              ),
              const SizedBox(height: 32),

              ElevatedButton(
                onPressed: _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  'Salvar Transação',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
