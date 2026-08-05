import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PetModel {
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

  IconData get iconeGenero {
    return genero.toLowerCase() == 'fêmea' || genero.toLowerCase() == 'femea'
        ? Icons.female
        : Icons.male;
  }

  Color get corGenero {
    return genero.toLowerCase() == 'fêmea' || genero.toLowerCase() == 'femea'
        ? Colors.pink
        : Colors.blue;
  }

  List<String> get tagsSaude => statusSaude
      .split(',')
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toList();

  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      statusSaude: json['statusSaude'] ?? '',
      idade: json['idade'] ?? '',
      porte: json['porte'] ?? '',
      genero: json['genero'] ?? 'macho',
      fotoUrl: json['fotoUrl'] ?? '',
      adotado: json['adotado'] ?? false,
      criadoEm: json['criadoEm'] != null
          ? DateTime.tryParse(json['criadoEm'].toString())
          : null,
      raca: json['raca'] ?? '',
      descricao: json['descricao'] ?? '',
      localizacao: json['localizacao'] ?? '',
      fotos: List<String>.from(json['fotos'] ?? const []),
      fotoBase64: json['fotoBase64'] ?? '',
      fotosBase64: List<String>.from(json['fotosBase64'] ?? const []),
    );
  }

  factory PetModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return PetModel(
      id: documentId,
      nome: data['nome'] ?? '',
      especie: data['especie'] ?? '',
      statusSaude: data['statusSaude'] ?? '',
      idade: data['idade'] ?? '',
      porte: data['porte'] ?? '',
      genero: data['genero'] ?? 'macho',
      fotoUrl: data['fotoUrl'] ?? '',
      adotado: data['adotado'] ?? false,
      criadoEm: data['criadoEm'] != null
          ? (data['criadoEm'] as Timestamp).toDate()
          : null,
      raca: data['raca'] ?? '',
      descricao: data['descricao'] ?? '',
      localizacao: data['localizacao'] ?? '',
      fotos: List<String>.from(data['fotos'] ?? const []),
      fotoBase64: data['fotoBase64'] ?? '',
      fotosBase64: List<String>.from(data['fotosBase64'] ?? const []),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'statusSaude': statusSaude,
      'idade': idade,
      'porte': porte,
      'genero': genero,
      'fotoUrl': fotoUrl,
      'adotado': adotado,
      'criadoEm': criadoEm?.toIso8601String(),
      'raca': raca,
      'descricao': descricao,
      'localizacao': localizacao,
      'fotos': fotos,
      'fotoBase64': fotoBase64,
      'fotosBase64': fotosBase64,
    };
  }
  
  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'especie': especie,
      'statusSaude': statusSaude,
      'idade': idade,
      'porte': porte,
      'genero': genero,
      'fotoUrl': fotoUrl,
      'adotado': adotado,
      'criadoEm': criadoEm != null
          ? Timestamp.fromDate(criadoEm!)
          : FieldValue.serverTimestamp(),
      'raca': raca,
      'descricao': descricao,
      'localizacao': localizacao,
      'fotos': fotos,
      'fotoBase64': fotoBase64,
      'fotosBase64': fotosBase64,
    };
  }
}
