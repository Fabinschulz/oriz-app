import 'package:flutter/material.dart';
import 'package:oriz_app/domain/contracts/transaction_repository.dart';
import 'package:oriz_app/domain/entities/category_total.dart';
import 'package:oriz_app/domain/entities/transaction.dart';
import 'package:oriz_app/domain/enum/sort.dart';
import 'package:oriz_app/domain/enum/transaction_category.dart';
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

  List<Transaction> _transactions = [];
  List<CategoryTotal> _categoryTotals = [];
  late TransactionSummary _summary;

  bool _isLoading = false;
  DateTime _selectedDate = DateTime.now();
  SortOption _currentSort = SortOption.dateDesc;

  List<Transaction> get transactions => List.unmodifiable(_transactions);
  List<CategoryTotal> get categoryTotals => List.unmodifiable(_categoryTotals);
  TransactionSummary get summary => _summary;
  bool get isLoading => _isLoading;
  DateTime get selectedDate => _selectedDate;
  SortOption get currentSort => _currentSort;

  void updateSelectedDate(DateTime newDate) {
    if (_selectedDate == newDate) return;
    _selectedDate = newDate;
    loadDashboardData();
  }

  void sortTransactions(SortOption option) {
    if (_currentSort == option) return;
    _currentSort = option;
    _applySort();
    notifyListeners();
  }

  Future<void> loadDashboardData() async {
    _setLoading(true);

    try {
      final rawTransactions = await _repository.getTransactionsByMonth(
        _selectedDate,
      );

      _transactions = List.of(rawTransactions);
      _applySort();

      _summary = _calculateSummary(_transactions);
      final rawTotals = _getCategoryTotals(_transactions);
      _categoryTotals = _processCategoryGrouping(rawTotals);
    } catch (e) {
      // TODO: Implementar tratamento de erro (ex: log ou estado de erro)
      debugPrint('Erro ao carregar dashboard: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addTransaction(Transaction transaction) async {
    await _repository.saveTransaction(transaction);
    await loadDashboardData();
  }

  Future<void> deleteTransaction(String id) async {
    await _repository.deleteTransaction(id);
    await loadDashboardData();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _applySort() {
    final comparators = <SortOption, int Function(Transaction, Transaction)>{
      SortOption.dateDesc: (a, b) => b.date.compareTo(a.date),
      SortOption.dateAsc: (a, b) => a.date.compareTo(b.date),
      SortOption.amountDesc: (a, b) => b.amount.compareTo(a.amount),
      SortOption.amountAsc: (a, b) => a.amount.compareTo(b.amount),
    };

    _transactions.sort(comparators[_currentSort]!);
  }

  List<CategoryTotal> _processCategoryGrouping(List<CategoryTotal> totals) {
    const maxItems = 5;

    if (totals.length <= (maxItems + 1)) {
      return List.of(totals)
        ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));
    }

    final sortedTotals = List.of(totals)
      ..sort((a, b) => b.totalAmount.compareTo(a.totalAmount));

    final topCategories = sortedTotals.take(maxItems).toList();

    final othersSum = sortedTotals
        .skip(maxItems)
        .fold<double>(0.0, (sum, item) => sum + item.totalAmount);

    if (othersSum > 0) {
      topCategories.add(
        CategoryTotal(
          category: TransactionCategory.outros,
          totalAmount: othersSum,
        ),
      );
    }

    return topCategories;
  }
}
