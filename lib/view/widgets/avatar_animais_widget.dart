import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AvatarAnimais extends StatelessWidget {
  final String nome;
  final String iconeSvg;
  final VoidCallback? onPressed;

  const AvatarAnimais({
    super.key,
    required this.iconeSvg,
    required this.nome,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            minimumSize: Size(60, 60),
            backgroundColor: const Color(0xDDFEAA62),
            shape: CircleBorder(),
          ),
          child: SvgPicture.asset(
            height: 30,
            iconeSvg,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
        ),
        SizedBox(height: 4),
        Text(
          nome,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: const Color(0xDDFEAA62),
            fontSize: 16,
          ),
        ),
      ],
    );
  }
}
