import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {

  static const String _generoPadrao = 'macho';

  final String id;
  final String nome;
  final String especie;
  final String statusSaude;
  final String idade;
  final String porte;
  final String genero;
  final String fotoUrl;
  final bool adotado;
  final DateTime? criadoEm;
  final String raca;
  final String descricao;
  final String localizacao;
  final List<String> fotos;

  final String fotoBase64;

  final List<String> fotosBase64;

  const PetModel({
    required this.id,
    required this.nome,
    required this.especie,
    required this.statusSaude,
    required this.idade,
    required this.porte,
    required this.genero,
    this.fotoUrl = '',
    this.adotado = false,
    this.criadoEm,
    this.raca = '',
    this.descricao = '',
    this.localizacao = '',
    this.fotos = const [],
    this.fotoBase64 = '',
    this.fotosBase64 = const [],
  });

  String get informacoesFormatadas =>
      '$especie • $statusSaude\n$idade • $porte';

  static String montarStatusSaude({
    required bool castrado,
    required bool vacinado,
  }) {
    return [
      if (castrado) 'Castrado',
      if (vacinado) 'Vacinado',
    ].join(', ');
  }

  bool get _ehFemea =>
      genero.toLowerCase() == 'fêmea' || genero.toLowerCase() == 'femea';

  IconData get iconeGenero => _ehFemea ? Icons.female : Icons.male;

  Color get corGenero => _ehFemea ? Colors.pink : Colors.blue;

  List<String> get tagsSaude => statusSaude
      .split(',')
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toList();

  factory PetModel._fromMap(
    Map<String, dynamic> data, {
    required String id,
    required DateTime? criadoEm,
  }) {
    return PetModel(
      id: id,
      nome: data['nome'] ?? '',
      especie: data['especie'] ?? '',
      statusSaude: data['statusSaude'] ?? '',
      idade: data['idade'] ?? '',
      porte: data['porte'] ?? '',
      genero: data['genero'] ?? _generoPadrao,
      fotoUrl: data['fotoUrl'] ?? '',
      adotado: data['adotado'] ?? false,
      criadoEm: criadoEm,
      raca: data['raca'] ?? '',
      descricao: data['descricao'] ?? '',
      localizacao: data['localizacao'] ?? '',
      fotos: List<String>.from(data['fotos'] ?? const []),
      fotoBase64: data['fotoBase64'] ?? '',
      fotosBase64: List<String>.from(data['fotosBase64'] ?? const []),
    );
  }

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel._fromMap(
      json,
      id: json['id'] ?? '',
      criadoEm: json['criadoEm'] != null
          ? DateTime.tryParse(json['criadoEm'].toString())
          : null,
    );
  }

  factory PetModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return PetModel._fromMap(
      data,
      id: documentId,
      criadoEm: data['criadoEm'] != null
          ? (data['criadoEm'] as Timestamp).toDate()
          : null,
    );
  }

  Map<String, dynamic> get _camposComuns => {
        'nome': nome,
        'especie': especie,
        'statusSaude': statusSaude,
        'idade': idade,
        'porte': porte,
        'genero': genero,
        'fotoUrl': fotoUrl,
        'adotado': adotado,
        'raca': raca,
        'descricao': descricao,
        'localizacao': localizacao,
        'fotos': fotos,
        'fotoBase64': fotoBase64,
        'fotosBase64': fotosBase64,
      };

  Map<String, dynamic> toJson() => {
        'id': id,
        ..._camposComuns,
        'criadoEm': criadoEm?.toIso8601String(),
      };

  Map<String, dynamic> toFirestore() => {
        ..._camposComuns,
        'criadoEm': criadoEm != null
            ? Timestamp.fromDate(criadoEm!)
            : FieldValue.serverTimestamp(),
      };

  PetModel copyWith({
    String? id,
    String? nome,
    String? especie,
    String? statusSaude,
    String? idade,
    String? porte,
    String? genero,
    String? fotoUrl,
    bool? adotado,
    DateTime? criadoEm,
    String? raca,
    String? descricao,
    String? localizacao,
    List<String>? fotos,
    String? fotoBase64,
    List<String>? fotosBase64,
  }) {
    return PetModel(
      id: id ?? this.id,
      nome: nome ?? this.nome,
      especie: especie ?? this.especie,
      statusSaude: statusSaude ?? this.statusSaude,
      idade: idade ?? this.idade,
      porte: porte ?? this.porte,
      genero: genero ?? this.genero,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      adotado: adotado ?? this.adotado,
      criadoEm: criadoEm ?? this.criadoEm,
      raca: raca ?? this.raca,
      descricao: descricao ?? this.descricao,
      localizacao: localizacao ?? this.localizacao,
      fotos: fotos ?? this.fotos,
      fotoBase64: fotoBase64 ?? this.fotoBase64,
      fotosBase64: fotosBase64 ?? this.fotosBase64,
    );
  }
}