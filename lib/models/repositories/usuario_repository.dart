import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:adota_facil/models/usuario_model.dart';

abstract class UsuarioReader {
  Future<UsuarioModel> buscarPorId(String uid);
  Future<UsuarioModel?> buscarUsuarioLogado();
}

abstract class UsuarioWriter {
  /// Cria o usuário no Firebase Auth (email/senha) e, em seguida, o
  /// documento correspondente em `usuarios/{uid}`. Se a criação no
  /// Firestore falhar, o usuário do Auth é removido para não deixar
  /// um cadastro "pela metade".
  Future<UsuarioModel> cadastrarUsuario({
    required String nome,
    required String cpf,
    required String email,
    required String senha,
    String whatsapp,
    String cidade,
    String estado,
  });

  Future<void> atualizarDados(UsuarioModel usuario);

  Future<void> favoritarPet(String uid, String petId);
  Future<void> desfavoritarPet(String uid, String petId);
}

abstract class UsuarioRepository implements UsuarioReader, UsuarioWriter {}

class UsuarioRepositoryImpl implements UsuarioRepository {
  final FirebaseFirestore _firestore;
  final FirebaseAuth _auth;
  static const String _colecao = 'usuarios';

  UsuarioRepositoryImpl({FirebaseFirestore? firestore, FirebaseAuth? auth})
      : _firestore = firestore ?? FirebaseFirestore.instance,
        _auth = auth ?? FirebaseAuth.instance;

  DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      _firestore.collection(_colecao).doc(uid);

  @override
  Future<UsuarioModel> buscarPorId(String uid) async {
    final doc = await _doc(uid).get();
    if (!doc.exists) {
      throw Exception('Usuário não encontrado: $uid');
    }
    return UsuarioModel.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Future<UsuarioModel?> buscarUsuarioLogado() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return null;
    return buscarPorId(uid);
  }

  @override
  Future<UsuarioModel> cadastrarUsuario({
    required String nome,
    required String cpf,
    required String email,
    required String senha,
    String whatsapp = '',
    String cidade = '',
    String estado = '',
  }) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );

    final uid = credencial.user!.uid;
    final usuario = UsuarioModel(
      id: uid,
      nome: nome,
      cpf: cpf,
      email: email,
      whatsapp: whatsapp,
      cidade: cidade,
      estado: estado,
    );

    try {
      await _doc(uid).set(usuario.toFirestore());
      return usuario;
    } catch (e) {
      // Evita deixar um usuário "órfão" no Auth sem documento no Firestore.
      await credencial.user!.delete();
      rethrow;
    }
  }

  @override
  Future<void> atualizarDados(UsuarioModel usuario) async {
    await _doc(usuario.id).update(usuario.toFirestore());
  }

  @override
  Future<void> favoritarPet(String uid, String petId) async {
    await _doc(uid).update({
      'petsFavoritos': FieldValue.arrayUnion([petId]),
    });
  }

  @override
  Future<void> desfavoritarPet(String uid, String petId) async {
    await _doc(uid).update({
      'petsFavoritos': FieldValue.arrayRemove([petId]),
    });
  }
}