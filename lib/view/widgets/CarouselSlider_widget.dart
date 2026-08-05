import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';

class CarouselsliderWidget extends StatefulWidget {
  final double altura;
  final List<Widget> items;

  const CarouselsliderWidget({
    super.key,
    required this.altura,
    required this.items,
  });

  @override
  State<CarouselsliderWidget> createState() => _CarouselsliderWidgetState();
}

class _CarouselsliderWidgetState extends State<CarouselsliderWidget> {
  int _current = 0;
  final CarouselSliderController _controller = CarouselSliderController();

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return SizedBox(height: widget.altura);
    }

    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        CarouselSlider(
          carouselController: _controller,
          options: CarouselOptions(
            height: widget.altura,
            viewportFraction: 1,
            autoPlay: true,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
          items: widget.items.map((item) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                  width: double.infinity,
                  height: double.infinity,
                  clipBehavior: Clip.antiAlias,
                  decoration: const BoxDecoration(color: Colors.amber),
                  child: item,
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