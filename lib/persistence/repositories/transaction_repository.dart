import 'package:oriz_app/domain/contracts/transaction_repository.dart';
import 'package:oriz_app/domain/entities/transaction.dart';
import 'package:oriz_app/domain/enum/transaction_category.dart';
import 'package:oriz_app/domain/enum/transaction_type.dart';

final List<Transaction> _mockDatabase = [
  Transaction(
    id: '1',
    description: 'Salário Mensal',
    amount: 5000.0,
    date: DateTime.now(),
    type: TransactionType.income,
    category: TransactionCategory.salario,
  ),
  Transaction(
    id: '2',
    description: 'Supermercado Mensal',
    amount: 800.0,
    date: DateTime.now(),
    type: TransactionType.expense,
    category: TransactionCategory.mercado,
  ),
  Transaction(
    id: '3',
    description: 'Academia',
    amount: 150.0,
    date: DateTime.now(),
    type: TransactionType.expense,
    category: TransactionCategory.academia,
  ),
];

class MockTransactionRepository implements ITransactionRepository {
  @override
  Future<List<Transaction>> getTransactions() async {
    return _mockDatabase;
  }

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    _mockDatabase.add(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _mockDatabase.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<Transaction>> getTransactionsByMonth(DateTime month) async {
    return _mockDatabase
        .where((t) => t.date.month == month.month && t.date.year == month.year)
        .toList();
  }

  @override
  Future<List<Transaction>> getTransactionsByPeriod(
    DateTime start,
    DateTime end,
  ) async {
    return _mockDatabase
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }
}
