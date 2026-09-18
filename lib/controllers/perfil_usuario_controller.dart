import 'dart:io';
import 'dart:typed_data';

import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/models/usuario_model.dart';
import 'package:adota_facil/services/armazenamento_base64.dart';
import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';
import 'package:adota_facil/view/widgets/ajuste_foto_widget.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

class PerfilUsuarioController extends ChangeNotifier {
  final AuthController _authController;
  final UsuarioRepository _usuarioRepository;
  final EstrategiaArmazenamentoFoto _estrategiaFoto;

  PerfilUsuarioController(
    this._authController,
    this._usuarioRepository,
    this._estrategiaFoto,
  );

  bool _carregandoFoto = false;
  bool get carregandoFoto => _carregandoFoto;

  Future<void> editarFotoPerfil(
    BuildContext context,
    UsuarioModel usuarioAtual,
  ) async {
    final usuarioId = _authController.usuarioId;
    if (usuarioId == null) return;

    final arquivoEscolhido =
        await ImagePicker().pickImage(source: ImageSource.gallery);
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
      final arquivoTemporario =
          await _bytesParaArquivoTemporario(bytesAjustados, usuarioId);
      final resultado = await EstrategiaArmazenamentoFotoHelper.salvarComFallback(
        _estrategiaFoto,
        arquivoTemporario,
        usuarioId,
        fallback: ArmazenamentoBase64(),
        pasta: 'usuarios',
      );

      final atualizado = usuarioAtual.copyWith(
        fotoUrl: resultado.url ?? '',
        fotoBase64: resultado.base64 ?? '',
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

  Future<File> _bytesParaArquivoTemporario(Uint8List bytes, String id) async {
    final diretorio = await getTemporaryDirectory();
    final arquivo = File('${diretorio.path}/perfil_$id.jpg');
    return arquivo.writeAsBytes(bytes);
  }

  Future<void> sairDaConta(BuildContext context) async {
    await _authController.logout();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sessão encerrada com sucesso.')),
    );
  }
}