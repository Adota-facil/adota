import 'package:adota_facil/controllers/home_controller.dart';
import 'package:adota_facil/controllers/search_controller.dart';
import 'package:adota_facil/models/pet_model.dart';
import 'package:adota_facil/view/widgets/pet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SearchPageView extends StatefulWidget {
  const SearchPageView({super.key});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  final TextEditingController _textEditingController = TextEditingController();

  @override
  void dispose() {
    _textEditingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final homeController = context.watch<HomeController>();
    final searchController = context.watch<SearchPageController>();

    final filteredPets = searchController.filtrarPets(homeController.animais);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Campo de Pesquisa
            TextField(
              controller: _textEditingController,
              onChanged: (value) => searchController.setTermoBusca(value),
              decoration: InputDecoration(
                hintText: 'Pesquise por...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.black87),
                suffixIcon: searchController.termoBusca.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _textEditingController.clear();
                          searchController.clearSearch();
                        },
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
            Expanded(child: _construirConteudo(homeController, filteredPets)),
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
      padding: const EdgeInsets.only(top: 4, bottom: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.80,
      ),
      itemCount: filteredPets.length,
      itemBuilder: (context, index) {
        return PetCardWidget(pet: filteredPets[index]);
      },
    );
  }
}
