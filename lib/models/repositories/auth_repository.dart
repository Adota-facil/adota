import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthRepository {
  String? get uidAtual;
  Stream<String?> get mudancasDeUsuario;
  Future<String> cadastrar({required String email, required String senha});
  Future<String> login({required String email, required String senha});
  Future<void> excluirContaAtual();
  Future<void> logout();
}

class AuthRepositoryImpl implements AuthRepository {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  String? get uidAtual => _auth.currentUser?.uid;

  @override
  Stream<String?> get mudancasDeUsuario =>
      _auth.authStateChanges().map((usuario) => usuario?.uid);

  @override
  Future<String> cadastrar({
    required String email,
    required String senha,
  }) async {
    final credencial = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return credencial.user!.uid;
  }

  @override
  Future<String> login({required String email, required String senha}) async {
    final credencial = await _auth.signInWithEmailAndPassword(
      email: email,
      password: senha,
    );
    return credencial.user!.uid;
  }

  @override
  Future<void> excluirContaAtual() async {
    await _auth.currentUser?.delete();
  }

  @override
  Future<void> logout() => _auth.signOut();
}