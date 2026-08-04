import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:adota_facil/model/search_model.dart';

/// Contrato do repositório — permite trocar a implementação
/// (Firestore, REST, mock para testes) sem alterar o controller.
abstract class AnimalRepository {
  Future<List<PetModel>> buscarAnimais();
  Future<List<PetModel>> buscarPorCategoria(String categoria);
  Future<PetModel> buscarPorId(String id);
  Future<void> cadastrarAnimal(PetModel animal);

  /// Gera um ID novo (sem criar o documento ainda) — usado quando
  /// precisamos subir as fotos pro Storage num caminho baseado no ID
  /// antes de salvar o documento no Firestore.
  String gerarNovoId();
}

/// Implementação via Firebase Firestore.
/// Assume uma coleção "animais" com os campos usados em PetModel.
class AnimalRepositoryImpl implements AnimalRepository {
  final FirebaseFirestore _firestore;
  static const String _colecao = 'animais';

  AnimalRepositoryImpl({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<PetModel>> buscarAnimais() async {
    final snapshot = await _firestore
        .collection(_colecao)
        .orderBy('criadoEm', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PetModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<List<PetModel>> buscarPorCategoria(String categoria) async {
    final snapshot = await _firestore
        .collection(_colecao)
        .where('especie', isEqualTo: categoria)
        .orderBy('criadoEm', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => PetModel.fromFirestore(doc.data(), doc.id))
        .toList();
  }

  @override
  Future<PetModel> buscarPorId(String id) async {
    final doc = await _firestore.collection(_colecao).doc(id).get();

    if (!doc.exists) {
      throw Exception('Animal não encontrado: $id');
    }

    return PetModel.fromFirestore(doc.data()!, doc.id);
  }

  @override
  Future<void> cadastrarAnimal(PetModel animal) async {
    final id = animal.id.isNotEmpty ? animal.id : gerarNovoId();
    await _firestore.collection(_colecao).doc(id).set(animal.toFirestore());
  }

  @override
  String gerarNovoId() {
    return _firestore.collection(_colecao).doc().id;
  }
}