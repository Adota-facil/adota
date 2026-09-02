import 'package:adota_facil/model/models/pet_model.dart';

import 'i_animal_repository.dart';

class JsonAnimalRepository implements IAnimalRepository {
  // Se você estiver usando um cliente HTTP (como Dio ou http), você o injetaria aqui:
  // final Dio _dio;
  // JsonAnimalRepository(this._dio);

  @override
  Future<List<PetModel>> fetchAnimals() async {
    try {
      // Exemplo de chamada HTTP (substitua pela sua rota real se houver API)
      // final response = await _dio.get('/animais');
      // final List<dynamic> jsonList = response.data;

      // Simulando uma lista de JSONs vindos de uma fonte de dados:
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
        // Adicione mais itens se quiser testar...
      ];

      // Converte cada item da lista em um PetModel usando o .fromJson()
      return jsonList.map((json) => PetModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('Erro ao buscar animais via JSON: $e');
    }
  }

  @override
  Future<PetModel> fetchAnimalById(String id) async {
    try {
      // Exemplo de requisição para buscar um pet específico:
      // final response = await _dio.get('/animais/$id');
      // final Map<String, dynamic> jsonMap = response.data;

      // Simulação de retorno de um único JSON:
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