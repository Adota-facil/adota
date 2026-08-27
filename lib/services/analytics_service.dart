/// [DIP] Interface de analytics. Quem consome (HomeController) depende
/// desta abstração, não do Firebase diretamente — troca de provedor de
/// analytics no futuro (ex: outro serviço) não exige mudar o controller.
abstract class AnalyticsService {
  Future<void> logPetCadastrado({required String especie});
  Future<void> logFiltroCategoriaUsado({required String categoria});
  Future<void> logTelaVisualizada({required String nomeTela});
}
 