import 'package:cloud_firestore/cloud_firestore.dart';

class UsuarioModel {
  final String id;
  final String nome;
  final String cpf;
  final String email;
  final String? whatsapp;
  final String fotoUrl;
  final String fotoBase64;

  /// 'adotante' | 'anunciante' | 'ambos'
  final String tipo;

  /// 'Protetor Independente' | 'ONG' | 'Abrigo' — só preenchido quando
  /// [tipo] inclui anunciante.
  final String? tipoAnunciante;

  final String estado;
  final String cidade;
  final List<String> favoritos;
  final DateTime? criadoEm;

  final dynamic petsFavoritos;

  const UsuarioModel({
    required this.id,
    required this.nome,
    this.cpf = '',
    required this.email,
    this.whatsapp,
    this.fotoUrl = '',
    required this.tipo,
    this.tipoAnunciante,
    this.estado = '',
    this.cidade = '',
    this.favoritos = const [],
    this.criadoEm,
    this.fotoBase64 = '',
    this.petsFavoritos = const [],
  });

  String? get telefone => whatsapp;

  bool get ehAnunciante => tipo == 'anunciante' || tipo == 'ambos';
  bool get ehAdotante => tipo == 'adotante' || tipo == 'ambos';

  factory UsuarioModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return UsuarioModel(
      id: documentId,
      nome: data['nome'] as String? ?? '',
      email: data['email'] as String? ?? '',
      cpf: data['cpf'] ?? '',
      whatsapp: data['whatsapp'] as String?,
      fotoUrl: data['fotoUrl'] as String? ?? '',
      tipo: data['tipo'] as String? ?? 'adotante',
      tipoAnunciante: data['tipoAnunciante'] as String?,
      estado: data['estado'] as String? ?? '',
      cidade: data['cidade'] as String? ?? '',
      favoritos: List<String>.from(data['favoritos'] as List? ?? const []),
      criadoEm: (data['criadoEm'] as Timestamp?)?.toDate(),
      petsFavoritos: List<String>.from(data['petsFavoritos'] ?? const []),
      fotoBase64: data['fotoBase64'] ?? '',
    );
  }

  factory UsuarioModel.fromMap(String documentId, Map<String, dynamic> data) {
    return UsuarioModel.fromFirestore(data, documentId);
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'cpf': cpf,
      'email': email,
      'whatsapp': whatsapp,
      'fotoUrl': fotoUrl,
      'fotoBase64': fotoBase64,
      'tipo': tipo,
      'tipoAnunciante': tipoAnunciante,
      'estado': estado,
      'cidade': cidade,
      'favoritos': favoritos,
      'petsFavoritos': favoritos,
      'criadoEm': criadoEm != null
          ? Timestamp.fromDate(criadoEm!)
          : FieldValue.serverTimestamp(),
    };
  }

  UsuarioModel copyWith({
    String? nome,
    String? email,
    String? cpf,
    String? whatsapp,
    String? fotoUrl,
    String? fotoBase64,
    String? tipo,
    String? tipoAnunciante,
    String? estado,
    String? cidade,
    List<String>? petsfavoritos,
    List<String>? favoritos,
    DateTime? criadoEm,
  }) {
    return UsuarioModel(
      id: id,
      nome: nome ?? this.nome,
      email: email ?? this.email,
      cpf: cpf ?? this.cpf,
      whatsapp: whatsapp ?? this.whatsapp,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      fotoBase64: fotoBase64 ?? this.fotoBase64,
      tipo: tipo ?? this.tipo,
      tipoAnunciante: tipoAnunciante ?? this.tipoAnunciante,
      estado: estado ?? this.estado,
      cidade: cidade ?? this.cidade,
      favoritos: favoritos ?? this.favoritos,
      petsFavoritos: petsfavoritos ?? this.petsFavoritos,
      criadoEm: criadoEm ?? this.criadoEm,
    );
  }
}
