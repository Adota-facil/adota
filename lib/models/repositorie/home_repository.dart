import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:adota_facil/models/animal_model.dart';

class HomeRepository {
  final FirebaseFirestore _firestore;

  HomeRepository({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  Future<List<Animal>> buscarAnimais({String? categoria}) async {
    Query<Map<String, dynamic>> query = _firestore.collection('animais');

    if (categoria == 'Outros') {
      // "Outros" = tudo que não é Cachorro nem Gato.
      query = query.where('especie', whereNotIn: ['Cachorro', 'Gato']);
    } else if (categoria != null) {
      query = query.where('especie', isEqualTo: categoria);
    }

    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Animal.fromMap(doc.id, doc.data()))
        .toList();
  }

  Future<void> cadastrarAnimal(Animal animal) async {
    await _firestore.collection('animais').add(animal.toMap());
  }
}