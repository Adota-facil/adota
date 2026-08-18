import 'dart:io';

class ResultadoArmazenamentoFoto {
  final String? url;
  final String? base64;

  const ResultadoArmazenamentoFoto._(this.url, this.base64)
      : assert(
          (url != null) != (base64 != null),
          'Informe url OU base64 — nunca os dois, nunca nenhum.',
        );

  factory ResultadoArmazenamentoFoto.url(String url) =>
      ResultadoArmazenamentoFoto._(url, null);

  factory ResultadoArmazenamentoFoto.base64(String base64) =>
      ResultadoArmazenamentoFoto._(null, base64);
}

abstract class EstrategiaArmazenamentoFoto {
  Future<ResultadoArmazenamentoFoto> salvar(File arquivo, String petId);
}