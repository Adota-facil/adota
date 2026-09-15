import 'dart:io';
import 'dart:typed_data';

import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/models/usuario_model.dart';
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
  ) {
    _authController.addListener(_aoMudarAuth);
    _carregar();
  }

  UsuarioModel? _usuario;
  bool _carregando = false;
  bool _carregandoFoto = false;

  bool get logado => _authController.logado;
  bool get carregando => _carregando;
  bool get carregandoFoto => _carregandoFoto;

  String get nomeExibicao => _usuario?.nome ?? '';
  String get tempoMembro =>
      _usuario?.criadoEm != null ? 'Membro desde ${_usuario!.criadoEm!.year}' : '';
  String get nomeCompleto => _usuario?.nome ?? '-';
  String get email => _usuario?.email ?? '-';
  String get whatsapp =>
      (_usuario?.telefone != null && _usuario!.telefone!.isNotEmpty)
          ? _usuario!.telefone!
          : '-';
  String get estado => (_usuario?.estado.isNotEmpty ?? false) ? _usuario!.estado : '-';
  String get cidade => (_usuario?.cidade.isNotEmpty ?? false) ? _usuario!.cidade : '-';
  bool get ehAnunciante => _usuario?.ehAnunciante ?? false;

  String get fotoUrl => _usuario?.fotoUrl ?? '';
  String get fotoBase64 => _usuario?.fotoBase64 ?? '';
  bool get temFoto => fotoUrl.isNotEmpty || fotoBase64.isNotEmpty;

  void _aoMudarAuth() => _carregar();

  Future<void> _carregar() async {
    if (!_authController.logado) {
      _usuario = null;
      notifyListeners();
      return;
    }
    _carregando = true;
    notifyListeners();
    try {
      _usuario = await _usuarioRepository.buscarPorId(_authController.usuarioId!);
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  /// Escolhe uma foto da galeria, recorta (reaproveitando a tela
  /// AjusteFoto já usada pros pets), salva via EstrategiaArmazenamentoFoto
  /// e atualiza o documento do usuário.
  Future<void> editarFotoPerfil(BuildContext context) async {
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
    if (bytesAjustados == null) return; // usuário cancelou o corte

    _carregandoFoto = true;
    notifyListeners();
    try {
      final arquivoTemporario =
          await _bytesParaArquivoTemporario(bytesAjustados, usuarioId);
      final resultado = await _estrategiaFoto.salvar(arquivoTemporario, usuarioId);

      final base = _usuario ??
          UsuarioModel(
            id: usuarioId,
            nome: '',
            email: '',
            tipo: 'adotante',
          );
      final atualizado = base.copyWith(
        fotoUrl: resultado.url,
        fotoBase64: resultado.base64,
      );
      await _usuarioRepository.salvar(atualizado);
      _usuario = atualizado;

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

  // Regra de negócio: Realiza o Logout do aplicativo
  Future<void> sairDaConta(BuildContext context) async {
    await _authController.logout();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sessão encerrada com sucesso.')),
    );
  }

  @override
  void dispose() {
    _authController.removeListener(_aoMudarAuth);
    super.dispose();
  }
}