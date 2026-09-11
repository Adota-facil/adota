import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:adota_facil/models/repositories/usuario_repository.dart';

class CadastroUsuarioController {
  final UsuarioRepository _repository;

  CadastroUsuarioController({UsuarioRepository? repository})
      : _repository = repository ?? UsuarioRepositoryImpl();

  final formKey = GlobalKey<FormState>();
  final nomeController = TextEditingController();
  final cpfController = TextEditingController();
  final emailController = TextEditingController();
  final confirmarEmailController = TextEditingController();
  final whatsappController = TextEditingController();
  final cidadeController = TextEditingController();
  final estadoController = TextEditingController();
  final senhaController = TextEditingController();
  final confirmarSenhaController = TextEditingController();

  bool _cadastrando = false;
  bool get cadastrando => _cadastrando;

  String? _erro;
  String? get erro => _erro;

  // Validações de Regra de Negócio
  String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty)
      return 'Informe seu nome completo';
    return null;
  }

  String? validarCPF(String? value) {
    if (value == null || value.isEmpty) return 'Informe o CPF';
    if (value.length < 11) return 'CPF inválido';
    return null;
  }

  String? validarEmail(String? value) {
    if (value == null || value.isEmpty) return 'Informe o e-mail';
    if (!value.contains('@')) return 'E-mail inválido';
    return null;
  }

  String? validarConfirmacaoEmail(String? value) {
    if (value != emailController.text) return 'Os e-mails não coincidem';
    return null;
  }

  String? validarSenha(String? value) {
    if (value == null || value.length < 8) {
      return 'A senha deve ter pelo menos 8 caracteres';
    }
    return null;
  }

  String? validarConfirmacaoSenha(String? value) {
    if (value != senhaController.text) return 'As senhas não coincidem';
    return null;
  }

  /// Cria o usuário no Firebase Authentication e o documento em
  /// `usuarios/{uid}`. Retorna true se o cadastro deu certo.
  Future<bool> cadastrarUsuario() async {
    if (!formKey.currentState!.validate()) return false;

    _cadastrando = true;
    _erro = null;

    try {
      await _repository.cadastrarUsuario(
        nome: nomeController.text.trim(),
        cpf: cpfController.text.trim(),
        email: emailController.text.trim(),
        senha: senhaController.text,
        whatsapp: whatsappController.text.trim(),
        cidade: cidadeController.text.trim(),
        estado: estadoController.text.trim(),
      );
      return true;
    } on FirebaseAuthException catch (e) {
      _erro = switch (e.code) {
        'email-already-in-use' => 'Este e-mail já está cadastrado.',
        'weak-password' => 'Senha muito fraca.',
        'invalid-email' => 'E-mail inválido.',
        _ => 'Não foi possível concluir o cadastro.',
      };
      return false;
    } catch (e) {
      _erro = 'Não foi possível concluir o cadastro.';
      return false;
    } finally {
      _cadastrando = false;
    }
  }

  void dispose() {
    nomeController.dispose();
    cpfController.dispose();
    emailController.dispose();
    confirmarEmailController.dispose();
    whatsappController.dispose();
    cidadeController.dispose();
    estadoController.dispose();
    senhaController.dispose();
    confirmarSenhaController.dispose();
  }
}