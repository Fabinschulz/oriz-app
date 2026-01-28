import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oriz_app/domain/enum/transaction_category.dart';
import 'package:oriz_app/domain/usecases/get_category_totals_usecase.dart';

class CategoryPieChart extends StatefulWidget {
  final List<CategoryTotal> categoryTotals;
  final double totalExpenses;

  const CategoryPieChart({
    super.key,
    required this.categoryTotals,
    required this.totalExpenses,
  });

  @override
  State<CategoryPieChart> createState() => _CategoryPieChartState();
}

class _CategoryPieChartState extends State<CategoryPieChart> {
  int touchedIndex = -1;

  @override
  Widget build(BuildContext context) {
    if (widget.categoryTotals.isEmpty || widget.totalExpenses == 0) {
      return const SizedBox(
        height: 200,
        child: Center(
          child: Text('Nenhum gasto registrado para exibir no gráfico.'),
        ),
      );
    }

    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    final List<PieChartSectionData> sections = widget.categoryTotals
        .asMap()
        .entries
        .map((entry) {
          final int index = entry.key;
          final CategoryTotal data = entry.value;
          final isTouched = index == touchedIndex;
          final double radius = isTouched ? 60 : 50;
          final double fontSize = isTouched ? 16 : 12;

          final percentage = (data.totalAmount / widget.totalExpenses * 100);

          Color sectionColor;
          switch (data.category) {
            case TransactionCategory.mercado:
              sectionColor = Colors.orange;
              break;
            case TransactionCategory.gasolina:
              sectionColor = Colors.blue;
              break;
            case TransactionCategory.escolaParticular:
              sectionColor = Colors.purple;
              break;
            case TransactionCategory.luz:
              sectionColor = Colors.yellow;
              break;
            case TransactionCategory.shopping:
              sectionColor = Colors.pink;
              break;
            case TransactionCategory.internet:
              sectionColor = Colors.teal;
              break;
            case TransactionCategory.natacao:
              sectionColor = Colors.indigo;
              break;
            case TransactionCategory.academia:
              sectionColor = Colors.brown;
              break;
            case TransactionCategory.salario:
              sectionColor = Colors.green;
              break;
            case TransactionCategory.outros:
              sectionColor = Colors.grey;
              break;
          }

          return PieChartSectionData(
            color: sectionColor,
            value: data.totalAmount,
            title: '${percentage.toStringAsFixed(1)}%',
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            badgeWidget: Text(
              data.category.name,
              style: TextStyle(color: sectionColor, fontSize: 10),
            ),
            badgePositionPercentageOffset: 1.1,
          );
        })
        .toList();

    return Column(
      children: [
        SizedBox(
          height: 200,
          child: PieChart(
            PieChartData(
              sections: sections,
              borderData: FlBorderData(show: false),
              sectionsSpace: 2,
              centerSpaceRadius: 40,
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
            ),
          ),
        ),
        const SizedBox(height: 20),
        Wrap(
          spacing: 8.0,
          runSpacing: 4.0,
          children: widget.categoryTotals.map((data) {
            Color legendColor;
            switch (data.category) {
              case TransactionCategory.mercado:
                legendColor = Colors.orange;
                break;
              case TransactionCategory.gasolina:
                legendColor = Colors.blue;
                break;
              case TransactionCategory.escolaParticular:
                legendColor = Colors.purple;
                break;
              case TransactionCategory.luz:
                legendColor = Colors.yellow;
                break;
              case TransactionCategory.shopping:
                legendColor = Colors.pink;
                break;
              case TransactionCategory.internet:
                legendColor = Colors.teal;
                break;
              case TransactionCategory.natacao:
                legendColor = Colors.indigo;
                break;
              case TransactionCategory.academia:
                legendColor = Colors.brown;
                break;
              case TransactionCategory.salario:
                legendColor = Colors.green;
                break;
              case TransactionCategory.outros:
                legendColor = Colors.grey;
                break;
            }
            return Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(width: 10, height: 10, color: legendColor),
                const SizedBox(width: 4),
                Text(
                  '${data.category.name} (${currencyFormatter.format(data.totalAmount)})',
                  style: const TextStyle(fontSize: 12),
                ),
              ],
            );
          }).toList(),
        ),
      ],
    );
  }
}
