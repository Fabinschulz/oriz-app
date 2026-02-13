import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oriz/core/theme/app_colors.dart';
import 'package:oriz/domain/entities/transaction.dart';
import 'package:oriz/presentation/screens/home/components/transaction_tile.dart';

/// Widget que representa uma transação que pode ser removida com um gesto de deslizar.
class TransactionDismissible extends StatelessWidget {
  final Transaction transaction;
  final NumberFormat formatter;
  final void Function(String id) onDelete;

  const TransactionDismissible({
    super.key,
    required this.transaction,
    required this.formatter,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: Key(transaction.id),
      direction: DismissDirection.endToStart,
      confirmDismiss: (_) => _confirmDelete(context),
      onDismissed: (_) {
        onDelete(transaction.id);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${transaction.description} removido com sucesso!'),
            backgroundColor: AppColors.primaryDark,
            duration: const Duration(seconds: 2),
          ),
        );
      },
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.delete_sweep_rounded, color: AppColors.primary),
      ),
      child: TransactionTile(transaction: transaction, formatter: formatter),
    );
  }

  Future<bool?> _confirmDelete(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Confirmar exclusão'),
        content: const Text('Deseja realmente apagar esta transação?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Cancelar',
              style: TextStyle(color: AppColors.textSecondary),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            child: const Text('Excluir', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
