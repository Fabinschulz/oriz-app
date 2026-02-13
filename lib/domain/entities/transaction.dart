import 'package:oriz/domain/enum/transaction_category.dart';
import 'package:oriz/domain/enum/transaction_type.dart';

class Transaction {
  final String id;
  final String description;
  final double amount;
  final DateTime date;
  final TransactionType type;
  final TransactionCategory category;

  Transaction({
    required this.id,
    required this.description,
    required this.amount,
    required this.date,
    required this.type,
    required this.category,
  });

  bool get isIncome => type == TransactionType.income;
  bool get isExpense => type == TransactionType.expense;
}
