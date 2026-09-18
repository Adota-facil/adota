import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/models/usuario_model.dart';
import 'package:adota_facil/view/pages/login_view.dart';
import 'package:adota_facil/view/widgets/pet_image_widget.dart';
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
  Stream<UsuarioModel?>? _streamUsuario;
  String? _usuarioId;

  Stream<UsuarioModel?>? _obterStreamUsuario(String? usuarioId) {
    if (usuarioId == null) return null;

    if (_streamUsuario == null || _usuarioId != usuarioId) {
      _usuarioId = usuarioId;
      _streamUsuario = FirebaseFirestore.instance
          .collection('usuarios')
          .doc(usuarioId)
          .snapshots()
          .map((documento) {
            final dados = documento.data();
            if (dados == null) return null;
            return UsuarioModel.fromMap(documento.id, dados);
          });
    }

    return _streamUsuario;
  }

  String _primeiroNome(String? nome) {
    final nomeLimpo = nome?.trim() ?? '';
    if (nomeLimpo.isEmpty) return '';
    return nomeLimpo.split(RegExp(r'\s+')).first;
  }

  @override
  Widget build(BuildContext context) {
    final authController = context.watch<AuthController>();
    final streamUsuario = _obterStreamUsuario(authController.usuarioId);

    return GestureDetector(
      onTap: () {
        if (authController.logado) return;

        Navigator.of(
          context,
        ).push(MaterialPageRoute(builder: (_) => const LoginView()));
      },
      child: StreamBuilder<UsuarioModel?>(
        stream: streamUsuario,
        builder: (context, snapshot) {
          final usuario = snapshot.data;
          final nome = snapshot.hasError
              ? FirebaseAuth.instance.currentUser?.displayName
              : usuario?.nome ?? FirebaseAuth.instance.currentUser?.displayName;
          final primeiroNome = _primeiroNome(nome);

          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipOval(
                child: SizedBox(
                  width: 44,
                  height: 44,
                  child: usuario == null
                      ? const CircleAvatar(child: Icon(Icons.person, size: 28))
                      : PetImageWidget(
                          fotoBase64: usuario.fotoBase64,
                          fotoUrl: usuario.fotoUrl,
                          fit: BoxFit.cover,
                        ),
                ),
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
