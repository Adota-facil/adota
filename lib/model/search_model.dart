import 'dart:ui';

class PetModel {
  final String id;
  final String nome;
  final String especie;
  final String statusSaude;
  final String idade;
  final String porte;
  final String imagemUrl;
  final String genero;

  const PetModel({
    required this.id,
    required this.nome,
    required this.especie,
    required this.statusSaude,
    required this.idade,
    required this.porte,
    required this.imagemUrl,
    required this.genero,
    required String name,
  });

  // Converte JSON da API para o Objeto Pet
  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      statusSaude: json['statusSaude'] ?? '',
      idade: json['idade'] ?? '',
      porte: json['porte'] ?? '',
      imagemUrl: json['imagemUrl'] ?? '',
      genero: json['genero'] ?? 'macho',
      name: '',
    );
  }

  // Converte o Objeto Pet para JSON (caso precise enviar algo para a API)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'statusSaude': statusSaude,
      'idade': idade,
      'porte': porte,
      'imagemUrl': imagemUrl,
      'genero': genero,
    };
  }
}
