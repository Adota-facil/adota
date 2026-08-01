import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselsliderWidget extends StatefulWidget {
  final double altura;
  final List<int> items;

  const CarouselsliderWidget({super.key, required this.altura, required this.items});

  @override
  State<CarouselsliderWidget> createState() => _CarouselsliderWidgetState();
}

class _CarouselsliderWidgetState extends State<CarouselsliderWidget> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();
  

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: widget.altura, 
            viewportFraction: 1,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.items.map((i) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  margin: const EdgeInsets.symmetric(horizontal: 5.0),
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: Center(
                    child: Text(
                      'text $i',
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                );
              },
            );
          }).toList(),
        ),
        
        Positioned(
          bottom: 10,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.asMap().entries.map((entry) {
              return GestureDetector(
                onTap: () => _controller.animateToPage(entry.key),
                child: Container(
                  width: 8.0,
                  height: 8.0,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == entry.key
                        ? const Color(0xFF42A5F5) 
                        : const Color(0xFF000080), 
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
