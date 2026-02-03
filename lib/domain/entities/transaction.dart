import 'package:flutter/material.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/domain/enum/transaction_category.dart';
import 'package:oriz_app/domain/enum/transaction_type.dart';

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

extension TransactionCategoryExtension on TransactionCategory {
  Color get color {
    switch (this) {
      case TransactionCategory.mercado:
        return AppColors.food;
      case TransactionCategory.gasolina:
        return AppColors.transport;
      case TransactionCategory.salario:
        return AppColors.income;
      case TransactionCategory.escolaParticular:
        return AppColors.education;
      case TransactionCategory.luz:
        return AppColors.utility;
      case TransactionCategory.shopping:
        return AppColors.leisure;
      case TransactionCategory.internet:
        return AppColors.tech;
      case TransactionCategory.natacao:
        return AppColors.leisure;
      case TransactionCategory.academia:
        return AppColors.health;
      default:
        return AppColors.textSecondary;
    }
  }

  IconData get icon {
    switch (this) {
      case TransactionCategory.mercado:
        return Icons.shopping_basket;
      case TransactionCategory.gasolina:
        return Icons.local_gas_station;
      case TransactionCategory.salario:
        return Icons.payments;
      case TransactionCategory.escolaParticular:
        return Icons.school;
      case TransactionCategory.luz:
        return Icons.lightbulb;
      case TransactionCategory.shopping:
        return Icons.shopping_cart;
      case TransactionCategory.internet:
        return Icons.wifi;
      case TransactionCategory.natacao:
        return Icons.pool;
      case TransactionCategory.academia:
        return Icons.fitness_center;
      default:
        return Icons.category;
    }
  }
}
