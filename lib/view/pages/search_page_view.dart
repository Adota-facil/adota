import 'package:adota_facil/view/pages/perfil_pet_view.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class SearchPageView extends StatefulWidget {
  const SearchPageView({super.key});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  // Lista original com todos os pets
  final List<Map<String, dynamic>> _allPets = [
    {
      'name': 'Mel',
      'info': 'Cachorro • Castrado\n9 anos • Porte médio',
      'gender': Icons.male,
      'color': Colors.blue,
    },
    {
      'name': 'Bica',
      'info': 'Cachorro • Castrada\n9 anos • Porte pequeno',
      'gender': Icons.female,
      'color': Colors.pink,
    },
    {
      'name': 'Luke',
      'info': 'Cachorro • Castrado\n11 anos • Porte pequeno',
      'gender': Icons.male,
      'color': Colors.blue,
    },
    {
      'name': 'Branquinho',
      'info': 'Rato • Vacinado\n2 anos • Porte pequeno',
      'gender': Icons.male,
      'color': Colors.blue,
    },
    {
      'name': 'Louro',
      'info': 'Pássaro • Vacinado\n2 anos • Porte pequeno',
      'gender': Icons.male,
      'color': Colors.blue,
    },
    {
      'name': 'Bidu',
      'info': 'Cachorro • Vacinado\n12 anos • Porte grande',
      'gender': Icons.male,
      'color': Colors.blue,
    },
  ];

  // Lista que será exibida e filtrada na tela
  late List<Map<String, dynamic>> _filteredPets;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredPets = _allPets;
  }

  // Função simples para filtrar a lista ao digitar no input
  void _runFilter(String enteredKeyword) {
    List<Map<String, dynamic>> results = [];
    if (enteredKeyword.isEmpty) {
      results = _allPets;
    } else {
      results = _allPets
          .where(
            (pet) =>
                pet['name'].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ) ||
                pet['info'].toLowerCase().contains(
                  enteredKeyword.toLowerCase(),
                ),
          )
          .toList();
    }

    setState(() {
      _filteredPets = results;
    });
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
              onChanged: (value) => _runFilter(value),
              decoration: InputDecoration(
                hintText: 'pesquisa aqui...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.black87),
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

            // Grid de Cards com Filtro
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
                        final pet = _filteredPets[index];
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withValues(alpha: 0.1),
                                blurRadius: 10,
                                spreadRadius: 2,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Imagem / Ícone
                              Expanded(
                                flex: 6,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Color.fromARGB(255, 212, 207, 207),
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(16),
                                      topRight: Radius.circular(16),
                                    ),
                                  ),
                                  child: Stack(
                                    children: [
                                      const Center(
                                        child: Icon(
                                          Icons.pets,
                                          size: 100,
                                          color: Color.fromARGB(
                                            255,
                                            126,
                                            124,
                                            121,
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        top: 8,
                                        right: 8,
                                        child: Icon(
                                          pet['gender'],
                                          color: pet['color'],
                                          size: 30,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Informações e Botão
                              Expanded(
                                flex: 5,
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            pet['name'],
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            pet['info'],
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.grey.shade600,
                                            ),
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),

                                      // Botão Ver detalhes
                                      SizedBox(
                                        width: double.infinity,
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const PerfilPet(),
                                              ),
                                            );
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.blue,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                            ),
                                            padding: EdgeInsets.zero,
                                          ),
                                          child: const Text(
                                            'Ver detalhes',
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: CustomBottomNav(currentIndex: 1, onTap: (index) {}),
    );
  }
}
