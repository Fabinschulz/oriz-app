import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final isIOS = Platform.isIOS;

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
      final amount = _parseCurrencyToDouble(_amountController.text);

      final newTransaction = Transaction(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
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
  Widget build(BuildContext context) =>
      isIOS ? _buildCupertinoIOS() : _buildMaterialAndroid();

  Widget _buildMaterialAndroid() {
    return Scaffold(
      appBar: AppBar(title: const Text('Nova Transação'), centerTitle: true),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              _buildTypeSelector(),
              const SizedBox(height: 24),
              _buildTextFieldAndroid(
                controller: _descriptionController,
                label: 'Descrição',
                hint: 'Ex: Compra no mercado',
              ),
              const SizedBox(height: 16),
              _buildTextFieldAndroid(
                controller: _amountController,
                label: 'Valor',
                hint: 'R\$ 0,00',
                keyboardType: TextInputType.number,
                formatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  CurrencyInputFormatter(),
                ],
              ),
              const SizedBox(height: 16),
              _buildCategoryDropdownAndroid(),
              const SizedBox(height: 40),
              _buildSubmitButton(isIOS: false),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCupertinoIOS() {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.systemGroupedBackground,
      navigationBar: const CupertinoNavigationBar(
        middle: Text('Nova Transação'),
      ),
      child: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildTypeSelector(),
              ),
              CupertinoFormSection.insetGrouped(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 20,
                ),
                header: const Text('DETALHES'),
                children: [
                  CupertinoTextFormFieldRow(
                    controller: _descriptionController,
                    placeholder: 'Descrição',
                    prefix: const Icon(
                      CupertinoIcons.pencil,
                      size: 20,
                      color: CupertinoColors.systemGrey,
                    ),
                    validator: (v) => v!.isEmpty ? 'Campo obrigatório' : null,
                  ),
                  CupertinoTextFormFieldRow(
                    controller: _amountController,
                    placeholder: 'Valor',
                    prefix: const Icon(
                      CupertinoIcons.money_dollar,
                      size: 20,
                      color: CupertinoColors.systemGrey,
                    ),
                    keyboardType: TextInputType.number,
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      CurrencyInputFormatter(),
                    ],
                    validator: (v) => _parseCurrencyToDouble(v ?? '') <= 0
                        ? 'Campo obrigatório'
                        : null,
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildCupertinoCategoryPickerIOS(),
              ),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: _buildSubmitButton(isIOS: true),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeSelector() {
    return SizedBox(
      width: double.infinity,
      child: isIOS
          ? CupertinoSlidingSegmentedControl<TransactionType>(
              groupValue: _selectedType,
              children: const {
                TransactionType.expense: Text(
                  'Saída',
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
                TransactionType.income: Text(
                  'Entrada',
                  style: TextStyle(
                    fontSize: 14,
                    color: CupertinoColors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
              },
              onValueChanged: (v) => setState(() => _selectedType = v!),
            )
          : SegmentedButton<TransactionType>(
              segments: const [
                ButtonSegment(
                  value: TransactionType.expense,
                  label: Text(
                    'Saída',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  icon: Icon(Icons.remove_circle_outline),
                ),
                ButtonSegment(
                  value: TransactionType.income,
                  label: Text(
                    'Entrada',
                    style: TextStyle(
                      fontSize: 14,
                      color: CupertinoColors.black,
                      decoration: TextDecoration.none,
                    ),
                  ),
                  icon: Icon(Icons.add_circle_outline),
                ),
              ],
              selected: {_selectedType},
              onSelectionChanged: (v) =>
                  setState(() => _selectedType = v.first),
            ),
    );
  }

  Widget _buildTextFieldAndroid({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType? keyboardType,
    List<TextInputFormatter>? formatters,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      inputFormatters: formatters,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      validator: (v) => v == null || v.isEmpty ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildCategoryDropdownAndroid() {
    return DropdownButtonFormField<TransactionCategory>(
      initialValue: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Categoria',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      items: TransactionCategory.values
          .map(
            (cat) => DropdownMenuItem(
              value: cat,
              child: Row(
                children: [
                  Icon(cat.icon, color: cat.color, size: 20),
                  const SizedBox(width: 10),
                  Text(cat.name),
                ],
              ),
            ),
          )
          .toList(),
      onChanged: (v) => setState(() => _selectedCategory = v!),
    );
  }

  Widget _buildCupertinoCategoryPickerIOS() {
    return Container(
      decoration: BoxDecoration(
        color: CupertinoColors.systemBackground,
        borderRadius: BorderRadius.circular(10),
      ),
      child: CupertinoButton(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        onPressed: () => _showCupertinoPickerIOS(),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Categoria',
              style: TextStyle(color: CupertinoColors.label),
            ),
            Row(
              children: [
                Icon(
                  _selectedCategory.icon,
                  color: _selectedCategory.color,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  _selectedCategory.name,
                  style: const TextStyle(color: CupertinoColors.secondaryLabel),
                ),
                const Icon(
                  CupertinoIcons.chevron_right,
                  size: 16,
                  color: CupertinoColors.systemGrey3,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showCupertinoPickerIOS() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 250,
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: Column(
          children: [
            Container(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                child: const Text('Confirmar'),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: CupertinoPicker(
                itemExtent: 40,
                onSelectedItemChanged: (index) => setState(
                  () => _selectedCategory = TransactionCategory.values[index],
                ),
                children: TransactionCategory.values
                    .map((c) => Center(child: Text(c.name)))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubmitButton({required bool isIOS}) {
    const child = Text(
      'Salvar Transação',
      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
    );
    return isIOS
        ? CupertinoButton(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(12),
            onPressed: _submitForm,
            child: const Center(child: child),
          )
        : ElevatedButton(
            onPressed: _submitForm,
            style: ElevatedButton.styleFrom(
              minimumSize: const Size(double.infinity, 56),
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: child,
          );
  }
}
