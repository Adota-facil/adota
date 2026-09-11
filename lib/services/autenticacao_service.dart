/// [DIP] Abstração sobre "quem está logado agora". Quem consome
/// (HomeController) depende só disso — não sabe se por trás é Firebase
/// Auth ou outro provedor.
abstract class AutenticacaoService {
  /// uid do usuário logado, ou null se ninguém estiver logado.
  String? get uidUsuarioLogado;
}