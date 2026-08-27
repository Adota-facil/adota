import 'package:adota_facil/controller/controllers/home_controller.dart';
import 'package:adota_facil/view/pages/curiosidades_view.dart';
import 'package:adota_facil/view/widgets/CarouselSlider_widget.dart';
import 'package:adota_facil/view/widgets/avatar_animais_widget.dart';
import 'package:adota_facil/view/widgets/pet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web/web.dart' as web;

const List<String> _bannersPromocionais = ["assets/image/image 20.png"];
const List<String> _bannersSecundarios = ["assets/image/Rectangle 30.png"];

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<HomeController>();

    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              clipBehavior: Clip.none,
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
                  bottom: -20,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CuriosidadesView(),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF4998E5),
                          elevation: 4,
                        ),
                        child: Row(
                          children: const [
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
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFEAA62),
                          elevation: 4,
                        ),
                        child: Row(
                          children: const [
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
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
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
              children: const [
                Padding(
                  padding: const EdgeInsets.only(left: 20),
                  child: Text(
                    "Buscar por Categoria",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF4998E5),
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
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: const Text(
                "Últimos adicionados",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4998E5),
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: _ListaDePets(controller: controller),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20),
              child: const Text(
                "Curiosidades",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4998E5),
                  fontSize: 25,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
              child: _construirCarrosselCuriosidades(controller),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _construirCarrosselCuriosidades(HomeController controller) {
    if (controller.carregandoCuriosidades) {
      return const SizedBox(
        height: 180,
        child: Center(child: CircularProgressIndicator()),
      );
    }
    if (controller.curiosidades.isEmpty) {
      return Container(
        height: 180,
        width: double.infinity,
        decoration: BoxDecoration(
          color: const Color(0xFF4998E5),
          borderRadius: BorderRadius.circular(12),
        ),
        alignment: Alignment.center,
        child: const Text(
          'Nenhuma imagem disponível 🐾',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      );
    }
    return CarouselsliderWidget(
      altura: 180,
      items: controller.curiosidades.map((curiosidade) {
        final viewId = 'img-${curiosidade.id}';

        ui.platformViewRegistry.registerViewFactory(viewId, (int viewId) {
          final element = web.HTMLImageElement();
          element.src = curiosidade.urlImagem;
          element.style.width = '100%';
          element.style.height = '100%';
          element.style.objectFit = 'cover';
          element.style.borderRadius = '12px';

          element.onError.listen((event) {
            element.src = 'pexels.com';
          });
          return element;
        });
        return Container(
          width: double.infinity,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: const Color(0xFFECEFF1),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: HtmlElementView(viewType: viewId),
          ),
        );
      }).toList(),
    );
  }
}

class _ListaDePets extends StatelessWidget {
  final HomeController controller;
  const _ListaDePets({required this.controller});
  @override
  build(BuildContext context) {
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

