import 'dart:io';

import 'package:adota_facil/model/models/pet_model.dart';
import 'package:adota_facil/model/models/repositories/animal_repository.dart';
import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  final AnimalRepository _repository;
  final EstrategiaArmazenamentoFoto _estrategiaFoto;

  HomeController(this._repository, this._estrategiaFoto);

  List<PetModel> _animais = [];
  List<PetModel> get animais => _animais;

  String _categoriaSelecionada = 'Todos';
  String get categoriaSelecionada => _categoriaSelecionada;

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  Future<void> carregarAnimais() async {
    _setCarregando(true);
    try {
      _animais = await _repository.buscarAnimais();
      _erro = null;
    } catch (e) {
      _erro = 'Não foi possível carregar os animais.';
    } finally {
      _setCarregando(false);
    }
  }

  Future<void> filtrarPorCategoria(String categoria) async {
    _categoriaSelecionada = categoria;
    _setCarregando(true);
    try {
      if (categoria == 'Todos') {
        _animais = await _repository.buscarAnimais();
      } else {
        _animais = await _repository.buscarPorCategoria(categoria);
      }
      _erro = null;
    } catch (e) {
      _erro = 'Não foi possível carregar os animais dessa categoria.';
    } finally {
      _setCarregando(false);
    }
  }

  bool _salvando = false;
  bool get salvando => _salvando;

  String gerarNovoId() => _repository.gerarNovoId();

  /// [arquivoFoto] é opcional — se vier nulo, o pet é salvo sem foto,
  /// exatamente como acontece hoje. Quando vier preenchido, a foto passa
  /// pela estratégia configurada (Base64 ou Storage) antes de salvar, sem
  /// o HomeController precisar saber qual das duas está em uso.
  Future<bool> cadastrarAnimal(PetModel animal, {File? arquivoFoto}) async {
    _salvando = true;
    notifyListeners();
    try {
      var animalParaSalvar = animal;

      if (arquivoFoto != null) {
        final petId =
            animal.id.isNotEmpty ? animal.id : _repository.gerarNovoId();
        final resultado = await _estrategiaFoto.salvar(arquivoFoto, petId);
        animalParaSalvar = animal.copyWith(
          id: petId,
          fotoUrl: resultado.url,
          fotoBase64: resultado.base64,
        );
      }

      await _repository.cadastrarAnimal(animalParaSalvar);
      await carregarAnimais();
      _erro = null;
      return true;
    } catch (e) {
      _erro = 'Não foi possível cadastrar o animal.';
      notifyListeners();
      return false;
    } finally {
      _salvando = false;
      notifyListeners();
    }
  }

  void _setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }
}