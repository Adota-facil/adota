/// Modelo de um pet disponível para adoção, exibido na Home.
///
/// Os campos abaixo foram inferidos a partir do uso da HomePageView
/// (PetCardWidget e o filtro por categoria). Ajuste os nomes conforme
/// os campos reais salvos no Firestore e o que o PetCardWidget espera.
class HomeModel {
  final String id;
  final String nome;
  final String especie; // "Cachorro", "Gato" ou "Outros"
  final String? raca;
  final int? idade;
  final String descricao;
  final String urlFoto;
  final bool adotado;

  HomeModel({
    required this.id,
    required this.nome,
    required this.especie,
    required this.urlFoto,
    this.raca,
    this.idade,
    this.descricao = '',
    this.adotado = false,
  });

  factory HomeModel.fromMap(String id, Map<String, dynamic> map) {
    return HomeModel(
      id: id,
      nome: map['nome'] as String? ?? '',
      especie: map['especie'] as String? ?? '',
      raca: map['raca'] as String?,
      idade: map['idade'] as int?,
      descricao: map['descricao'] as String? ?? '',
      urlFoto: map['urlFoto'] as String? ?? '',
      adotado: map['adotado'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nome': nome,
      'especie': especie,
      'raca': raca,
      'idade': idade,
      'descricao': descricao,
      'urlFoto': urlFoto,
      'adotado': adotado,
    };
  }
}