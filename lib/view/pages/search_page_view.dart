import 'package:flutter/material.dart';
import 'package:adota_facil/model/search_model.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/pet_card_widget.dart';

class SearchPageView extends StatefulWidget {
  const SearchPageView({super.key});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  // Dados de teste formatados com a sua PetModel
  final List<PetModel> _allPets = const [
    PetModel(
      id: '1',
      nome: 'Mel',
      especie: 'Cachorro',
      statusSaude: 'Castrado',
      idade: '9 anos',
      porte: 'Porte médio',
      genero: 'macho',
    ),
    PetModel(
      id: '2',
      nome: 'Bica',
      especie: 'Cachorro',
      statusSaude: 'Castrada',
      idade: '9 anos',
      porte: 'Porte pequeno',
      genero: 'fêmea',
    ),
    PetModel(
      id: '3',
      nome: 'Luke',
      especie: 'Cachorro',
      statusSaude: 'Castrado',
      idade: '11 anos',
      porte: 'Porte pequeno',
      genero: 'macho',
    ),
    PetModel(
      id: '4',
      nome: 'Branquinho',
      especie: 'Rato',
      statusSaude: 'Vacinado',
      idade: '2 anos',
      porte: 'Porte pequeno',
      genero: 'macho',
    ),
    PetModel(
      id: '5',
      nome: 'Louro',
      especie: 'Pássaro',
      statusSaude: 'Vacinado',
      idade: '2 anos',
      porte: 'Porte pequeno',
      genero: 'macho',
    ),
    PetModel(
      id: '6',
      nome: 'Bidu',
      especie: 'Cachorro',
      statusSaude: 'Vacinado',
      idade: '12 anos',
      porte: 'Porte grande',
      genero: 'macho',
    ),
  ];

  late List<PetModel> _filteredPets;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPets = _allPets;
  }

  void _runFilter(String enteredKeyword) {
    if (enteredKeyword.isEmpty) {
      setState(() {
        _filteredPets = _allPets;
      });
      return;
    }

    final query = enteredKeyword.toLowerCase();
    setState(() {
      _filteredPets = _allPets.where((pet) {
        final nameMatches = pet.nome.toLowerCase().contains(query);
        final infoMatches = pet.informacoesFormatadas.toLowerCase().contains(
          query,
        );
        return nameMatches || infoMatches;
      }).toList();
    });
  }

  void _clearSearch() {
    _searchController.clear();
    _runFilter('');
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const AppbarWidget(leadingName: "Buscar pets"),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de Pesquisa
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

            const SizedBox(height: 16),

            // Grid de Cards
            Expanded(
              child: _filteredPets.isEmpty
                  ? const Center(
                      child: Text(
                        'Nenhum pet encontrado.',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.only(top: 4, bottom: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            crossAxisSpacing: 12,
                            mainAxisSpacing: 12,
                            childAspectRatio: 0.80,
                          ),
                      itemCount: _filteredPets.length,
                      itemBuilder: (context, index) {
                        return PetCardWidget(pet: _filteredPets[index]);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
