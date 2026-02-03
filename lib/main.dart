import 'package:flutter/material.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:oriz_app/core/theme/app_colors.dart';
import 'package:oriz_app/domain/usecases/calculate_summary_usecase.dart';
import 'package:oriz_app/domain/usecases/get_category_totals_usecase.dart';
import 'package:oriz_app/persistence/repositories/transaction_repository.dart';
import 'package:oriz_app/presentation/controllers/transaction_controller.dart';
import 'package:oriz_app/presentation/screens/home/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR', null);

  final repository = SqfliteTransactionRepository();
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
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: AppColors.primary),
      home: HomeScreen(controller: controller),
    ),
  );
}
