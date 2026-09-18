import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/model/repositories/i_animal_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseAnimalRepository implements IAnimalRepository {
  final FirebaseFirestore _firestore;

  FirebaseAnimalRepository(this._firestore);

  @override
  Future<List<PetModel>> fetchAnimals() async {
    try {
      final snapshot = await _firestore.collection('animais').get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return PetModel.fromFirestore(data, doc.id);
      }).toList();
      
    } catch (e) {
      throw Exception('Erro ao buscar a lista de animais no Firestore: $e');
    }
  }

  @override
  Future<PetModel> fetchAnimalById(String id) async {
    try {
      final doc = await _firestore.collection('animais').doc(id).get();
      
      if (!doc.exists || doc.data() == null) {
        throw Exception('Animal não encontrado');
      }

      final data = doc.data()!;
      return PetModel.fromFirestore(data, doc.id);
      
    } catch (e) {
      throw Exception('Erro ao buscar o animal $id no Firestore: $e');
    }
  }
}