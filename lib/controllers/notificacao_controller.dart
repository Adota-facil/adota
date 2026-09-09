import 'dart:async';
import 'package:adota_facil/models/pet_model.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificacaoController extends ChangeNotifier {
  static const _chaveFiltro = 'notificacoes_filtro_categorias';
  static const _chaveUltimaVisualizacao = 'notificacoes_ultima_visualizacao';
  static const categoriasDisponiveis = ['Cachorro', 'Gato'];

  List<PetModel> _pets = [];
  Set<String> _categoriasFiltro = {'Cachorro', 'Gato'};
  DateTime? _ultimaVisualizacao;
  StreamSubscription<List<PetModel>>? _subscription;

  NotificacaoController() {
    _carregarPreferencias();
  }

  Set<String> get categoriasFiltro => _categoriasFiltro;

  List<PetModel> get notificacoes {
    final filtradas =
        _pets.where((pet) => _categoriasFiltro.contains(pet.especie)).toList();
    filtradas.sort((a, b) {
      final dataA = a.criadoEm;
      final dataB = b.criadoEm;
      if (dataA == null && dataB == null) return 0;
      if (dataA == null) return 1; // sem data vai pro final da lista
      if (dataB == null) return -1;
      return dataB.compareTo(dataA);
    });
    return filtradas;
  }

  int get naoLidas {
    if (_ultimaVisualizacao == null) return notificacoes.length;
    return notificacoes
        .where((pet) =>
            pet.criadoEm != null && pet.criadoEm!.isAfter(_ultimaVisualizacao!))
        .length;
  }

  /// Chame isso sempre que tiver a lista atualizada de TODOS os pets
  /// (ex: dentro do HomeController.carregarAnimais(), via o callback
  /// aoAtualizarAnimais).
  void atualizarPets(List<PetModel> pets) {
    _pets = pets;
    notifyListeners();
  }

  /// Alternativa a atualizarPets: se você tiver um stream em tempo real
  /// (ex: vindo do Firestore), conecta aqui pra atualizar sozinho.
  void observarPets(Stream<List<PetModel>> streamDePets) {
    _subscription?.cancel();
    _subscription = streamDePets.listen(atualizarPets);
  }

  void alternarCategoria(String categoria) {
    if (_categoriasFiltro.contains(categoria)) {
      _categoriasFiltro.remove(categoria);
    } else {
      _categoriasFiltro.add(categoria);
    }
    _salvarFiltro();
    notifyListeners();
  }

  void marcarComoLidas() {
    _ultimaVisualizacao = DateTime.now();
    _salvarUltimaVisualizacao();
    notifyListeners();
  }

  Future<void> _carregarPreferencias() async {
    final prefs = await SharedPreferences.getInstance();
    final salvo = prefs.getStringList(_chaveFiltro);
    if (salvo != null) _categoriasFiltro = salvo.toSet();
    final timestamp = prefs.getInt(_chaveUltimaVisualizacao);
    if (timestamp != null) {
      _ultimaVisualizacao = DateTime.fromMillisecondsSinceEpoch(timestamp);
    }
    notifyListeners();
  }

  Future<void> _salvarFiltro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_chaveFiltro, _categoriasFiltro.toList());
  }

  Future<void> _salvarUltimaVisualizacao() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(
      _chaveUltimaVisualizacao,
      _ultimaVisualizacao!.millisecondsSinceEpoch,
    );
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}