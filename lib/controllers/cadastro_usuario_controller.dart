import 'package:flutter/material.dart';

class CadastroUsuarioController {
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

  // Ação principal de cadastro
  Future<bool> cadastrarUsuario() async {
    if (formKey.currentState!.validate()) {
      print("Enviando cadastro para o banco de dados...");
      return true;
    }
    return false;
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
