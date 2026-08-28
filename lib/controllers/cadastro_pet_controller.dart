import 'package:adota_facil/models/animal_model.dart';
import 'package:adota_facil/models/repositorie/animal_repository.dart';
import 'package:flutter/foundation.dart';

class CadastroPetController extends ChangeNotifier {
  final AnimalRepository _repository;

  CadastroPetController({AnimalRepository? repository})
      : _repository = repository ?? AnimalRepositoryImpl();

  bool _salvando = false;
  bool get salvando => _salvando;

  String? _erro;
  String? get erro => _erro;

  Future<bool> cadastrarAnimal(PetModel novoPet) async {
    _salvando = true;
    _erro = null;
    notifyListeners();
    try {
      await _repository.cadastrarAnimal(novoPet);
      return true;
    } catch (e) {
      _erro = 'Não foi possível cadastrar o pet. Tente novamente.';
      return false;
    } finally {
      _salvando = false;
      notifyListeners();
    }
  }
}