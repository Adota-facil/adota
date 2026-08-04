import 'package:adota_facil/model/models/repositories/animal_repository.dart';
import 'package:flutter/material.dart';
import 'package:adota_facil/model/search_model.dart';

/// Controller da HomePage.
/// Use com Provider/ChangeNotifierProvider na árvore de widgets:
///
/// ChangeNotifierProvider(
///   create: (_) => HomeController(AnimalRepositoryImpl())..carregarAnimais(),
///   child: const HomePageView(),
/// )
class HomeController extends ChangeNotifier {
  final AnimalRepository _repository;

  HomeController(this._repository);

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

  Future<bool> cadastrarAnimal(PetModel animal) async {
    _salvando = true;
    notifyListeners();
    try {
      await _repository.cadastrarAnimal(animal);
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