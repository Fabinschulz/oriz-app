import 'package:oriz/domain/enum/transaction_category.dart';

class CategoryTotal {
  final TransactionCategory category;
  final double totalAmount;

  CategoryTotal({required this.category, required this.totalAmount});
}
