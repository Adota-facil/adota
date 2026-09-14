import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/models/usuario_model.dart';
import 'package:flutter/material.dart';

class PerfilUsuarioController extends ChangeNotifier {
  final AuthController _authController;
  final UsuarioRepository _usuarioRepository;

  PerfilUsuarioController(this._authController, this._usuarioRepository) {
    _authController.addListener(_aoMudarAuth);
    _carregar();
  }

  UsuarioModel? _usuario;
  bool _carregando = false;

  bool get logado => _authController.logado;
  bool get carregando => _carregando;

  String get nomeExibicao => _usuario?.nome ?? '';
  String get tempoMembro =>
      _usuario?.criadoEm != null ? 'Membro desde ${_usuario!.criadoEm!.year}' : '';
  String get nomeCompleto => _usuario?.nome ?? '-';
  String get email => _usuario?.email ?? '-';
  String get whatsapp =>
      (_usuario?.telefone != null && _usuario!.telefone!.isNotEmpty)
          ? _usuario!.telefone!
          : '-';
  String get estado => (_usuario?.estado.isNotEmpty ?? false) ? _usuario!.estado : '-';
  String get cidade => (_usuario?.cidade.isNotEmpty ?? false) ? _usuario!.cidade : '-';

  void _aoMudarAuth() => _carregar();

  Future<void> _carregar() async {
    if (!_authController.logado) {
      _usuario = null;
      notifyListeners();
      return;
    }
    _carregando = true;
    notifyListeners();
    try {
      _usuario = await _usuarioRepository.buscarPorId(_authController.usuarioId!);
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  // Regra de negócio: Altera a foto do perfil
  Future<void> editarFotoPerfil(BuildContext context) async {
    // Futuramente: galeria/câmera + Firebase Storage.
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Função para alterar foto em breve!')),
    );
  }

  // Regra de negócio: Realiza o Logout do aplicativo
  Future<void> sairDaConta(BuildContext context) async {
    await _authController.logout();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sessão encerrada com sucesso.')),
    );
  }

  @override
  void dispose() {
    _authController.removeListener(_aoMudarAuth);
    super.dispose();
  }
}