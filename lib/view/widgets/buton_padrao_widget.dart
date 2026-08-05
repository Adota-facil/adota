import 'package:flutter/material.dart';

class ButtonAppBar extends StatelessWidget {
  final String titulo;


  const ButtonAppBar({super.key, required this.titulo});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: ElevatedButton(
        onPressed: () {},
        style: ElevatedButton.styleFrom(
          minimumSize: Size(40, 40),
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          side: BorderSide(color: const Color(0xFFEF9737), width: 2),
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        ),
        child: Text(titulo, style: TextStyle(color: Color(0xFFEF9737), fontWeight: FontWeight.bold, fontSize: 20),),
      ),
    );

  }
}
