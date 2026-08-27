import 'dart:io';

import 'package:adota_facil/model/models/pet_model.dart';

/// [ISP] Interface enxuta para telas que só precisam listar/filtrar
/// animais (ex: home, busca). Quem depende dela não é forçado a
/// conhecer nada sobre cadastro de pet.
abstract class ListaAnimaisController {
  List<PetModel> get animais;
  String get categoriaSelecionada;
  bool get carregando;
  String? get erro;

  Future<void> carregarAnimais();
  Future<void> filtrarPorCategoria(String categoria);
}

/// [ISP] Interface enxuta para telas que só precisam cadastrar um pet
/// (ex: CadastroPetView). Quem depende dela não é forçado a conhecer
/// nada sobre listagem/filtro.
abstract class CadastroAnimalController {
  bool get salvando;
  String? get erro;

  String gerarNovoId();
  Future<bool> cadastrarAnimal(PetModel animal, {File? arquivoFoto});
}