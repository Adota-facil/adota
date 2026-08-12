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

  /// Foto principal codificada em Base64, guardada direto no documento
  /// do Firestore (alternativa ao Storage, que exige plano pago).
  final String fotoBase64;

  /// Fotos adicionais em Base64 (mesma ideia de [fotoBase64]).
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

  // Getter para formatar as informações exibidas nos cards
  String get informacoesFormatadas =>
      '$especie • $statusSaude\n$idade • $porte';

  /// Centraliza a checagem de gênero. Antes, `iconeGenero` e `corGenero`
  /// repetiam a mesma condição cada um — se um dia precisar aceitar mais
  /// uma variação de texto (ex: "F"), só muda aqui.
  bool get _ehFemea =>
      genero.toLowerCase() == 'fêmea' || genero.toLowerCase() == 'femea';

  // Ícone dinâmico com base no gênero
  IconData get iconeGenero => _ehFemea ? Icons.female : Icons.male;

  // Cor dinâmica com base no gênero
  Color get corGenero => _ehFemea ? Colors.pink : Colors.blue;

  // Lista de tags a partir de statusSaude (ex: "Castrado, Vacinado")
  List<String> get tagsSaude => statusSaude
      .split(',')
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toList();

  /// Monta o objeto a partir de um Map genérico, usado tanto por
  /// [fromJson] quanto por [fromFirestore]. Antes, os dois construíam o
  /// PetModel campo a campo de forma independente — um campo novo exigia
  /// lembrar de atualizar os dois lugares, e era fácil esquecer um.
  /// [id] e [criadoEm] variam por origem (JSON usa string, Firestore usa
  /// Timestamp), por isso continuam sendo resolvidos por fora e passados
  /// prontos.
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
      genero: data['genero'] ?? 'macho',
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

  // Converte JSON vindo de uma API para o modelo
  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel._fromMap(
      json,
      id: json['id'] ?? '',
      criadoEm: json['criadoEm'] != null
          ? DateTime.tryParse(json['criadoEm'].toString())
          : null,
    );
  }

  // Converte um documento do Firestore para o modelo
  factory PetModel.fromFirestore(Map<String, dynamic> data, String documentId) {
    return PetModel._fromMap(
      data,
      id: documentId,
      criadoEm: data['criadoEm'] != null
          ? (data['criadoEm'] as Timestamp).toDate()
          : null,
    );
  }

  // Converte o objeto para Map/JSON (uso genérico, ex: API REST)
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

  // Converte o objeto para Map compatível com o Firestore
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