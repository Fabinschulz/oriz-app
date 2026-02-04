import 'package:oriz_app/domain/contracts/transaction_repository.dart';
import 'package:oriz_app/domain/entities/transaction.dart';
import 'package:oriz_app/domain/enum/transaction_category.dart';
import 'package:oriz_app/domain/enum/transaction_type.dart';
import 'package:oriz_app/persistence/database/db_config.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

class SqfliteTransactionRepository implements ITransactionRepository {
  final _db = DatabaseConfig.instance;

  @override
  Future<void> saveTransaction(Transaction transaction) async {
    final db = await _db.database;
    await db.insert('transactions', {
      'id': transaction.id,
      'description': transaction.description,
      'amount': transaction.amount,
      'date': transaction.date.toIso8601String(),
      'type': transaction.type.name,
      'category': transaction.category.name,
    }, conflictAlgorithm: sqflite.ConflictAlgorithm.replace);
  }

  @override
  Future<List<Transaction>> getTransactions() async {
    final db = await _db.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'transactions',
      orderBy: 'date DESC',
    );

    return maps.map((map) => _fromMap(map)).toList();
  }

  @override
  Future<void> deleteTransaction(String id) async {
    final db = await _db.database;
    await db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  @override
  Future<List<Transaction>> getTransactionsByMonth(DateTime month) async {
    final firstDay = DateTime(month.year, month.month, 1);
    final lastDay = DateTime(month.year, month.month + 1, 0, 23, 59, 59);

    return getTransactionsByPeriod(firstDay, lastDay);
  }

  @override
  Future<List<Transaction>> getTransactionsByPeriod(
    DateTime start,
    DateTime end,
  ) async {
    final db = await _db.database;
    final maps = await db.query(
      'transactions',
      where: 'date BETWEEN ? AND ?',
      whereArgs: [start.toIso8601String(), end.toIso8601String()],
    );

    return maps.map((map) => _fromMap(map)).toList();
  }

  Transaction _fromMap(Map<String, dynamic> map) {
    return Transaction(
      id: map['id'] as String,
      description: map['description'] as String,
      amount: map['amount'] as double,
      date: DateTime.parse(map['date'] as String),
      type: TransactionType.values.byName(map['type'] as String),
      category: TransactionCategory.values.byName(map['category'] as String),
    );
  }
}
