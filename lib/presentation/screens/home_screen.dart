import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oriz_app/presentation/controllers/transaction_controller.dart';
import 'package:oriz_app/presentation/widgets/category_pie_chart.dart';

class HomeScreen extends StatefulWidget {
  final TransactionController controller;

  const HomeScreen({super.key, required this.controller});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.controller.loadDashboardData();
  }

  @override
  Widget build(BuildContext context) {
    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Oriz - Gestão Financeira'),
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) {
          if (widget.controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          final summary = widget.controller.summary;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    _buildSummaryCard(
                      'Entradas',
                      summary?.totalIncome ?? 0,
                      Colors.green,
                      currencyFormatter,
                    ),
                    const SizedBox(width: 10),
                    _buildSummaryCard(
                      'Saídas',
                      summary?.totalExpense ?? 0,
                      Colors.red,
                      currencyFormatter,
                    ),
                  ],
                ),

                const SizedBox(height: 32),

                const Text(
                  'Distribuição de Gastos',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Center(
                  child: CategoryPieChart(
                    categoryTotals: widget.controller.categoryTotals,
                    totalExpenses: summary?.totalExpense ?? 0,
                  ),
                ),

                const SizedBox(height: 32),

                const Text(
                  'Histórico de Transações',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),

                ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: widget.controller.transactions.length,
                  itemBuilder: (context, index) {
                    final transaction = widget.controller.transactions[index];
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: CircleAvatar(
                        backgroundColor: transaction.isIncome
                            ? Colors.green.withOpacity(0.1)
                            : Colors.red.withOpacity(0.1),
                        child: Icon(
                          transaction.isIncome
                              ? Icons.arrow_upward
                              : Icons.arrow_downward,
                          color: transaction.isIncome
                              ? Colors.green
                              : Colors.red,
                          size: 20,
                        ),
                      ),
                      title: Text(
                        transaction.description,
                        style: const TextStyle(fontWeight: FontWeight.w500),
                      ),
                      subtitle: Text(transaction.category.name),
                      trailing: Text(
                        currencyFormatter.format(transaction.amount),
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: transaction.isIncome
                              ? Colors.green
                              : Colors.black,
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          debugPrint('Adicionar nova transação');
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    double value,
    Color color,
    NumberFormat formatter,
  ) {
    return Expanded(
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 12, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                formatter.format(value),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
