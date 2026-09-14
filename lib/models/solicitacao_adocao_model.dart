import 'package:cloud_firestore/cloud_firestore.dart';

enum StatusSolicitacao {
  pendente,
  aprovada,
  recusada,
  cancelada;

  static StatusSolicitacao fromValor(String valor) {
    return StatusSolicitacao.values.firstWhere(
      (status) => status.name == valor,
      orElse: () => StatusSolicitacao.pendente,
    );
  }
}

class SolicitacaoAdocaoModel {
  final String id;
  final String petId;
  final String adotanteId;
  final String anuncianteId;
  final StatusSolicitacao status;
  final String mensagem;
  final DateTime? criadoEm;
  final DateTime? atualizadoEm;

  const SolicitacaoAdocaoModel({
    required this.id,
    required this.petId,
    required this.adotanteId,
    required this.anuncianteId,
    this.status = StatusSolicitacao.pendente,
    this.mensagem = '',
    this.criadoEm,
    this.atualizadoEm,
  });

  factory SolicitacaoAdocaoModel.fromMap(String id, Map<String, dynamic> map) {
    return SolicitacaoAdocaoModel(
      id: id,
      petId: map['petId'] as String? ?? '',
      adotanteId: map['adotanteId'] as String? ?? '',
      anuncianteId: map['anuncianteId'] as String? ?? '',
      status: StatusSolicitacao.fromValor(
        map['status'] as String? ?? 'pendente',
      ),
      mensagem: map['mensagem'] as String? ?? '',
      criadoEm: (map['criadoEm'] as Timestamp?)?.toDate(),
      atualizadoEm: (map['atualizadoEm'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'petId': petId,
      'adotanteId': adotanteId,
      'anuncianteId': anuncianteId,
      'status': status.name,
      'mensagem': mensagem,
      'criadoEm': criadoEm != null
          ? Timestamp.fromDate(criadoEm!)
          : FieldValue.serverTimestamp(),
      'atualizadoEm':
          atualizadoEm != null ? Timestamp.fromDate(atualizadoEm!) : null,
    };
  }

  SolicitacaoAdocaoModel copyWith({
    StatusSolicitacao? status,
    String? mensagem,
    DateTime? atualizadoEm,
  }) {
    return SolicitacaoAdocaoModel(
      id: id,
      petId: petId,
      adotanteId: adotanteId,
      anuncianteId: anuncianteId,
      status: status ?? this.status,
      mensagem: mensagem ?? this.mensagem,
      criadoEm: criadoEm,
      atualizadoEm: atualizadoEm ?? this.atualizadoEm,
    );
  }
}