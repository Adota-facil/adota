import 'package:adota_facil/models/pet_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class AnimalReader {
  Future<List<PetModel>> buscarAnimais();
  Future<List<PetModel>> buscarPorCategoria(String categoria);
  Future<List<PetModel>> buscarPorAnunciante(String anuncianteId);
  Future<PetModel> buscarPorId(String id);
}

abstract class AnimalWriter {
  Future<void> cadastrarAnimal(PetModel animal);
  Future<void> atualizarAnimal(PetModel animal);
  Future<void> marcarComoAdotado(String id, bool adotado);
  Future<void> excluirAnimal(String id);
  String gerarNovoId();
}

abstract class AnimalRepository implements AnimalReader, AnimalWriter {}

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
  Future<List<PetModel>> buscarPorAnunciante(String anuncianteId) async {
    // Sem orderBy aqui de propósito: where + orderBy em campos diferentes
    // exige um índice composto no Firestore. Pra lista de um único
    // anunciante (tipicamente pequena), ordenar em Dart depois de buscar
    // evita essa dependência sem custo perceptível.
    final snapshot = await _firestore
        .collection(_colecao)
        .where('anuncianteId', isEqualTo: anuncianteId)
        .get();

    final pets = snapshot.docs
        .map((doc) => PetModel.fromFirestore(doc.data(), doc.id))
        .toList();

    pets.sort((a, b) {
      final dataA = a.criadoEm;
      final dataB = b.criadoEm;
      if (dataA == null && dataB == null) return 0;
      if (dataA == null) return 1;
      if (dataB == null) return -1;
      return dataB.compareTo(dataA);
    });

    return pets;
  }

  @override
  Future<void> cadastrarAnimal(PetModel animal) async {
    final id = animal.id.isNotEmpty ? animal.id : gerarNovoId();
    await _firestore
        .collection(_colecao)
        .doc(id)
        .set(animal.copyWith(id: id).toFirestore(), SetOptions(merge: true));
  }

  @override
  Future<void> atualizarAnimal(PetModel animal) async {
    if (animal.id.isEmpty) throw ArgumentError('O animal precisa de um id.');
    await _firestore
        .collection(_colecao)
        .doc(animal.id)
        .update(animal.toFirestore());
  }

  @override
  Future<void> marcarComoAdotado(String id, bool adotado) {
    return _firestore.collection(_colecao).doc(id).update({
      'adotado': adotado,
      'atualizadoEm': FieldValue.serverTimestamp(),
    });
  }

  @override
  Future<void> excluirAnimal(String id) {
    return _firestore.collection(_colecao).doc(id).delete();
  }

  @override
  String gerarNovoId() {
    return _firestore.collection(_colecao).doc().id;
  }
}