import 'dart:convert';
import 'dart:io';

import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';

class ArmazenamentoBase64 implements EstrategiaArmazenamentoFoto {
  @override
  Future<ResultadoArmazenamentoFoto> salvar(File arquivo, String petId) async {
    final bytes = await arquivo.readAsBytes();
    return ResultadoArmazenamentoFoto.base64(base64Encode(bytes));
  }
}