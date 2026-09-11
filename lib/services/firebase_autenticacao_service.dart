import 'package:adota_facil/services/autenticacao_service.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAutenticacaoService implements AutenticacaoService {
  final FirebaseAuth _auth;

  FirebaseAutenticacaoService({FirebaseAuth? auth})
      : _auth = auth ?? FirebaseAuth.instance;

  @override
  String? get uidUsuarioLogado => _auth.currentUser?.uid;
}