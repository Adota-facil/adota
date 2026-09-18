import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

abstract class AuthRepository {
  String? get uidAtual;
  Stream<String?> get mudancasDeUsuario;
  Future<String> cadastrar({required String email, required String senha});
  Future<String> login({required String email, required String senha});
  Future<UserCredential> loginComGoogle();
  Future<void> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  });
  Future<void> logout();
  Future<void> excluirConta({required String senha});
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
  Future<UserCredential> loginComGoogle() async {
    final provedor = GoogleAuthProvider();
    if (kIsWeb) {
      return _auth.signInWithPopup(provedor);
    }

    final googleSignIn = GoogleSignIn.instance;
    await googleSignIn.initialize();
    final contaGoogle = await googleSignIn.authenticate();
    final autenticacaoGoogle = contaGoogle.authentication;
    final credencial = GoogleAuthProvider.credential(
      idToken: autenticacaoGoogle.idToken,
    );
    return _auth.signInWithCredential(credencial);
  }

  @override
  Future<void> alterarSenha({
    required String senhaAtual,
    required String novaSenha,
  }) async {
    final usuario = _auth.currentUser;
    final email = usuario?.email;
    if (usuario == null || email == null || email.isEmpty) {
      throw FirebaseAuthException(code: 'operation-not-allowed');
    }

    final credencial = EmailAuthProvider.credential(
      email: email,
      password: senhaAtual,
    );
    await usuario.reauthenticateWithCredential(credencial);
    await usuario.updatePassword(novaSenha);
  }

  @override
  Future<void> logout() => _auth.signOut();

  @override
  Future<void> excluirConta({required String senha}) async {
    final usuario = _auth.currentUser;
    final email = usuario?.email;
    if (usuario == null || email == null || email.isEmpty) {
      throw FirebaseAuthException(code: 'operation-not-allowed');
    }

    final credencial = EmailAuthProvider.credential(
      email: email,
      password: senha,
    );
    await usuario.reauthenticateWithCredential(credencial);
    await usuario.delete();
  }
}