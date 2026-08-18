import 'dart:io';

import 'package:adota_facil/model/models/pet_model.dart';
import 'package:adota_facil/model/models/repositories/animal_repository.dart';
import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';
import 'package:flutter/material.dart';

class HomeController extends ChangeNotifier {
  /// Categoria especial que representa "sem filtro".
  static const String categoriaTodos = 'Todos';

  static const String _erroCarregarAnimais =
      'Não foi possível carregar os animais.';
  static const String _erroFiltrarCategoria =
      'Não foi possível carregar os animais dessa categoria.';
  static const String _erroCadastrarAnimal =
      'Não foi possível cadastrar o animal.';

  final AnimalRepository _repository;
  final EstrategiaArmazenamentoFoto _estrategiaFoto;

  HomeController(this._repository, this._estrategiaFoto);

  List<PetModel> _animais = [];

  /// Retorna uma cópia somente-leitura — quem consome não consegue alterar
  /// a lista interna do controller por fora (ex: `animais.add(...)`).
  List<PetModel> get animais => List.unmodifiable(_animais);

  String _categoriaSelecionada = categoriaTodos;
  String get categoriaSelecionada => _categoriaSelecionada;

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  bool _salvando = false;
  bool get salvando => _salvando;

  Future<void> carregarAnimais() => _executarComCarregando(
        () async => _animais = await _repository.buscarAnimais(),
        _erroCarregarAnimais,
      );

  Future<void> filtrarPorCategoria(String categoria) {
    _categoriaSelecionada = categoria;
    return _executarComCarregando(
      () async => _animais = categoria == categoriaTodos
          ? await _repository.buscarAnimais()
          : await _repository.buscarPorCategoria(categoria),
      _erroFiltrarCategoria,
    );
  }

  String gerarNovoId() => _repository.gerarNovoId();

  /// [arquivoFoto] é opcional — se vier nulo, o pet é salvo sem foto,
  /// exatamente como acontece hoje. Quando vier preenchido, a foto passa
  /// pela estratégia configurada (Base64 ou Storage) antes de salvar.
  Future<bool> cadastrarAnimal(PetModel animal, {File? arquivoFoto}) async {
    _salvando = true;
    notifyListeners();
    try {
      final animalParaSalvar = arquivoFoto != null
          ? await _prepararComFoto(animal, arquivoFoto)
          : animal;

      await _repository.cadastrarAnimal(animalParaSalvar);
      await carregarAnimais();
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

  /// Resolve o id do pet (gera um novo se ainda não tiver) e delega o
  /// upload para a estratégia configurada, devolvendo o pet já com a
  /// foto preenchida. Extraído de [cadastrarAnimal] para que cada método
  /// continue fazendo uma coisa só.
  Future<PetModel> _prepararComFoto(PetModel animal, File arquivoFoto) async {
    final petId = animal.id.isNotEmpty ? animal.id : _repository.gerarNovoId();
    final resultado = await _estrategiaFoto.salvar(arquivoFoto, petId);
    return animal.copyWith(
      id: petId,
      fotoUrl: resultado.url,
      fotoBase64: resultado.base64,
    );
  }

  /// Centraliza o padrão repetido em [carregarAnimais] e
  /// [filtrarPorCategoria]: liga o loading, executa a ação, trata erro
  /// com a mensagem informada e desliga o loading no final.
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