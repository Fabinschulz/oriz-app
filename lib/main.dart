import 'package:flutter/material.dart';
import 'package:oriz_app/domain/usecases/calculate_summary_usecase.dart';
import 'package:oriz_app/domain/usecases/get_category_totals_usecase.dart';
import 'package:oriz_app/persistence/repositories/transaction_repository.dart';
import 'package:oriz_app/presentation/controllers/transaction_controller.dart';
import 'package:oriz_app/presentation/screens/home_screen.dart';

void main() {
  // Instanciando as dependências (Injeção Manual)
  final repository = MockTransactionRepository();
  final calculateSummary = CalculateSummaryUseCase();
  final getCategoryTotals = GetCategoryTotalsUseCase();

  final controller = TransactionController(
    repository,
    calculateSummary,
    getCategoryTotals,
  );

  runApp(
    MaterialApp(
      title: 'Oriz - Gestão Financeira',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.deepPurple),
      home: HomeScreen(controller: controller),
    ),
  );
}
