import 'package:adota_facil/controllers/buscar_controller.dart';
import 'package:adota_facil/view/widgets/pet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Tela de Busca: só monta o visual e lê o estado do BuscaController
/// (que é independente do HomeController).
class SearchPageView extends StatefulWidget {
  const SearchPageView({super.key});

  @override
  State<SearchPageView> createState() => _SearchPageViewState();
}

class _SearchPageViewState extends State<SearchPageView> {
  // Controller do widget TextField (estado de UI), não estado de
  // negócio — por isso continua aqui, não no BuscaController.
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<BuscaController>();

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _searchController,
              onChanged: controller.buscarPorTermo,
              decoration: InputDecoration(
                hintText: 'Pesquise por...',
                hintStyle: TextStyle(color: Colors.grey.shade400),
                prefixIcon: const Icon(Icons.search, color: Colors.black87),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear, color: Colors.grey),
                        onPressed: () {
                          _searchController.clear();
                          controller.buscarPorTermo('');
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
            Expanded(
              child: _ResultadoBusca(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _ResultadoBusca extends StatelessWidget {
  final BuscaController controller;
  const _ResultadoBusca({required this.controller});

  @override
  Widget build(BuildContext context) {
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

    final pets = controller.animaisFiltrados;

    if (pets.isEmpty) {
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
      itemCount: pets.length,
      itemBuilder: (context, index) {
        return PetCardWidget(pet: pets[index]);
      },
    );
  }
}