import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  final String id;
  final String nome;
  final String email;
  final String? telefone;
  final String fotoUrl;
  final String fotoBase64;

  final String tipo;

  final String? tipoAnunciante;

  final String estado;
  final String cidade;
  final List<String> favoritos;
  final DateTime? criadoEm;

  const UsuarioModel({
    required this.id,
    required this.nome,
    required this.email,
    this.telefone,
    this.fotoUrl = '',
    this.fotoBase64 = '',
    required this.tipo,
    this.tipoAnunciante,
    this.estado = '',
    this.cidade = '',
    this.favoritos = const [],
    this.criadoEm,
  });

  bool get ehAnunciante => tipo == 'anunciante' || tipo == 'ambos';
  bool get ehAdotante => tipo == 'adotante' || tipo == 'ambos';

  factory UsuarioModel.fromMap(String id, Map<String, dynamic> map) {
    return UsuarioModel(
      id: id,
      nome: map['nome'] as String? ?? '',
      email: map['email'] as String? ?? '',
      telefone: map['telefone'] as String?,
      fotoUrl: map['fotoUrl'] as String? ?? '',
      fotoBase64: map['fotoBase64'] as String? ?? '',
      tipo: map['tipo'] as String? ?? 'adotante',
      tipoAnunciante: map['tipoAnunciante'] as String?,
      estado: map['estado'] as String? ?? '',
      cidade: map['cidade'] as String? ?? '',
      favoritos: List<String>.from(map['favoritos'] as List? ?? const []),
      criadoEm: (map['criadoEm'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'email': email,
      'telefone': telefone,
      'fotoUrl': fotoUrl,
      'fotoBase64': fotoBase64,
      'tipo': tipo,
      'tipoAnunciante': tipoAnunciante,
      'estado': estado,
      'cidade': cidade,
      'favoritos': favoritos,
      'criadoEm': criadoEm != null
          ? Timestamp.fromDate(criadoEm!)
          : FieldValue.serverTimestamp(),
    };
  }

  UsuarioModel copyWith({
    String? nome,
    String? email,
    String? telefone,
    String? fotoUrl,
    String? fotoBase64,
    String? tipo,
    String? tipoAnunciante,
    String? estado,
    String? cidade,
    List<String>? favoritos,
    DateTime? criadoEm,
  }) {
    return UsuarioModel(
      id: id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      telefone: telefone ?? this.telefone,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      fotoBase64: fotoBase64 ?? this.fotoBase64,
      tipo: tipo ?? this.tipo,
      tipoAnunciante: tipoAnunciante ?? this.tipoAnunciante,
      estado: estado ?? this.estado,
      cidade: cidade ?? this.cidade,
      favoritos: favoritos ?? this.favoritos,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}