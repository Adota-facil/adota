import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/models/repositories/auth_repository.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/models/usuario_model.dart';
import 'package:adota_facil/services/armazenamento_base64.dart';
import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';

class FakeAuthRepository implements AuthRepository {
  @override
  String? get uidAtual => 'uid-123';

  @override
  Stream<String?> get mudancasDeUsuario => Stream.value(uidAtual);

  @override
  Future<String> cadastrar({required String email, required String senha}) async =>
      'uid-123';

  @override
  Future<String> login({required String email, required String senha}) async =>
      'uid-123';

  @override
  Future<UserCredential> loginComGoogle() async {
    throw UnimplementedError();
  }

  @override
  Future<void> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {}

  @override
  Future<void> logout() async {}

  @override
  Future<void> excluirConta({required String senha}) async {}
}

class FakeUsuarioRepository implements UsuarioRepository {
  UsuarioModel? salvo;

  @override
  Future<UsuarioModel?> buscarPorId(String id) async => null;

  @override
  Future<void> salvar(UsuarioModel usuario) async {
    salvo = usuario;
  }

  @override
  Future<void> adicionarFavorito(String usuarioId, String petId) async {}

  @override
  Future<void> removerFavorito(String usuarioId, String petId) async {}

  @override
  Future<void> deletar(String id) async {}

  @override
  Stream<UsuarioModel?> observarUsuario(String id) => Stream.value(null);
}

class _StorageQueFalha implements EstrategiaArmazenamentoFoto {
  @override
  Future<ResultadoArmazenamentoFoto> salvar(
    File arquivo,
    String id, {
    String pasta = 'pets',
  }) async {
    throw const SocketException('upload falhou');
  }
}

void main() {
  test('deve salvar fotoBase64 no cadastro do usuário', () async {
    final authRepo = FakeAuthRepository();
    final usuarioRepo = FakeUsuarioRepository();
    final controller = AuthController(authRepo, usuarioRepo);

    final sucesso = await controller.cadastrar(
      nome: 'Maria',
      email: 'maria@email.com',
      senha: '123456',
      tipo: 'adotante',
      fotoBase64: 'abc123',
    );

    expect(sucesso, isTrue);
    expect(usuarioRepo.salvo, isNotNull);
    expect(usuarioRepo.salvo!.fotoBase64, 'abc123');
  });

  test('deve usar fallback em base64 quando o storage principal falha', () async {
    final arquivo = File('${Directory.systemTemp.path}/foto_fallback_test.jpg');
    await arquivo.writeAsBytes(utf8.encode('imagem de teste'));

    addTearDown(() async {
      if (await arquivo.exists()) {
        await arquivo.delete();
      }
    });

    final resultado = await EstrategiaArmazenamentoFotoHelper.salvarComFallback(
      _StorageQueFalha(),
      arquivo,
      'usuario-123',
      fallback: ArmazenamentoBase64(),
      pasta: 'usuarios',
    );

    expect(resultado.url, isNull);
    expect(resultado.base64, isNotNull);
    expect(resultado.base64, isNotEmpty);
  });
}
