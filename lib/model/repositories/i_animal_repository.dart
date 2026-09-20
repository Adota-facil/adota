import 'package:adota_facil/models/pet_model.dart';

abstract class IAnimalRepository {
  Future<List<PetModel>> fetchAnimals();

  Future<PetModel> fetchAnimalById(String id);
}
