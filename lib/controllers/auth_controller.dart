import 'package:adota_facil/models/repositories/auth_repository.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/models/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UsuarioRepository _usuarioRepository;

  AuthController(this._authRepository, this._usuarioRepository);

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  String? get usuarioId => _authRepository.uidAtual;
  bool get logado => usuarioId != null;

  /// Cria a conta no Firebase Auth e, se der certo, já cria o documento
  /// correspondente em `usuarios`. Se a criação do perfil falhar depois
  /// da conta já ter sido criada, a conta de auth continua existindo —
  /// numa versão futura dá pra tratar isso com mais cuidado (ex: apagar
  /// a conta se o perfil falhar), mas foge do escopo de agora.
  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String tipo, // 'adotante' | 'anunciante' | 'ambos'
    String? tipoAnunciante,
    String? telefone,
    String? estado,
    String? cidade,
  }) async {
    _setCarregando(true);
    try {
      final uid = await _authRepository.cadastrar(email: email, senha: senha);
      final usuario = UsuarioModel(
        id: uid,
        nome: nome,
        email: email,
        telefone: telefone,
        tipo: tipo,
        tipoAnunciante: tipoAnunciante,
        estado: estado ?? '',
        cidade: cidade ?? '',
      );
      await _usuarioRepository.salvar(usuario);
      _erro = null;
      return true;
    } catch (e) {
      _erro = _mensagemDeErro(e);
      return false;
    } finally {
      _setCarregando(false);
    }
  }

  Future<bool> login({required String email, required String senha}) async {
    _setCarregando(true);
    try {
      await _authRepository.login(email: email, senha: senha);
      _erro = null;
      return true;
    } catch (e) {
      _erro = _mensagemDeErro(e);
      return false;
    } finally {
      _setCarregando(false);
    }
  }

  Future<void> logout() async {
    await _authRepository.logout();
    notifyListeners();
  }

  /// Apaga o documento em `usuarios` ANTES de apagar a conta no Auth —
  /// depois que a conta de Auth some, request.auth deixa de existir e as
  /// regras de segurança do Firestore bloqueariam o delete do documento.
  Future<bool> excluirConta() async {
    final uid = usuarioId;
    if (uid == null) return false;

    _setCarregando(true);
    try {
      await _usuarioRepository.deletar(uid);
      await _authRepository.excluirConta();
      _erro = null;
      notifyListeners();
      return true;
    } catch (e) {
      _erro = _mensagemDeErro(e);
      return false;
    } finally {
      _setCarregando(false);
    }
  }

  String _mensagemDeErro(Object e) {
    if (e is FirebaseAuthException) {
      switch (e.code) {
        case 'email-already-in-use':
          return 'Esse e-mail já está cadastrado.';
        case 'invalid-email':
          return 'E-mail inválido.';
        case 'weak-password':
          return 'Senha muito fraca (mínimo 6 caracteres).';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'E-mail ou senha incorretos.';
        case 'requires-recent-login':
          return 'Por segurança, saia e entre na conta de novo antes de excluir.';
        default:
          return 'Não foi possível completar a operação.';
      }
    }
    return 'Não foi possível completar a operação.';
  }

  void _setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }
}