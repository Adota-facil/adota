import 'dart:io';

import 'package:adota_facil/controller/controllers/home_controller_interfaces.dart';
import 'package:adota_facil/model/models/pet_model.dart';
import 'package:adota_facil/model/models/repositories/animal_repository.dart';
import 'package:adota_facil/services/analytics_service.dart';
import 'package:adota_facil/services/estrategia_armazenamento_foto.dart';
import 'package:flutter/material.dart';

/// [ISP] Implementa as duas interfaces segregadas — nada muda no
/// comportamento, mas fica explícito que este controller cumpre dois
/// papéis (listagem e cadastro) que poderiam, no futuro, virar duas
/// classes menores se crescerem demais.
class HomeController extends ChangeNotifier
    implements ListaAnimaisController, CadastroAnimalController {
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
  final AnalyticsService _analytics;

  /// [DIP] O construtor recebe as dependências como as interfaces
  /// abstratas (AnimalRepository, EstrategiaArmazenamentoFoto,
  /// AnalyticsService), nunca as classes concretas. O HomeController não
  /// sabe se os dados vêm do Firestore, se a foto vira Base64 ou vai pro
  /// Storage, nem qual provedor de analytics está registrando os
  /// eventos — só conhece os contratos. Quem decide a implementação
  /// concreta é o main.dart (o "composition root" do app).
  HomeController(this._repository, this._estrategiaFoto, this._analytics);

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
    _analytics.logFiltroCategoriaUsado(categoria: categoria);
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