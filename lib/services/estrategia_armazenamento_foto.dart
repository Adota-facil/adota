import 'dart:io';

abstract class EstrategiaArmazenamentoFoto {
  /// Recebe o arquivo de imagem e devolve o que precisa ser salvo no PetModel.
  Future<ResultadoArmazenamentoFoto> salvar(File arquivo, String petId);
}

/// Carrega OU uma url (Storage) OU um base64 (Firestore), nunca os dois.
class ResultadoArmazenamentoFoto {
  final String? url;
  final String? base64;

  const ResultadoArmazenamentoFoto.url(this.url) : base64 = null;
  const ResultadoArmazenamentoFoto.base64(this.base64) : url = null;
}