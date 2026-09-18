import 'package:adota_facil/models/pet_model.dart';

import 'i_animal_repository.dart';

class JsonAnimalRepository implements IAnimalRepository {
  @override
  Future<List<PetModel>> fetchAnimals() async {
    try {
      final List<dynamic> jsonList = [
        {
          'id': '1',
          'nome': 'Boby',
          'especie': 'Cachorro',
          'statusSaude': 'Saudável',
          'idade': '2 anos',
          'porte': 'Médio',
          'genero': 'macho',
          'adotado': false,
        },
      ];

      return jsonList.map((json) => PetModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar animais via JSON: $e');
    }
  }

  @override
  Future<PetModel> fetchAnimalById(String id) async {
    try {
      final Map<String, dynamic> jsonMap = {
        'id': id,
        'nome': 'Boby',
        'especie': 'Cachorro',
        'statusSaude': 'Saudável',
        'idade': '2 anos',
        'porte': 'Médio',
        'genero': 'macho',
        'adotado': false,
      };

      return PetModel.fromJson(jsonMap);
    } catch (e) {
      throw Exception('Erro ao buscar o animal $id via JSON: $e');
    }
  }
}