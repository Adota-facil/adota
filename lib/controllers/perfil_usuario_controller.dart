import 'package:flutter/material.dart';

class PerfilUsuarioController {
  // Dados do Usuário (podem vir de um Model no futuro)
  String nomeExibicao = 'Eduardo';
  String tempoMembro = 'Membro desde 2026';
  String nomeCompleto = 'Eduardo da Silva';
  String email = 'eduardo@email.com';
  String whatsapp = '(87) 99999-9999';
  String estado = 'PE';
  String cidade = 'Garanhuns';

  // Regra de negócio: Altera a foto do perfil
  Future<void> editarFotoPerfil(BuildContext context) async {
    // Exemplo: Futuramente chamará a galeria/camera e o Firebase Storage
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Função para alterar foto em breve!')),
    );
  }

  // Regra de negócio: Realiza o Logout do aplicativo
  Future<void> sairDaConta(BuildContext context) async {
    // Aqui você limpa as sessões/tokens de login
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sessão encerrada com sucesso.')),
    );
  }
}
