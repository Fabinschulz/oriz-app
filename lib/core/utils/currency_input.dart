import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class CurrencyInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) {
      return newValue.copyWith(text: '');
    }

    String valueOnlyDigits = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    if (valueOnlyDigits.isEmpty) {
      return newValue.copyWith(text: '');
    }

    double value = double.parse(valueOnlyDigits) / 100;

    final formatter = NumberFormat.simpleCurrency(locale: "pt_BR");
    String newText = formatter.format(value);

    return newValue.copyWith(
      text: newText,
      selection: TextSelection.collapsed(offset: newText.length),
    );
  }
}
