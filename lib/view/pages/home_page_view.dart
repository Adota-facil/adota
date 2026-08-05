import 'package:adota_facil/controller/controllers/home_controller.dart';
import 'package:adota_facil/view/pages/curiosidades_view.dart';
import 'package:adota_facil/view/widgets/CarouselSlider_widget.dart';
import 'package:adota_facil/view/widgets/avatar_animais_widget.dart';
import 'package:adota_facil/view/widgets/pet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

/// Imagens de banner promocional (fixas), exibidas no carrossel do topo.
/// Coloque os arquivos em assets/image/ com esses nomes (ou troque os
/// caminhos abaixo pelos nomes reais que você já tem).
const List<String> _bannersPromocionais = [
  "assets/image/image 20.png",
];

/// Banners do segundo carrossel (também fixos/promocionais).
const List<String> _bannersSecundarios = [
  "assets/image/Rectangle 30.png",
];

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                CarouselSliderWidget(
                  altura: 280,
                  items: _bannersPromocionais.map((caminho) {
                    return Image.asset(
                      caminho,
                      fit: BoxFit.cover,
                      width: double.infinity,
                      errorBuilder: (context, error, stackTrace) {
                        
                        return Container(
                          color: const Color(0xFF4998E5),
                          alignment: Alignment.center,
                          child: const Text(
                            'Adote um pet e mude uma vida ❤',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                ),
                Positioned(
                  left: -25,
                  height: 450,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 40),
                        child: ElevatedButton(
                          onPressed: () {Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CuriosidadesView(),
                          ),
                        );},
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
              child: CarouselSliderWidget(
                altura: 200,
                items: _bannersSecundarios.map((caminho) {
                  return Image.asset(
                    caminho,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: const Color(0xFFFEAA62),
                        alignment: Alignment.center,
                        child: const Text(
                          'Espaço pra banner/parceiros',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
              ),
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
                      child: AvatarAnimais(
                        iconeSvg: 'assets/image/lucide_dog.svg',
                        nome: "Cachorro",
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.filtrarPorCategoria("Gato"),
                      child: AvatarAnimais(
                        iconeSvg: 'assets/image/Group.svg',
                        nome: "Gatos",
                      ),
                    ),
                    GestureDetector(
                      onTap: () => controller.filtrarPorCategoria("Outros"),
                      child: AvatarAnimais(
                        iconeSvg: "assets/image/material-symbols_add.svg",
                        nome: "Outros",
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Título "Últimos adicionados" no mesmo padrão de "Buscar por Categoria"
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: Text(
                "Últimos adicionados",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF4998E5),
                  fontSize: 25,
                ),
              ),
            ),

            // Lista de pets vinda do HomeController — carrossel horizontal
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
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
        padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
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

    return SizedBox(
      height: 260,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.animais.length,
        separatorBuilder: (context, index) => const SizedBox(width: 12),
        itemBuilder: (context, index) {
          return SizedBox(
            width: 170,
            child: PetCardWidget(pet: controller.animais[index]),
          );
        },
      ),
    );
  }
}
