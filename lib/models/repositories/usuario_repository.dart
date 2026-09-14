import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adota_facil/models/usuario_model.dart';

/// [ISP/DIP] Mesma ideia do AnimalRepository: o controller que for
/// consumir isso conhece só o contrato, nunca o Firestore diretamente.
abstract class UsuarioRepository {
  Future<UsuarioModel?> buscarPorId(String id);
  Future<void> salvar(UsuarioModel usuario);
  Future<void> adicionarFavorito(String usuarioId, String petId);
  Future<void> removerFavorito(String usuarioId, String petId);
  Future<void> deletar(String id);

  /// Stream em tempo real — útil pra tela de favoritos refletir
  /// mudanças na hora, sem precisar recarregar manualmente.
  Stream<UsuarioModel?> observarUsuario(String id);
}

class UsuarioRepositoryImpl implements UsuarioRepository {
  final CollectionReference<Map<String, dynamic>> _colecao =
      FirebaseFirestore.instance.collection('usuarios');

  @override
  Future<UsuarioModel?> buscarPorId(String id) async {
    final doc = await _colecao.doc(id).get();
    if (!doc.exists) return null;
    return UsuarioModel.fromMap(doc.id, doc.data()!);
  }

  @override
  Future<void> salvar(UsuarioModel usuario) {
    // merge: true -> funciona tanto pra criar quanto pra atualizar,
    // sem sobrescrever campos que não foram passados.
    return _colecao
        .doc(usuario.id)
        .set(usuario.toMap(), SetOptions(merge: true));
  }

  @override
  Future<void> adicionarFavorito(String usuarioId, String petId) {
    return _colecao.doc(usuarioId).update({
      'favoritos': FieldValue.arrayUnion([petId]),
    });
  }

  @override
  Future<void> removerFavorito(String usuarioId, String petId) {
    return _colecao.doc(usuarioId).update({
      'favoritos': FieldValue.arrayRemove([petId]),
    });
  }

  @override
  Future<void> deletar(String id) {
    return _colecao.doc(id).delete();
  }

  @override
  Stream<UsuarioModel?> observarUsuario(String id) {
    return _colecao.doc(id).snapshots().map((doc) {
      if (!doc.exists) return null;
      return UsuarioModel.fromMap(doc.id, doc.data()!);
    });
  }
}