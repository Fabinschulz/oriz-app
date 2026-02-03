import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/domain/entities/transaction.dart';
import 'package:oriz_app/presentation/controllers/transaction_controller.dart';
import 'package:oriz_app/presentation/widgets/category_pie_chart.dart';

class HomeScreen extends StatefulWidget {
  final TransactionController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

  @override
  void initState() {
    super.initState();
    widget.controller.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _buildAppBar(),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          if (widget.controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          return _buildContent();
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => debugPrint('Navegar para criação'),
        child: const Icon(Icons.add),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle.light,
      title: const Text(
        'Dashboard',
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      centerTitle: true,
      backgroundColor: AppColors.primary,
      elevation: 0,
    );
  }

  Widget _buildContent() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummarySection(),
          const SizedBox(height: 32),
          _buildChartSection(),
          const SizedBox(height: 32),
          _buildHistorySection(),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final summary = widget.controller.summary;
    return Row(
      children: [
        _SummaryCard(
          label: 'Entradas',
          value: summary?.totalIncome ?? 0,
          color: Colors.green,
          formatter: _currencyFormatter,
        ),
        const SizedBox(width: 12),
        _SummaryCard(
          label: 'Saídas',
          value: summary?.totalExpense ?? 0,
          color: Colors.red,
          formatter: _currencyFormatter,
        ),
      ],
    );
  }

  Widget _buildChartSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Distribuição de Gastos',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        CategoryPieChart(
          categoryTotals: widget.controller.categoryTotals,
          totalExpenses: widget.controller.summary?.totalExpense ?? 0,
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Histórico de Transações',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: widget.controller.transactions.length,
          separatorBuilder: (_, __) => const Divider(height: 1),
          itemBuilder: (context, index) {
            final transaction = widget.controller.transactions[index];
            return _TransactionListTile(
              transaction: transaction,
              formatter: _currencyFormatter,
            );
          },
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final String label;
  final double value;
  final Color color;
  final NumberFormat formatter;

  const _SummaryCard({
    required this.label,
    required this.value,
    required this.color,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 13,
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              formatter.format(value),
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: color,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TransactionListTile extends StatelessWidget {
  final Transaction transaction;
  final NumberFormat formatter;

  const _TransactionListTile({
    required this.transaction,
    required this.formatter,
  });

  @override
  Widget build(BuildContext context) {
    final isIncome = transaction.isIncome;
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: CircleAvatar(
        backgroundColor: (isIncome ? Colors.green : Colors.red).withOpacity(
          0.1,
        ),
        child: Icon(
          isIncome ? Icons.arrow_upward : Icons.arrow_downward,
          color: isIncome ? Colors.green : Colors.red,
          size: 20,
        ),
      ),
      title: Text(
        transaction.description,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(transaction.category.name),
      trailing: Text(
        formatter.format(transaction.amount),
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: isIncome ? AppColors.income : AppColors.expense,
        ),
      ),
    );
  }
}
