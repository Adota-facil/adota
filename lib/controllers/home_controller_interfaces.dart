import 'dart:io';

import 'package:adota_facil/models/animal_model.dart';

abstract class ListaAnimaisController {
  List<PetModel> get animais;
  String get categoriaSelecionada;
  bool get carregando;
  String? get erro;

  Future<void> carregarAnimais();
  Future<void> filtrarPorCategoria(String categoria);
}

abstract class CadastroAnimalController {
  bool get salvando;
  String? get erro;

  String gerarNovoId();
  Future<bool> cadastrarAnimal(PetModel animal, {File? arquivoFoto});
}
