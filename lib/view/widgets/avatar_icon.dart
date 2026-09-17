import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/view/pages/login_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AvatarButton extends StatelessWidget {
  const AvatarButton({super.key});

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();

    return GestureDetector(
      onTap: () {
        // Já logado: não faz nada aqui (o perfil completo já está
        // na aba "Perfil" da navegação inferior).
        if (authController.logado) return;

        Navigator.of(context).push(
          MaterialPageRoute(builder: (_) => const LoginView()),
        );
      },
      child: const CircleAvatar(
        radius: 22,
        child: Icon(Icons.person, size: 28),
      ),
    );
  }
}