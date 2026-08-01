import 'package:adota_facil/view/widgets/CarouselSlider_widget.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';
import 'package:adota_facil/view/widgets/avatar_animais_widget.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(leadingName: "Bem vindo! \n Eduardo"),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: 0, // Deixa a aba "Início" sempre marcada por enquanto
        onTap: (index) {
          // Função vazia: não faz nada quando o usuário clica
        },
      ),
      body: SingleChildScrollView(
        // <-- Adicionado aqui
        child: Column(
          children: [
            Stack(
              children: [
                CarouselsliderWidget(altura: 280, items: [1,2,3,4,5],),
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
              child: CarouselsliderWidget(altura: 200, items: [1],),
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
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Avatar_animals(iconeSvg: 'assets/image/lucide_dog.svg', nome: "Cachorro"),
                  Avatar_animals(iconeSvg: 'assets/image/Group.svg', nome: "Gatos"),
                  Avatar_animals(iconeSvg: "assets/image/material-symbols_add.svg", nome: "Outros"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
