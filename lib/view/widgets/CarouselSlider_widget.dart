
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
  State<CarouselsliderWidget> createState() =>
      _CarouselsliderWidgetState();
}

class _CarouselsliderWidgetState extends State<CarouselsliderWidget> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    if (widget.items.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CarouselSlider(
          items: widget.items,
          options: CarouselOptions(
            height: widget.altura,
            viewportFraction: 1.0,
            enlargeCenterPage: false,
            autoPlay: widget.items.length > 1,
            autoPlayInterval: const Duration(seconds: 5),
            autoPlayAnimationDuration:
                const Duration(milliseconds: 800),
            autoPlayCurve: Curves.fastOutSlowIn,
            enableInfiniteScroll: widget.items.length > 1,
            onPageChanged: (index, reason) {
              setState(() {
                _current = index;
              });
            },
          ),
        ),
        if (widget.items.length > 1)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: widget.items.asMap().entries.map((entry) {
              return Container(
                width: 8,
                height: 8,
                margin: const EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _current == entry.key
                      ? Theme.of(context).colorScheme.primary
                      : Colors.grey.shade400,
                ),
              );
            }).toList(),
          ),
      ],
    );
  }
}
