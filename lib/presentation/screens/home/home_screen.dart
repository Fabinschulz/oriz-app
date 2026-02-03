import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/presentation/controllers/transaction_controller.dart';
import 'package:oriz_app/presentation/screens/home/components/bottom_actions.dart';
import 'package:oriz_app/presentation/screens/home/components/empty_state.dart';
import 'package:oriz_app/presentation/screens/home/components/period_selector.dart';
import 'package:oriz_app/presentation/screens/home/components/transaction_dismissible.dart';
import 'package:oriz_app/presentation/screens/new_transaction/add_transaction_screen.dart';
import 'package:oriz_app/presentation/widgets/category_pie_chart.dart';

import 'components/summary_card.dart';

class HomeScreen extends StatefulWidget {
  final TransactionController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    widget.controller.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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

      bottomNavigationBar: BottomActions(
        onScrollToTop: _scrollToTop,
        onSortPressed: _showSortMenu,
        onAddPressed: _navigateToNewTransaction,
      ),
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutCubic,
    );
  }

  void _showSortMenu() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SortBottomSheet(controller: widget.controller),
    );
  }

  void _navigateToNewTransaction() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => AddTransactionScreen(controller: widget.controller),
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
    final controller = widget.controller;
    final hasTransactions = controller.transactions.isNotEmpty;

    return SingleChildScrollView(
      controller: _scrollController,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          PeriodSelector(controller: controller),
          const SizedBox(height: 24),

          _buildSummarySection(),
          const SizedBox(height: 32),

          if (hasTransactions)
            _buildChartSection()
          else
            const EmptyChartState(),

          const SizedBox(height: 32),

          if (hasTransactions)
            _buildHistorySection()
          else
            const EmptyHistoryState(),
        ],
      ),
    );
  }

  Widget _buildSummarySection() {
    final summary = widget.controller.summary;
    return Row(
      children: [
        SummaryCard(
          label: 'Entradas',
          value: summary?.totalIncome ?? 0,
          color: AppColors.income,
          formatter: _currencyFormatter,
        ),
        const SizedBox(width: 12),
        SummaryCard(
          label: 'Saídas',
          value: summary?.totalExpense ?? 0,
          color: AppColors.expense,
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
          separatorBuilder: (_, _) => const Divider(height: 1),
          itemBuilder: (_, index) {
            return TransactionDismissible(
              transaction: widget.controller.transactions[index],
              formatter: _currencyFormatter,
              onDelete: widget.controller.deleteTransaction,
            );
          },
        ),
      ],
    );
  }
}
