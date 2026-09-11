import 'package:cloud_firestore/cloud_firestore.dart';

/// Representa o documento em `usuarios/{uid}`.
///
/// O [id] deste model é sempre o UID do Firebase Authentication — nunca
/// é gerado pelo Firestore (diferente do PetModel). Isso evita ter que
/// guardar/buscar por email: quem precisa do usuário logado já tem o uid
/// via `FirebaseAuth.instance.currentUser!.uid`.
class UsuarioModel {
  final String id; // uid do Firebase Auth
  final String nome;
  final String cpf;
  final String email;
  final String whatsapp;
  final String cidade;
  final String estado;
  final String fotoUrl;
  final String fotoBase64;
  final DateTime? criadoEm;

  /// IDs dos pets favoritados/marcados para adoção por este usuário.
  /// Um array no próprio documento é suficiente para o volume esperado
  /// (dezenas de favoritos); se crescer muito, migrar para subcoleção
  /// `usuarios/{uid}/favoritos/{petId}`.
  final List<String> petsFavoritos;

  const UsuarioModel({
    required this.id,
    required this.nome,
    required this.cpf,
    required this.email,
    this.whatsapp = '',
    this.cidade = '',
    this.estado = '',
    this.fotoUrl = '',
    this.fotoBase64 = '',
    this.criadoEm,
    this.petsFavoritos = const [],
  });

  factory UsuarioModel.fromFirestore(
    Map<String, dynamic> data,
    String documentId,
  ) {
    return UsuarioModel(
      id: documentId,
      nome: data['nome'] ?? '',
      cpf: data['cpf'] ?? '',
      email: data['email'] ?? '',
      whatsapp: data['whatsapp'] ?? '',
      cidade: data['cidade'] ?? '',
      estado: data['estado'] ?? '',
      fotoUrl: data['fotoUrl'] ?? '',
      fotoBase64: data['fotoBase64'] ?? '',
      criadoEm: data['criadoEm'] != null
          ? (data['criadoEm'] as Timestamp).toDate()
          : null,
      petsFavoritos: List<String>.from(data['petsFavoritos'] ?? const []),
    );
  }

  Map<String, dynamic> toFirestore() => {
        'nome': nome,
        'cpf': cpf,
        'email': email,
        'whatsapp': whatsapp,
        'cidade': cidade,
        'estado': estado,
        'fotoUrl': fotoUrl,
        'fotoBase64': fotoBase64,
        'criadoEm': criadoEm != null
            ? Timestamp.fromDate(criadoEm!)
            : FieldValue.serverTimestamp(),
        'petsFavoritos': petsFavoritos,
      };

  UsuarioModel copyWith({
    String? nome,
    String? cpf,
    String? email,
    String? whatsapp,
    String? cidade,
    String? estado,
    String? fotoUrl,
    String? fotoBase64,
    DateTime? criadoEm,
    List<String>? petsFavoritos,
  }) {
    return UsuarioModel(
      id: id,
      nome: nome ?? this.nome,
      cpf: cpf ?? this.cpf,
      email: email ?? this.email,
      whatsapp: whatsapp ?? this.whatsapp,
      cidade: cidade ?? this.cidade,
      estado: estado ?? this.estado,
      fotoUrl: fotoUrl ?? this.fotoUrl,
      fotoBase64: fotoBase64 ?? this.fotoBase64,
      criadoEm: criadoEm ?? this.criadoEm,
      petsFavoritos: petsFavoritos ?? this.petsFavoritos,
    );
  }
}