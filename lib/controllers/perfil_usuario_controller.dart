import 'dart:convert';
import 'dart:typed_data';

import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/models/usuario_model.dart';
import 'package:adota_facil/view/widgets/ajuste_foto_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class PerfilUsuarioController extends ChangeNotifier {
  final AuthController _authController;
  final UsuarioRepository _usuarioRepository;

  PerfilUsuarioController(this._authController, this._usuarioRepository);

  bool _carregandoFoto = false;
  bool get carregandoFoto => _carregandoFoto;

  Future<void> editarFotoPerfil(
    BuildContext context,
    UsuarioModel usuarioAtual,
  ) async {
    final usuarioId = _authController.usuarioId;
    if (usuarioId == null) return;

    final arquivoEscolhido = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (arquivoEscolhido == null) return;

    final bytesOriginais = await arquivoEscolhido.readAsBytes();
    if (!context.mounted) return;

    final bytesAjustados = await Navigator.of(context).push<Uint8List>(
      MaterialPageRoute(builder: (_) => AjusteFoto(imageBytes: bytesOriginais)),
    );
    if (bytesAjustados == null) return;

    _carregandoFoto = true;
    notifyListeners();
    try {
      final atualizado = usuarioAtual.copyWith(
        fotoUrl: '',
        fotoBase64: base64Encode(bytesAjustados),
      );
      await _usuarioRepository.salvar(atualizado);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Foto de perfil atualizada!')),
        );
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Não foi possível salvar a foto.')),
        );
      }
    } finally {
      _carregandoFoto = false;
      notifyListeners();
    }
  }

  Future<void> sairDaConta(BuildContext context) async {
    await _authController.logout();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sessão encerrada com sucesso.')),
    );
  }
}
