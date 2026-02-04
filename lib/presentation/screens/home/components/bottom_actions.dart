import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/domain/enum/sort.dart';
import 'package:oriz_app/presentation/controllers/transaction_controller.dart';

class BottomActions extends StatelessWidget {
  final VoidCallback onScrollToTop;
  final VoidCallback onSortPressed;
  final VoidCallback onAddPressed;

  const BottomActions({
    super.key,
    required this.onScrollToTop,
    required this.onSortPressed,
    required this.onAddPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(24, 0, 24, 30),
      height: 55,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(25),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(25),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Row(
            children: [
              Expanded(
                child: IconButton(
                  icon: const Icon(
                    Icons.filter_list_alt,
                    color: AppColors.textSecondary,
                    size: 28,
                  ),
                  onPressed: onSortPressed,
                ),
              ),

              GestureDetector(
                onTap: onAddPressed,
                child: const Icon(
                  Icons.add_home_work_outlined,
                  color: AppColors.textSecondary,
                  size: 28,
                ),
              ),

              Expanded(
                child: IconButton(
                  icon: const Icon(
                    Icons.arrow_upward,
                    color: AppColors.textSecondary,
                    size: 28,
                  ),
                  onPressed: onScrollToTop,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Bottom usado para ordenar as transações
class SortBottomSheet extends StatelessWidget {
  final TransactionController controller;

  const SortBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 20),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const Text(
                'Ordenar por',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              _SortOptionItem(
                label: 'Mais recentes primeiro',
                icon: Icons.calendar_month,
                isSelected: controller.currentSort == SortOption.dateDesc,
                onSortButtonClick: () {
                  controller.sortTransactions(SortOption.dateDesc);
                  Navigator.pop(context);
                },
              ),
              _SortOptionItem(
                label: 'Mais antigos primeiro',
                icon: Icons.history,
                isSelected: controller.currentSort == SortOption.dateAsc,
                onSortButtonClick: () {
                  controller.sortTransactions(SortOption.dateAsc);
                  Navigator.pop(context);
                },
              ),
              _SortOptionItem(
                label: 'Maior valor',
                icon: Icons.arrow_upward,
                isSelected: controller.currentSort == SortOption.amountDesc,
                onSortButtonClick: () {
                  controller.sortTransactions(SortOption.amountDesc);
                  Navigator.pop(context);
                },
              ),
              _SortOptionItem(
                label: 'Menor valor',
                icon: Icons.arrow_downward,
                isSelected: controller.currentSort == SortOption.amountAsc,
                onSortButtonClick: () {
                  controller.sortTransactions(SortOption.amountAsc);
                  Navigator.pop(context);
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }
}

class _SortOptionItem extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onSortButtonClick;
  final bool isSelected;

  const _SortOptionItem({
    required this.label,
    required this.icon,
    required this.onSortButtonClick,
    this.isSelected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(icon, color: isSelected ? AppColors.primary : Colors.grey),
      title: Text(
        label,
        style: TextStyle(
          fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
          color: isSelected ? AppColors.primary : Colors.black87,
        ),
      ),
      trailing: isSelected
          ? const Icon(Icons.check, color: AppColors.primary)
          : null,
      onTap: onSortButtonClick,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    );
  }
}
