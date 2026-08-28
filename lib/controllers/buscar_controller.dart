import 'package:adota_facil/models/animal_model.dart';
import 'package:adota_facil/models/repositorie/animal_repository.dart';
import 'package:flutter/foundation.dart';

class BuscaController extends ChangeNotifier {
  final AnimalRepository _repository;

  BuscaController({AnimalRepository? repository})
      : _repository = repository ?? AnimalRepositoryImpl() {
    carregarAnimais();
  }

  List<PetModel> _animais = [];

  bool _carregando = false;
  bool get carregando => _carregando;

  String? _erro;
  String? get erro => _erro;

  String _termoBusca = '';
  String get termoBusca => _termoBusca;

  List<PetModel> get animaisFiltrados {
    if (_termoBusca.isEmpty) return _animais;
    final termo = _termoBusca.toLowerCase();
    return _animais.where((pet) {
      final nomeContem = pet.nome.toLowerCase().contains(termo);
      final infoContem =
          pet.informacoesFormatadas.toLowerCase().contains(termo);
      return nomeContem || infoContem;
    }).toList();
  }

  Future<void> carregarAnimais() async {
    _carregando = true;
    _erro = null;
    notifyListeners();
    try {
      _animais = await _repository.buscarAnimais();
    } catch (e) {
      _erro = 'Não foi possível carregar os pets. Tente novamente.';
    } finally {
      _carregando = false;
      notifyListeners();
    }
  }

  void buscarPorTermo(String termo) {
    _termoBusca = termo;
    notifyListeners();
  }
}