import 'package:adota_facil/controller/home_controller.dart';
import 'package:adota_facil/view/widgets/CarouselSlider_widget.dart';
import 'package:adota_facil/view/widgets/avatar_animais_widget.dart';
import 'package:adota_facil/view/widgets/pet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // <-- Adicionado aqui
        child: Column(
          children: [
            Stack(
              children: [
                CarouselsliderWidget(altura: 280, items: const [1, 2, 3, 4, 5]),
                Positioned(
                  left: -25,
                  height: 450,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF4998E5),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Adote agora",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 7),
                              Icon(Icons.favorite, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFEAA62),
                          ),
                          child: Row(
                            children: [
                              Text(
                                "Anunciar Pet",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(width: 7),
                              Icon(Icons.pets, color: Colors.white),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: CarouselsliderWidget(altura: 200, items: const [1]),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Buscar por Categoria",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF4998E5),
                      fontSize: 25,
                    ),
                  ),
                ),
              ],
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: SizedBox(
                width: MediaQuery.of(context).size.width,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    GestureDetector(
                      onTap: () => controller.filtrarPorCategoria("Cachorro"),
                      child: Avatar_animals(
                        iconeSvg: 'assets/image/lucide_dog.svg',
                        nome: "Cachorro",
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.filtrarPorCategoria("Gato"),
                      child: Avatar_animals(
                        iconeSvg: 'assets/image/Group.svg',
                        nome: "Gatos",
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.filtrarPorCategoria("Outros"),
                      child: Avatar_animals(
                        iconeSvg: "assets/image/material-symbols_add.svg",
                        nome: "Outros",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Lista de pets vinda do HomeController
            Padding(
              padding: const EdgeInsets.all(16),
              child: _ListaDePets(controller: controller),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaDePets extends StatelessWidget {
  final HomeController controller;

  const _ListaDePets({required this.controller});

  @override
  Widget build(BuildContext context) {
    if (controller.carregando) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (controller.erro != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 40),
        child: Center(
          child: Column(
            children: [
              Text(controller.erro!),
              const SizedBox(height: 8),
              ElevatedButton(
                onPressed: () => controller.carregarAnimais(),
                child: const Text("Tentar novamente"),
              ),
            ],
          ),
        ),
      );
    }

    if (controller.animais.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: Center(child: Text("Nenhum pet encontrado.")),
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: controller.animais.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemBuilder: (context, index) {
        return PetCardWidget(pet: controller.animais[index]);
      },
    );
  }
}
