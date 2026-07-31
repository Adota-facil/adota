import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselsliderWidget extends StatefulWidget {
  final double altura;

  const CarouselsliderWidget({super.key, required this.altura});

  @override
  State<CarouselsliderWidget> createState() => _CarouselsliderWidgetState();
}

class _CarouselsliderWidgetState extends State<CarouselsliderWidget> {
  
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  
  // A sua lista original de itens
  final List<int> items = [1, 2, 3];

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        // O seu CarouselSlider original adaptado
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: widget.altura, 
            viewportFraction: 1,
            // Adicionado para atualizar a bolinha ao arrastar
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: items.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: Center(child: Text('text $i', style: const TextStyle(fontSize: 16.0))),
                );
              },
            );
          }).toList(),
        ),
        
        // As bolinhas posicionadas em cima do carrossel
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key
                        ? const Color(0xFF42A5F5) // Azul claro (Ativa)
                        : const Color(0xFF000080), // Azul escuro (Inativa)
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}