import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/models/repositories/animal_repository.dart';
import 'package:flutter/material.dart';

class MeusAnunciosController extends ChangeNotifier {
  final AuthController _authController;
  final AnimalRepository _animalRepository;

  MeusAnunciosController(this._authController, this._animalRepository) {
    carregar();
  }

  List<PetModel> _pets = [];
  List<PetModel> get pets => _pets;

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  Future<void> carregar() async {
    final uid = _authController.usuarioId;
    if (uid == null) return;

    _carregando = true;
    notifyListeners();
    try {
      _pets = await _animalRepository.buscarPorAnunciante(uid);
      _erro = null;
    } catch (e) {
      _erro = 'Não foi possível carregar seus anúncios.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  Future<bool> alternarAdotado(PetModel pet) async {
    try {
      final novoValor = !pet.adotado;
      await _animalRepository.marcarComoAdotado(pet.id, novoValor);
      final indice = _pets.indexWhere((p) => p.id == pet.id);
      if (indice != -1) _pets[indice] = pet.copyWith(adotado: novoValor);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> remover(String petId) async {
    try {
      await _animalRepository.excluirAnimal(petId);
      _pets.removeWhere((p) => p.id == petId);
      notifyListeners();
      return true;
    } catch (e) {
      return false;
    }
  }
}