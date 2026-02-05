import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/presentation/controllers/transaction_controller.dart';
import 'package:oriz_app/presentation/screens/home/components/bottom_actions.dart';
import 'package:oriz_app/presentation/screens/home/components/empty_state.dart';
import 'package:oriz_app/presentation/screens/home/components/period_selector.dart';
import 'package:oriz_app/presentation/screens/home/components/sort_bottom_sheet.dart';
import 'package:oriz_app/presentation/screens/home/components/transaction_dismissible.dart';
import 'package:oriz_app/presentation/screens/new_transaction/new_transaction_screen.dart';
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
  final isIOS = Platform.isIOS;

  @override
  void initState() {
    super.initState();
    widget.controller.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: isIOS ? _buildAppBarIOS() : _buildAppBarAndroid(),
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
      scrollControlDisabledMaxHeightRatio: MediaQuery.of(context).size.height,
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

  CupertinoNavigationBar _buildAppBarIOS() {
    return CupertinoNavigationBar(
      middle: const Text(
        'Dashboard',
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      backgroundColor: AppColors.primary,
    );
  }

  PreferredSizeWidget _buildAppBarAndroid() {
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

    return Column(
      children: [
        SummaryCard(
          label: 'Saldo Disponível',
          value: summary.balance,
          color: summary.balance < 0 ? AppColors.expense : AppColors.balance,
          formatter: _currencyFormatter,
          isMain: true,
          icon: Icons.account_balance_wallet_rounded,
        ),

        const SizedBox(height: 16),

        Row(
          children: [
            Expanded(
              child: SummaryCard(
                label: 'Receitas',
                value: summary.totalIncome,
                color: AppColors.income,
                formatter: _currencyFormatter,
                icon: Icons.arrow_upward_rounded,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SummaryCard(
                label: 'Despesas',
                value: summary.totalExpense,
                color: AppColors.expense,
                formatter: _currencyFormatter,
                icon: Icons.arrow_downward_rounded,
              ),
            ),
          ],
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
          totalExpenses: widget.controller.summary.totalExpense,
        ),
      ],
    );
  }

  Widget _buildHistorySection() {
    final transactions = widget.controller.transactions;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Histórico de Transações',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            // TextButton(onPressed: () {}, child: const Text('Ver tudo')),
          ],
        ),
        const SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: transactions.length,
          itemBuilder: (_, index) {
            final transaction = transactions[index];
            return TransactionDismissible(
              transaction: transaction,
              formatter: _currencyFormatter,
              onDelete: widget.controller.deleteTransaction,
            );
          },
        ),
      ],
    );
  }
}
