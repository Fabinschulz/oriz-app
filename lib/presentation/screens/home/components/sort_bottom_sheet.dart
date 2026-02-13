import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:oriz/core/theme/app_colors.dart';
import 'package:oriz/domain/enum/sort.dart';
import 'package:oriz/presentation/controllers/transaction_controller.dart';

class SortBottomSheet extends StatelessWidget {
  final TransactionController controller;

  const SortBottomSheet({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (Platform.isIOS) {
      return CupertinoActionSheet(
        title: const Text('Ordenar por'),
        actions: _buildOptions(context, isIOS: true),
        cancelButton: CupertinoActionSheetAction(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancelar'),
        ),
      );
    }

    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        return Container(
          padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHandle(),
              const Text(
                'Ordenar por',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),

              ..._buildOptions(context, isIOS: false),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildOptions(BuildContext context, {required bool isIOS}) {
    final options = [
      (
        label: 'Mais recentes',
        icon: Icons.calendar_month,
        opt: SortOption.dateDesc,
      ),
      (label: 'Mais antigos', icon: Icons.history, opt: SortOption.dateAsc),
      (
        label: 'Maior valor',
        icon: Icons.trending_up,
        opt: SortOption.amountDesc,
      ),
      (
        label: 'Menor valor',
        icon: Icons.trending_down,
        opt: SortOption.amountAsc,
      ),
    ];

    return options.map((item) {
      final isSelected = controller.currentSort == item.opt;

      if (isIOS) {
        return CupertinoActionSheetAction(
          onPressed: () => _handleSort(context, item.opt),
          child: Text(
            item.label,
            style: TextStyle(
              color: isSelected
                  ? AppColors.primary
                  : CupertinoColors.activeBlue,
            ),
          ),
        );
      }

      return ListTile(
        leading: Icon(
          item.icon,
          color: isSelected ? AppColors.primary : Colors.grey,
        ),
        title: Text(
          item.label,
          style: TextStyle(
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        trailing: isSelected
            ? const Icon(Icons.check_circle, color: AppColors.primary)
            : null,
        onTap: () => _handleSort(context, item.opt),
      );
    }).toList();
  }

  void _handleSort(BuildContext context, SortOption option) {
    controller.sortTransactions(option);
    Navigator.pop(context);
  }

  Widget _buildHandle() {
    return Container(
      width: 32,
      height: 4,
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
