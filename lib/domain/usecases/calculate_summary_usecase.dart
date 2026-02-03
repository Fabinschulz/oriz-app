import '../entities/transaction.dart';

class TransactionSummary {
  final double totalIncome;
  final double totalExpense;
  final double balance;

  TransactionSummary({
    required this.totalIncome,
    required this.totalExpense,
    required this.balance,
  });
}

class CalculateSummaryUseCase {
  TransactionSummary call(List<Transaction> transactions) {
    double income = 0;
    double expense = 0;

    for (var t in transactions) {
      if (t.isIncome) {
        income += t.amount;
      } else {
        expense += t.amount;
      }
    }

    return TransactionSummary(
      totalIncome: income,
      totalExpense: expense,
      balance: income - expense,
    );
  }
}
