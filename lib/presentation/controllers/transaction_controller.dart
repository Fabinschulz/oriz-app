import 'package:flutter/material.dart';
import 'package:oriz_app/domain/Interface/transaction_repository.dart';
import 'package:oriz_app/domain/entities/transaction_entity.dart';
import 'package:oriz_app/domain/usecases/calculate_summary_usecase.dart';
import 'package:oriz_app/domain/usecases/get_category_totals_usecase.dart';

class TransactionController extends ChangeNotifier {
  final ITransactionRepository _repository;
  final CalculateSummaryUseCase _calculateSummary;
  final GetCategoryTotalsUseCase _getCategoryTotals;

  TransactionController(
    this._repository,
    this._calculateSummary,
    this._getCategoryTotals,
  );

  List<TransactionEntity> transactions = [];
  TransactionSummary? summary;
  List<CategoryTotal> categoryTotals = [];
  bool isLoading = false;

  Future<void> loadDashboardData() async {
    isLoading = true;
    notifyListeners();

    transactions = await _repository.getTransactions();

    summary = _calculateSummary(transactions);
    categoryTotals = _getCategoryTotals(transactions);

    isLoading = false;
    notifyListeners();
  }

  Future<void> addTransaction(TransactionEntity transaction) async {
    await _repository.saveTransaction(transaction);
    await loadDashboardData();
  }
}
