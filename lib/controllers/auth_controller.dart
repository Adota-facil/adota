import 'dart:async';

import 'package:adota_facil/models/repositories/auth_repository.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/models/usuario_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AuthController extends ChangeNotifier {
  final AuthRepository _authRepository;
  final UsuarioRepository _usuarioRepository;
  late final StreamSubscription<String?> _inscricaoAuth;

  AuthController(this._authRepository, this._usuarioRepository) {
    _inscricaoAuth = _authRepository.mudancasDeUsuario.listen((_) {
      notifyListeners();
    });
  }

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  String? get usuarioId => _authRepository.uidAtual;
  bool get logado => usuarioId != null;

  Future<bool> cadastrar({
    required String nome,
    required String email,
    required String senha,
    required String tipo,
    String? tipoAnunciante,
    String? telefone,
    String? estado,
    String? cidade,
    String? fotoUrl,
    String? fotoBase64,
  }) async {
    _setCarregando(true);
    try {
      final uid = await _authRepository.cadastrar(email: email, senha: senha);
      final usuario = UsuarioModel(
        id: uid,
        nome: nome,
        email: email,
        telefone: telefone,
        fotoUrl: fotoUrl ?? '',
        fotoBase64: fotoBase64 ?? '',
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

  Future<bool> loginComGoogle({
    String tipo = 'adotante',
    String? tipoAnunciante,
    String? telefone,
    String? estado,
    String? cidade,
  }) async {
    _setCarregando(true);
    try {
      final credencial = await _authRepository.loginComGoogle();
      final usuario = credencial.user;
      if (usuario == null) return false;

      final perfilExistente = await _usuarioRepository.buscarPorId(usuario.uid);
      if (perfilExistente == null) {
        await _usuarioRepository.salvar(
          UsuarioModel(
            id: usuario.uid,
            nome: usuario.displayName ?? 'Usuário Google',
            email: usuario.email ?? '',
            fotoUrl: usuario.photoURL ?? '',
            telefone: telefone,
            tipo: tipo,
            tipoAnunciante: tipoAnunciante,
            estado: estado ?? '',
            cidade: cidade ?? '',
          ),
        );
      }
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

  Future<bool> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    _setCarregando(true);
    try {
      await _authRepository.alterarSenha(
        senhaAtual: senhaAtual,
        novaSenha: novaSenha,
      );
      _erro = null;
      return true;
    } catch (e) {
      _erro = _mensagemDeErro(e);
      return false;
    } finally {
      _setCarregando(false);
    }
  }

  Future<bool> excluirConta({required String senha}) async {
    final uid = usuarioId;
    if (uid == null) return false;

    _setCarregando(true);
    try {
      await _usuarioRepository.deletar(uid);
      await _authRepository.excluirConta(senha: senha);
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
        case 'operation-not-allowed':
          return 'O login com Google não está habilitado no Firebase.';
        case 'network-request-failed':
          return 'Verifique sua conexão com a internet e tente novamente.';
        case 'account-exists-with-different-credential':
          return 'Já existe uma conta com este e-mail usando outro método de login.';
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

  @override
  void dispose() {
    _inscricaoAuth.cancel();
    super.dispose();
  }
}