import 'package:oriz/domain/entities/category_total.dart';
import 'package:oriz/domain/entities/transaction.dart';
import 'package:oriz/domain/enum/transaction_category.dart';

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
