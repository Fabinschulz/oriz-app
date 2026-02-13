import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oriz/core/theme/app_colors.dart';
import 'package:oriz/presentation/controllers/transaction_controller.dart';

class PeriodSelector extends StatelessWidget {
  final TransactionController controller;

  const PeriodSelector({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();

    final isCurrentMonth =
        controller.selectedDate.year == now.year &&
        controller.selectedDate.month == now.month;

    final nextButtonColor = isCurrentMonth
        ? Colors.grey[400]
        : AppColors.primary;

    final dateText = DateFormat(
      'MMMM yyyy',
      'pt_BR',
    ).format(controller.selectedDate);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: AppColors.primary),
            onPressed: () {
              final previousDateTime = DateTime(
                controller.selectedDate.year,
                controller.selectedDate.month - 1,
              );
              controller.updateSelectedDate(previousDateTime);
            },
          ),

          Text(
            dateText.toUpperCase(),
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
          ),

          IconButton(
            icon: Icon(Icons.chevron_right, color: nextButtonColor),
            onPressed: isCurrentMonth
                ? null
                : () {
                    final nextDateTime = DateTime(
                      controller.selectedDate.year,
                      controller.selectedDate.month + 1,
                    );
                    controller.updateSelectedDate(nextDateTime);
                  },
          ),
        ],
      ),
    );
  }
}
