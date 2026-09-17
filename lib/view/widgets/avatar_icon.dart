import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/view/pages/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AvatarButton extends StatefulWidget {
  const AvatarButton({super.key});

  @override
  State<AvatarButton> createState() => _AvatarButtonState();
}

class _AvatarButtonState extends State<AvatarButton> {
  Stream<String?>? _streamNomeUsuario;
  String? _usuarioId;

  Stream<String?>? _obterStreamNomeUsuario(String? usuarioId) {
    if (usuarioId == null) return null;

    if (_streamNomeUsuario == null || _usuarioId != usuarioId) {
      _usuarioId = usuarioId;
      _streamNomeUsuario = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuarioId)
          .snapshots()
          .map((documento) => documento.data()?['nome']?.toString());
    }

    return _streamNomeUsuario;
  }

  String _primeiroNome(String? nome) {
    final nomeLimpo = nome?.trim() ?? '';
    if (nomeLimpo.isEmpty) return '';
    return nomeLimpo.split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final streamNomeUsuario = _obterStreamNomeUsuario(authController.usuarioId);

    return GestureDetector(
      onTap: () {
        // Já logado: não faz nada aqui (o perfil completo já está
        // na aba "Perfil" da navegação inferior).
        if (authController.logado) return;

        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      },
      child: StreamBuilder<String?>(
        stream: streamNomeUsuario,
        builder: (context, snapshot) {
          final nome = snapshot.hasError
              ? FirebaseAuth.instance.currentUser?.displayName
              : snapshot.data ?? FirebaseAuth.instance.currentUser?.displayName;
          final primeiroNome = _primeiroNome(nome);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              const CircleAvatar(
                radius: 22,
                child: Icon(Icons.person, size: 28),
              ),
              if (primeiroNome.isNotEmpty) ...[
                const SizedBox(height: 2),
                Text(
                  primeiroNome,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFEF9737),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}