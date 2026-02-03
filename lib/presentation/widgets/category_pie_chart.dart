import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:oriz_app/core/extensions/transaction_category_extension.dart';
import 'package:oriz_app/domain/entities/category_total.dart';

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
        child: Center(child: Text('Nenhum gasto registrado.')),
      );
    }

    final currencyFormatter = NumberFormat.simpleCurrency(locale: 'pt_BR');

    return Column(
      children: [
        SizedBox(
          height: 220,
          child: PieChart(
            PieChartData(
              sections: _buildSections(),
              borderData: FlBorderData(show: false),
              sectionsSpace: 3,
              centerSpaceRadius: 50,
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

        const SizedBox(height: 24),

        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Wrap(
            spacing: 16.0,
            runSpacing: 12.0,
            alignment: WrapAlignment.center,
            children: widget.categoryTotals.map((data) {
              return _buildLegendItem(data, currencyFormatter);
            }).toList(),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> _buildSections() {
    return widget.categoryTotals.asMap().entries.map((entry) {
      final index = entry.key;
      final data = entry.value;
      final isTouched = index == touchedIndex;

      final double radius = isTouched ? 65 : 55;
      final double fontSize = isTouched ? 18 : 14;
      final percentage = (data.totalAmount / widget.totalExpenses * 100);

      return PieChartSectionData(
        color: data.category.color,
        value: data.totalAmount,
        title: '${percentage.toStringAsFixed(0)}%',
        radius: radius,
        showTitle: percentage > 5,
        titleStyle: TextStyle(
          fontSize: fontSize,
          fontWeight: FontWeight.bold,
          color: Colors.white,
          shadows: const [Shadow(color: Colors.black26, blurRadius: 2)],
        ),
      );
    }).toList();
  }

  Widget _buildLegendItem(CategoryTotal data, NumberFormat formatter) {
    final color = data.category.color;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(6),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            shape: BoxShape.circle,
          ),
          child: Icon(data.category.icon, size: 16, color: color),
        ),
        const SizedBox(width: 8),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              data.category.name,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF2D2D2D),
              ),
            ),
            Text(
              formatter.format(data.totalAmount),
              style: TextStyle(
                fontSize: 11,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
