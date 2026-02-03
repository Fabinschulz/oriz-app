import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oriz_app/core/extensions/transaction_category_extension.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/domain/entities/transaction.dart';

class TransactionListTile extends StatelessWidget {
  final Transaction transaction;
  final NumberFormat formatter;

  const TransactionListTile({
    super.key,
    required this.transaction,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final categoryColor = transaction.category.color;
    final categoryIcon = transaction.category.icon;
    final isIncome = transaction.isIncome;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: 4),
      leading: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          color: categoryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Icon(categoryIcon, color: categoryColor, size: 24),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 15,
          color: AppColors.textPrimary,
        ),
      ),
      subtitle: Text(
        transaction.category.name,
        style: const TextStyle(color: AppColors.textSecondary, fontSize: 13),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${isIncome ? "+" : "-"} ${formatter.format(transaction.amount)}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 15,
              color: isIncome ? AppColors.income : AppColors.expense,
            ),
          ),
          Text(
            DateFormat('dd MMM').format(transaction.date),
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
