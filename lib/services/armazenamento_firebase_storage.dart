import 'dart:io';

import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';

/// Faz upload da foto para o Firebase Storage e guarda a url resultante.
/// Alternativa ao ArmazenamentoBase64 — exige plano pago (Blaze) ativo
/// no projeto Firebase.
class ArmazenamentoFirebaseStorage implements EstrategiaArmazenamentoFoto {
  @override
  Future<ResultadoArmazenamentoFoto> salvar(File arquivo, String petId) async {
    final referencia = FirebaseStorage.instance.ref('pets/$petId.jpg');
    await referencia.putFile(arquivo);
    final String url = await referencia.getDownloadURL();
    return ResultadoArmazenamentoFoto.url(url);
  }
}

class FirebaseStorage {
  static get instance => null;
}