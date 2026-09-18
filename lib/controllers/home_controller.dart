import 'dart:io';


import 'package:adota_facil/controllers/home_controller_interfaces.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/models/repositories/animal_repository.dart';
import 'package:adota_facil/services/analytics_service.dart';
import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier
    implements ListaAnimaisController, CadastroAnimalController {
  static const String categoriaTodos = 'Todos';

  static const String _erroCarregarAnimais =
      'Não foi possível carregar os animais.';
  static const String _erroFiltrarCategoria =
      'Não foi possível carregar os animais dessa categoria.';
  static const String _erroCadastrarAnimal =
      'Não foi possível cadastrar o animal.';

  final AnimalRepository _repository;
  final EstrategiaArmazenamentoFoto _estrategiaFoto;
  final AnalyticsService _analytics;

  final void Function(List<PetModel>)? _aoAtualizarAnimais;

  HomeController(
    this._repository,
    this._estrategiaFoto,
    this._analytics, {
    void Function(List<PetModel>)? aoAtualizarAnimais,
  }) : _aoAtualizarAnimais = aoAtualizarAnimais;

  List<PetModel> _animais = [];

  @override
  List<PetModel> get animais => List.unmodifiable(_animais);

  String _categoriaSelecionada = categoriaTodos;
  @override
  String get categoriaSelecionada => _categoriaSelecionada;

  bool _carregando = false;
  @override
  bool get carregando => _carregando;

  String? _erro;
  @override
  String? get erro => _erro;

  bool _salvando = false;
  @override
  bool get salvando => _salvando;

  get curiosidades => null;

  @override
  Future<void> carregarAnimais() => _executarComCarregando(
        () async {
          _animais = await _repository.buscarAnimais();
          _aoAtualizarAnimais?.call(_animais);
        },
        _erroCarregarAnimais,
      );

  @override
  Future<void> filtrarPorCategoria(String categoria) {
    _categoriaSelecionada = categoria;
    _analytics.logFiltroCategoriaUsado(categoria: categoria);
    return _executarComCarregando(
      () async => _animais = categoria == categoriaTodos
          ? await _repository.buscarAnimais()
          : await _repository.buscarPorCategoria(categoria),
      _erroFiltrarCategoria,
    );
  }

  @override
  String gerarNovoId() => _repository.gerarNovoId();

  @override
  Future<bool> cadastrarAnimal(PetModel animal, {File? arquivoFoto}) async {
    _salvando = true;
    notifyListeners();
    try {
      final animalParaSalvar = arquivoFoto != null
          ? await _prepararComFoto(animal, arquivoFoto)
          : animal;

      await _repository.cadastrarAnimal(animalParaSalvar);
      await carregarAnimais();
      await _analytics.logPetCadastrado(especie: animalParaSalvar.especie);
      _erro = null;
      return true;
    } catch (e) {
      _erro = _erroCadastrarAnimal;
      notifyListeners();
      return false;
    } finally {
      _salvando = false;
      notifyListeners();
    }
  }

  Future<PetModel> _prepararComFoto(PetModel animal, File arquivoFoto) async {
    final petId = animal.id.isNotEmpty ? animal.id : _repository.gerarNovoId();
    final resultado = await _estrategiaFoto.salvar(arquivoFoto, petId);
    return animal.copyWith(
      id: petId,
      fotoUrl: resultado.url,
      fotoBase64: resultado.base64,
    );
  }

  Future<void> _executarComCarregando(
    Future<void> Function() acao,
    String mensagemErro,
  ) async {
    _setCarregando(true);
    try {
      await acao();
      _erro = null;
    } catch (e) {
      _erro = mensagemErro;
    } finally {
      _setCarregando(false);
    }
  }

  void _setCarregando(bool valor) {
    _carregando = valor;
    notifyListeners();
  }
}