import 'package:adota_facil/model/models/pet_model.dart';


abstract class IAnimalRepository {
  // Contrato: quem assinar essa interface obrigatoriamente precisa saber buscar a lista
  Future<List<PetModel>> fetchAnimals();

  // Contrato: quem assinar também precisa saber buscar um pet específico por ID
  Future<PetModel> fetchAnimalById(String id);
}