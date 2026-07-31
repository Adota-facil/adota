import 'package:flutter/material.dart';

class Avatar_animals extends StatelessWidget {
  final String nome;
  final IconData icone;
  const Avatar_animals({super.key, required this.icone, required this.nome});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ElevatedButton( 
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            minimumSize: Size(60, 60),
            backgroundColor: const Color(0xDDFEAA62),
            shape: CircleBorder(),
          ),
          child: Column(children: [Icon(icone, color: Colors.white, size: 30,)]),
        ),
        SizedBox(height: 4,),
        Text(nome, style: TextStyle(fontWeight: FontWeight.bold, color: const Color(0xDDFEAA62), fontSize: 16),)
      ],
    );
  }
}
