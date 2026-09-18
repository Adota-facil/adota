abstract class AnalyticsService {
  Future<void> logPetCadastrado({required String especie});
  Future<void> logFiltroCategoriaUsado({required String categoria});
  Future<void> logTelaVisualizada({required String nomeTela});
}
 