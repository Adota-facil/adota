import 'dart:io';

import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';
import 'package:firebase_storage/firebase_storage.dart';

class ArmazenamentoFirebaseStorage implements EstrategiaArmazenamentoFoto {
  @override
  Future<ResultadoArmazenamentoFoto> salvar(File arquivo, String petId) async {
    final referencia = FirebaseStorage.instance.ref('pets/$petId.jpg');
    await referencia.putFile(arquivo);
    final String url = await referencia.getDownloadURL();
    return ResultadoArmazenamentoFoto.url(url);
  }
}