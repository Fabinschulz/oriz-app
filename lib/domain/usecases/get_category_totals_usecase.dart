import '../entities/transaction.dart';
import '../enum/transaction_category.dart';

class CategoryTotal {
  final TransactionCategory category;
  final double totalAmount;

  CategoryTotal({required this.category, required this.totalAmount});
}

class GetCategoryTotalsUseCase {
  List<CategoryTotal> call(List<Transaction> transactions) {
    final Map<TransactionCategory, double> totals = {};

    for (var t in transactions) {
      if (t.isExpense) {
        totals.update(
          t.category,
          (current) => current + t.amount,
          ifAbsent: () => t.amount,
        );
      }
    }

    return totals.entries
        .map((e) => CategoryTotal(category: e.key, totalAmount: e.value))
        .toList();
  }
}
