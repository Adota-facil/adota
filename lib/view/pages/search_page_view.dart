import 'package:adota_facil/controllers/home_controller.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/widgets/pet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPageView extends StatefulWidget {
  final String? categoriaInicial;

  const SearchPageView({super.key, this.categoriaInicial});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  final TextEditingController _searchController = TextEditingController();
  String _termoBusca = '';
  String? _categoriaSelecionada;
  String? _racaSelecionada;
  String? _idadeSelecionada;
  String? _regiaoSelecionada;

  @override
  void initState() {
    super.initState();
    _categoriaSelecionada = widget.categoriaInicial;
  }

  void _runFilter(String enteredKeyword) {
    setState(() {
      _termoBusca = enteredKeyword;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _runFilter('');
  }

  List<PetModel> _filtrar(List<PetModel> pets) {
    final petsFiltrados = pets.where((pet) {
      final categoriaConfere = _corresponde(pet.especie, _categoriaSelecionada);
      final racaConfere = _corresponde(pet.raca, _racaSelecionada);
      final idadeConfere = _corresponde(pet.idade, _idadeSelecionada);
      final regiaoConfere = _corresponde(
        pet.localizacao,
        _regiaoSelecionada,
      );
      return categoriaConfere &&
          racaConfere &&
          idadeConfere &&
          regiaoConfere;
    }).toList();

    if (_termoBusca.isEmpty) return petsFiltrados;

    final query = _termoBusca.toLowerCase();
    return petsFiltrados.where((pet) {
      final nameMatches = pet.nome.toLowerCase().contains(query);
      final infoMatches = pet.informacoesFormatadas.toLowerCase().contains(
        query,
      );
      return nameMatches || infoMatches;
    }).toList();
  }

  bool _corresponde(String valor, String? filtro) {
    return filtro == null ||
        valor.trim().toLowerCase() == filtro.trim().toLowerCase();
  }

  void _adicionarOpcaoSelecionada(List<String> opcoes, String? selecionada) {
    if (selecionada != null &&
        selecionada.isNotEmpty &&
        !opcoes.any(
          (opcao) => opcao.toLowerCase() == selecionada.toLowerCase(),
        )) {
      opcoes.add(selecionada);
    }
  }

  String? _normalizarSelecao(List<String> opcoes, String? valor) {
    if (valor == null || valor.trim().isEmpty) return null;
    for (final opcao in opcoes) {
      if (opcao.trim().toLowerCase() == valor.trim().toLowerCase()) {
        return opcao;
      }
    }
    return valor;
  }

  List<String> _opcoesPara(
    List<PetModel> pets,
    String Function(PetModel) valor,
  ) {
    return pets
        .map(valor)
        .map((item) => item.trim())
        .where((item) => item.isNotEmpty)
        .toSet()
        .toList()
      ..sort();
  }

  Future<void> _abrirFiltros(List<PetModel> pets) async {
    var categoria = _categoriaSelecionada;
    var raca = _racaSelecionada;
    var idade = _idadeSelecionada;
    var regiao = _regiaoSelecionada;

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            final categorias = _opcoesPara(pets, (pet) => pet.especie);
            final racas = _opcoesPara(pets, (pet) => pet.raca);
            final idades = _opcoesPara(pets, (pet) => pet.idade);
            final regioes = _opcoesPara(pets, (pet) => pet.localizacao);
            _adicionarOpcaoSelecionada(categorias, categoria);
            _adicionarOpcaoSelecionada(racas, raca);
            _adicionarOpcaoSelecionada(idades, idade);
            _adicionarOpcaoSelecionada(regioes, regiao);

            categoria = _normalizarSelecao(categorias, categoria);
            raca = _normalizarSelecao(racas, raca);
            idade = _normalizarSelecao(idades, idade);
            regiao = _normalizarSelecao(regioes, regiao);

            Widget campoFiltro({
              required String label,
              required String? valor,
              required List<String> opcoes,
              required ValueChanged<String?> onChanged,
            }) {
              return DropdownButtonFormField<String>(
                initialValue: valor,
                isExpanded: true,
                decoration: InputDecoration(labelText: label),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('Todos'),
                  ),
                  ...opcoes.map(
                    (opcao) => DropdownMenuItem<String>(
                      value: opcao,
                      child: Text(opcao),
                    ),
                  ),
                ],
                onChanged: onChanged,
              );
            }

            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const Text(
                        'Filtrar animais',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      campoFiltro(
                        label: 'Animal',
                        valor: categoria,
                        opcoes: categorias,
                        onChanged: (valor) =>
                            setModalState(() => categoria = valor),
                      ),
                      const SizedBox(height: 12),
                      campoFiltro(
                        label: 'Raça',
                        valor: raca,
                        opcoes: racas,
                        onChanged: (valor) =>
                            setModalState(() => raca = valor),
                      ),
                      const SizedBox(height: 12),
                      campoFiltro(
                        label: 'Idade',
                        valor: idade,
                        opcoes: idades,
                        onChanged: (valor) =>
                            setModalState(() => idade = valor),
                      ),
                      const SizedBox(height: 12),
                      campoFiltro(
                        label: 'Região',
                        valor: regiao,
                        opcoes: regioes,
                        onChanged: (valor) =>
                            setModalState(() => regiao = valor),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                setState(() {
                                  _categoriaSelecionada = null;
                                  _racaSelecionada = null;
                                  _idadeSelecionada = null;
                                  _regiaoSelecionada = null;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Limpar'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  _categoriaSelecionada = categoria;
                                  _racaSelecionada = raca;
                                  _idadeSelecionada = idade;
                                  _regiaoSelecionada = regiao;
                                });
                                Navigator.pop(context);
                              },
                              child: const Text('Aplicar filtros'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();
    final filteredPets = _filtrar(controller.animais);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: _runFilter,
              decoration: InputDecoration(
                hintText: 'Pesquise por...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.black87),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: _clearSearch,
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),

            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: () => _abrirFiltros(controller.animais),
                icon: const Icon(Icons.tune),
                label: const Text('Filtros'),
              ),
            ),

            const SizedBox(height: 4),

            Expanded(child: _construirConteudo(controller, filteredPets)),
          ],
        ),
      ),
    );
  }

  Widget _construirConteudo(
    HomeController controller,
    List<PetModel> filteredPets,
  ) {
    if (controller.carregando) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.erro != null) {
      return Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(controller.erro!),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: () => controller.carregarAnimais(),
              child: const Text("Tentar novamente"),
            ),
          ],
        ),
      );
    }

    if (filteredPets.isEmpty) {
      return const Center(
        child: Text(
          'Nenhum pet encontrado.',
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.only(top: 4, bottom: 150),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.68,
      ),
      itemCount: filteredPets.length,
      itemBuilder: (context, index) {
        return PetCardWidget(pet: filteredPets[index]);
      },
    );
  }
}