import 'package:adota_facil/view/pages/home_page_view.dart';
import 'package:adota_facil/view/pages/perfil_pet_view.dart';
import 'package:adota_facil/view/pages/search_page_view.dart';
import 'package:adota_facil/view/widgets/avatar_icon.dart';
import 'package:adota_facil/view/widgets/buton_padrao_widget.dart';
import 'package:adota_facil/view/widgets/buton_search.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(title: 'Adota Facil'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return SearchPageView();
  }
}
