import 'package:flutter/material.dart';
import 'package:adota_facil/models/pet_model.dart';

class SearchPageController extends ChangeNotifier {
  String _termoBusca = '';

  String get termoBusca => _termoBusca;

  void setTermoBusca(String termo) {
    _termoBusca = termo;
    notifyListeners();
  }

  void clearSearch() {
    _termoBusca = '';
    notifyListeners();
  }

  List<PetModel> filtrarPets(List<PetModel> pets) {
    if (_termoBusca.isEmpty) return pets;

    final query = _termoBusca.toLowerCase();
    return pets.where((pet) {
      final nameMatches = pet.nome.toLowerCase().contains(query);
      final infoMatches = pet.informacoesFormatadas.toLowerCase().contains(
        query,
      );
      return nameMatches || infoMatches;
    }).toList();
  }
}
