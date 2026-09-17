import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
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

  bool carregando = false;

  String? validarNome(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Informe seu nome completo';
    }
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

  Future<bool> cadastrarUsuario() async {
    if (!formKey.currentState!.validate()) {
      return false;
    }

    try {
      carregando = true;

      UserCredential credencial = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
        email: emailController.text.trim(),
        password: senhaController.text,
      );

      final user = credencial.user;

      if (user != null) {
         
        await FirebaseFirestore.instance
            .collection('usuarios')
            .doc(user.uid)
            .set({
          'uid': user.uid,
          'nome': nomeController.text.trim(),
          'cpf': cpfController.text.trim(),
          'email': emailController.text.trim(),
          'whatsapp': whatsappController.text.trim(),
          'cidade': cidadeController.text.trim(),
          'estado': estadoController.text.trim(),
          'criadoEm': FieldValue.serverTimestamp(),
        });
      }

      carregando = false;
      return true;
    } catch (e) {
      carregando = false;
      print("Erro ao cadastrar usuário: $e");
      return false;
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