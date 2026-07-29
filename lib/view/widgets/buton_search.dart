import 'package:flutter/material.dart';

class Buton_Search extends StatelessWidget {
  const Buton_Search({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFEF9737),
        borderRadius: BorderRadius.circular(20),
      ), 
      child: TextField(
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.search, color: Colors.white,),
          hintText: "Search",
          hintStyle: const TextStyle(color: Colors.white),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(vertical: 14),
        ),
      )
    );
  }
}