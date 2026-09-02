enum Genero {
  macho,
  femea;

  static Genero fromString(String value) {
    final normalizado = value.trim().toLowerCase();
    return normalizado == 'fêmea' || normalizado == 'femea'
        ? Genero.femea
        : Genero.macho;
  }

  @override
  String toString() => this == Genero.femea ? 'fêmea' : 'macho';
}

class PetModel {
  final String id;
  final String nome;
  final String especie;
  final String statusSaude;
  final String idade;
  final String porte;
  final Genero genero;
  final String fotoUrl;
  final bool adotado;
  final bool castrado;
  final bool vacinado;
  final DateTime? criadoEm;
  final String raca;
  final String descricao;
  final String localizacao;
  final List<String> fotos;

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
    this.castrado = false,
    this.vacinado = false,
    this.criadoEm,
    this.raca = '',
    this.descricao = '',
    this.localizacao = '',
    this.fotos = const [],
  });

  String get informacoesFormatadas =>
      '$especie • $statusSaude\n$idade • $porte';

  List<String> get tagsSaude => statusSaude
      .split(',')
      .map((tag) => tag.trim())
      .where((tag) => tag.isNotEmpty)
      .toList();

 factory PetModel.fromMap(Map<String, dynamic> map, {String? id}) {
    return PetModel(
      id: id ?? map['id'] ?? '',
      nome: map['nome'] ?? '',
      especie: map['especie'] ?? '',
      statusSaude: map['statusSaude'] ?? '',
      idade: map['idade'] ?? '',
      porte: map['porte'] ?? '',
      genero: Genero.fromString(map['genero'] ?? 'macho'),
      fotoUrl: map['fotoUrl'] ?? '',
      adotado: map['adotado'] ?? false,
      castrado: map['castrado'] ?? false,
      vacinado: map['vacinado'] ?? false,
      // Esperamos que quem chamou esse método já tenha convertido para DateTime
      // ou que seja uma String ISO8601 (como vem de APIs JSON)
      criadoEm: _parseDateTime(map['criadoEm']),
      raca: map['raca'] ?? '',
      descricao: map['descricao'] ?? '',
      localizacao: map['localizacao'] ?? '',
      fotos: List<String>.from(map['fotos'] ?? const []),
    );
  }
  
  static DateTime? _parseDateTime(dynamic value) {
    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);
    return null;
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'statusSaude': statusSaude,
      'idade': idade,
      'porte': porte,
      'genero': genero.toString(),
      'fotoUrl': fotoUrl,
      'adotado': adotado,
      'castrado': castrado,
      'vacinado': vacinado,
      'criadoEm': criadoEm?.toIso8601String(),
      'raca': raca,
      'descricao': descricao,
      'localizacao': localizacao,
      'fotos': fotos,
    };
  }

  PetModel copyWith({
    String? id,
    String? nome,
    String? especie,
    String? statusSaude,
    String? idade,
    String? porte,
    Genero? genero,
    String? fotoUrl,
    bool? adotado,
    bool? castrado,
    bool? vacinado,
    DateTime? criadoEm,
    String? raca,
    String? descricao,
    String? localizacao,
    List<String>? fotos,
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
      castrado: castrado ?? this.castrado,
      vacinado: vacinado ?? this.vacinado,
      criadoEm: criadoEm ?? this.criadoEm,
      raca: raca ?? this.raca,
      descricao: descricao ?? this.descricao,
      localizacao: localizacao ?? this.localizacao,
      fotos: fotos ?? this.fotos,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is PetModel && other.id == id;
  }

  @override
  int get hashCode => id.hashCode;
}