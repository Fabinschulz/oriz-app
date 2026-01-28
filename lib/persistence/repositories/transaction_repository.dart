import 'package:oriz_app/domain/Interface/transaction_repository.dart';
import 'package:oriz_app/domain/entities/transaction_entity.dart';
import 'package:oriz_app/domain/enum/transaction_category.dart';
import 'package:oriz_app/domain/enum/transaction_type.dart';

final List<TransactionEntity> _mockDatabase = [
  TransactionEntity(
    id: '1',
    description: 'Salário Mensal',
    amount: 5000.0,
    date: DateTime.now(),
    type: TransactionType.income,
    category: TransactionCategory.salario,
  ),
  TransactionEntity(
    id: '2',
    description: 'Supermercado Mensal',
    amount: 800.0,
    date: DateTime.now(),
    type: TransactionType.expense,
    category: TransactionCategory.mercado,
  ),
  TransactionEntity(
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
  Future<List<TransactionEntity>> getTransactions() async {
    return _mockDatabase;
  }

  @override
  Future<void> saveTransaction(TransactionEntity transaction) async {
    _mockDatabase.add(transaction);
  }

  @override
  Future<void> deleteTransaction(String id) async {
    _mockDatabase.removeWhere((t) => t.id == id);
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByMonth(DateTime month) async {
    return _mockDatabase
        .where((t) => t.date.month == month.month && t.date.year == month.year)
        .toList();
  }

  @override
  Future<List<TransactionEntity>> getTransactionsByPeriod(
    DateTime start,
    DateTime end,
  ) async {
    return _mockDatabase
        .where((t) => t.date.isAfter(start) && t.date.isBefore(end))
        .toList();
  }
}
