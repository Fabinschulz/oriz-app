import '../entities/transaction_entity.dart';

abstract class ITransactionRepository {
  /// Busca todas as transações cadastradas
  Future<List<TransactionEntity>> getTransactions();

  /// Salva uma transação (Criação ou Edição)
  Future<void> saveTransaction(TransactionEntity transaction);

  /// Deleta uma transação específica
  Future<void> deleteTransaction(String id);

  /// Método estratégico para o seu MVP: Filtro mensal para métricas e gráficos
  Future<List<TransactionEntity>> getTransactionsByMonth(DateTime month);

  /// Obtém transações filtradas por um período.
  Future<List<TransactionEntity>> getTransactionsByPeriod(
    DateTime start,
    DateTime end,
  );
}
