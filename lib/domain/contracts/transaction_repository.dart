import '../entities/transaction.dart';

abstract class ITransactionRepository {
  /// Busca todas as transações cadastradas
  Future<List<Transaction>> getTransactions();

  /// Salva uma transação (Criação ou Edição)
  Future<void> saveTransaction(Transaction transaction);

  /// Deleta uma transação específica
  Future<void> deleteTransaction(String id);

  /// Método estratégico para o seu MVP: Filtro mensal para métricas e gráficos
  Future<List<Transaction>> getTransactionsByMonth(DateTime month);

  /// Obtém transações filtradas por um período.
  Future<List<Transaction>> getTransactionsByPeriod(
    DateTime start,
    DateTime end,
  );
}
