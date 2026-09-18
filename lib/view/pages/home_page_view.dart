import 'package:adota_facil/controllers/home_controller.dart';
import 'package:adota_facil/view/pages/curiosidades_view.dart';
import 'package:adota_facil/view/widgets/CarouselSlider_widget.dart';
import 'package:adota_facil/view/widgets/avatar_animais_widget.dart';
import 'package:adota_facil/view/widgets/pet_card_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


const List<String> _bannersPromocionais = ["assets/image/image 20.png"];
const List<String> _bannersSecundarios = ["assets/image/Rectangle 30.png"];

class HomePageView extends StatelessWidget {
  final ValueChanged<String>? onCategoriaSelecionada;
  final VoidCallback? onAdoteAgora;
  final VoidCallback? onAnunciarPet;

  const HomePageView({
    super.key,
    this.onCategoriaSelecionada,
    this.onAdoteAgora,
    this.onAnunciarPet,
  });

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
                        onPressed: onAdoteAgora,
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
                        onPressed: onAnunciarPet,
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
              children: [
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
                    AvatarAnimais(
                      onPressed: () {
                        onCategoriaSelecionada?.call("Cachorro");
                      },
                      iconeSvg: 'assets/image/lucide_dog.svg',
                      nome: "Cachorro",
                    ),
                    AvatarAnimais(
                      onPressed: () {
                        onCategoriaSelecionada?.call("Gato");
                      },
                      iconeSvg: 'assets/image/Group.svg',
                      nome: "Gatos",
                    ),
                    AvatarAnimais(
                      onPressed: () {
                        onCategoriaSelecionada?.call("Outros");
                      },
                      iconeSvg: "assets/image/material-symbols_add.svg",
                      nome: "Outros",
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
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: ElevatedButton.icon(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CuriosidadesView(),
                    ),
                  );
                },
                icon: const Icon(Icons.auto_awesome, size: 20),
                label: const Text("Curiosidades"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF4998E5),
                  foregroundColor: Colors.white,
                  elevation: 2,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 18,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  textStyle: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 10),
            ),
            const SizedBox(height: 150),
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