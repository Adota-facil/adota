import 'package:adota_facil/model/models/pet_model.dart';
import 'package:adota_facil/model/repositories/i_animal_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// Importe a interface e o model

class FirebaseAnimalRepository implements IAnimalRepository {
  final FirebaseFirestore _firestore;

  // Construtor recebendo a instância para facilitar injeção de dependência e testes
  FirebaseAnimalRepository(this._firestore);

  @override
  Future<List<PetModel>> fetchAnimals() async {
    try {
      final snapshot = await _firestore.collection('animais').get();
      
      return snapshot.docs.map((doc) {
        final data = doc.data();
        
        // 1. Tratamento de tipos específicos do Firebase (Timestamp -> DateTime)
        if (data['criadoEm'] is Timestamp) {
          data['criadoEm'] = (data['criadoEm'] as Timestamp).toDate();
        }

        // 2. Mesclagem do ID do documento com os dados reais
        return PetModel.fromMap(data, id: doc.id);
      }).toList();
      
    } catch (e) {
      // Aqui você pode logar o erro no Crashlytics, por exemplo
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
      
      // Tratamento do Timestamp para DateTime
      if (data['criadoEm'] is Timestamp) {
        data['criadoEm'] = (data['criadoEm'] as Timestamp).toDate();
      }

      return PetModel.fromMap(data, id: doc.id);
      
    } catch (e) {
      throw Exception('Erro ao buscar o animal $id no Firestore: $e');
    }
  }
}