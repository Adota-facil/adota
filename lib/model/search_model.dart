import 'package:flutter/material.dart';

class PetModel {
  final String id;
  final String nome;
  final String especie;
  final String statusSaude;
  final String idade;
  final String porte;
  final String genero;

  const PetModel({
    required this.id,
    required this.nome,
    required this.especie,
    required this.statusSaude,
    required this.idade,
    required this.porte,
    required this.genero,
  });

  // Getter para formatar as informações exibidas nos cards
  String get informacoesFormatadas =>
      '$especie • $statusSaude\n$idade • $porte';

  // Ícone dinâmico com base no gênero
  IconData get iconeGenero {
    return genero.toLowerCase() == 'fêmea' || genero.toLowerCase() == 'femea'
        ? Icons.female
        : Icons.male;
  }

  // Cor dinâmica com base no gênero
  Color get corGenero {
    return genero.toLowerCase() == 'fêmea' || genero.toLowerCase() == 'femea'
        ? Colors.pink
        : Colors.blue;
  }

  // Converte JSON vindo de uma API ou banco para o modelo
  factory PetModel.fromJson(Map<String, dynamic> json) {
    return PetModel(
      id: json['id'] ?? '',
      nome: json['nome'] ?? '',
      especie: json['especie'] ?? '',
      statusSaude: json['statusSaude'] ?? '',
      idade: json['idade'] ?? '',
      porte: json['porte'] ?? '',
      genero: json['genero'] ?? 'macho',
    );
  }

  // Converte o objeto para Map/JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nome': nome,
      'especie': especie,
      'statusSaude': statusSaude,
      'idade': idade,
      'porte': porte,
      'genero': genero,
    };
  }
}
