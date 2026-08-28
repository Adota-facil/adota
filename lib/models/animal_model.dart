import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo de um pet, usado pelo AnimalRepository (Firestore).
///
/// Os campos abaixo vieram do formulário real de cadastro
/// (CadastroPetView): idade e porte são texto livre (ex: "9 anos"),
/// e statusSaude vem dos checkboxes de castrado/vacinado.
class PetModel {
  final String id;
  final String nome;
  final String especie; // "Cachorro", "Gato" ou "Outros"
  final String? raca;
  final String? idade; // texto livre, ex: "9 anos"
  final String? porte;
  final String? genero;
  final String? localizacao; // "Cidade, Estado"
  final String descricao;
  final String statusSaude; // ex: "Castrado, Vacinado"
  final String urlFoto;
  final bool adotado;
  final DateTime? criadoEm;

  PetModel({
    required this.id,
    required this.nome,
    required this.especie,
    this.raca,
    this.idade,
    this.porte,
    this.genero,
    this.localizacao,
    this.descricao = '',
    this.statusSaude = '',
    this.urlFoto = '',
    this.adotado = false,
    this.criadoEm,
  });

  /// Monta o texto de status de saúde a partir dos checkboxes do
  /// formulário de cadastro (ex: "Castrado, Vacinado").
  static String montarStatusSaude({
    required bool castrado,
    required bool vacinado,
  }) {
    final partes = <String>[
      if (castrado) 'Castrado',
      if (vacinado) 'Vacinado',
    ];
    return partes.isEmpty ? 'Não informado' : partes.join(', ');
  }

  /// Texto curto com raça/idade — usado nos cards e como um dos
  /// critérios de busca (junto com o nome).
  String get informacoesFormatadas {
    final partes = <String>[
      if (raca != null && raca!.isNotEmpty) raca!,
      if (idade != null && idade!.isNotEmpty) idade!,
    ];
    return partes.join(' • ');
  }

  factory PetModel.fromFirestore(Map<String, dynamic> data, String id) {
    return PetModel(
      id: id,
      nome: data['nome'] as String? ?? '',
      especie: data['especie'] as String? ?? '',
      raca: data['raca'] as String?,
      idade: data['idade'] as String?,
      porte: data['porte'] as String?,
      genero: data['genero'] as String?,
      localizacao: data['localizacao'] as String?,
      descricao: data['descricao'] as String? ?? '',
      statusSaude: data['statusSaude'] as String? ?? '',
      urlFoto: data['urlFoto'] as String? ?? '',
      adotado: data['adotado'] as bool? ?? false,
      criadoEm: (data['criadoEm'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'idade': idade,
      'porte': porte,
      'genero': genero,
      'localizacao': localizacao,
      'descricao': descricao,
      'statusSaude': statusSaude,
      'urlFoto': urlFoto,
      'adotado': adotado,
      'criadoEm': criadoEm != null
          ? Timestamp.fromDate(criadoEm!)
          : FieldValue.serverTimestamp(),
    };
  }
}