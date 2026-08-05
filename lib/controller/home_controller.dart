import 'dart:convert';
import 'package:adota_facil/model/models/repositories/animal_repository.dart';
import 'package:flutter/material.dart';
import 'package:adota_facil/model/search_model.dart';
import 'package:http/http.dart' as http;

const String _apiKey =
"live_pr1brhCCuzov30TUyC5GI30Gk2p18rMUgY6kQhXa0W2kNmVIOIIh9i6G3LvjDqmr";

class CuriosidadeModel {
final String id;
final String urlImagem;

CuriosidadeModel({
required this.id,
required this.urlImagem,
});

factory CuriosidadeModel.fromJson(Map<String, dynamic> json) {
return CuriosidadeModel(
id: json['id']?.toString() ?? '',
urlImagem: json['url']?.toString() ?? '',
);
}
}

class HomeController extends ChangeNotifier {
final AnimalRepository _repository;

HomeController(this._repository) {
carregarAnimais();
carregarCuriosidades();
}

List<PetModel> _animais = [];
List<PetModel> get animais => _animais;

List<CuriosidadeModel> _curiosidades = [];
List<CuriosidadeModel> get curiosidades => _curiosidades;

String _categoriaSelecionada = 'Todos';
String get categoriaSelecionada => _categoriaSelecionada;

bool _carregando = false;
bool get carregando => _carregando;

bool _carregandoCuriosidades = false;
bool get carregandoCuriosidades => _carregandoCuriosidades;

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

Future<void> carregarCuriosidades() async {
_carregandoCuriosidades = true;
notifyListeners();


try {
  final url = Uri.parse(
    'https://api.thedogapi.com/v1/images/search?limit=10',
  );

  final response = await http.get(
    url,
    headers: {
      'x-api-key': _apiKey,
      'Content-Type': 'application/json',
    },
  );

  if (response.statusCode == 200) {
    final dados = jsonDecode(response.body);

    if (dados is List) {
      _curiosidades = dados
          .whereType<Map<String, dynamic>>()
          .map((item) => CuriosidadeModel.fromJson(item))
          .where((item) => item.urlImagem.isNotEmpty)
          .toList();
    }

    if (_curiosidades.isEmpty) {
      _usarImagensDeFallback();
    }
  } else {
    _usarImagensDeFallback();
  }
} catch (e) {
  debugPrint('Erro ao carregar imagens da API: $e');
  _usarImagensDeFallback();
} finally {
  _carregandoCuriosidades = false;
  notifyListeners();
}


}

void _usarImagensDeFallback() {
_curiosidades = [
CuriosidadeModel(
id: 'f1',
urlImagem:
'https://images.unsplash.com/photo-1552053831-71594a27632d?auto=format&fit=crop&w=800&q=80',
),
CuriosidadeModel(
id: 'f2',
urlImagem:
'https://images.unsplash.com/photo-1587300003388-59208cc962cb?auto=format&fit=crop&w=800&q=80',
),
CuriosidadeModel(
id: 'f3',
urlImagem:
'https://images.unsplash.com/photo-1518717758536-85ae29035b6d?auto=format&fit=crop&w=800&q=80',
),
];
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
