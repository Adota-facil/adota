import 'package:flutter/material.dart';
import 'package:adota_facil/view/pages/home_page_view.dart';
import 'package:adota_facil/view/pages/search_page_view.dart';
import 'package:adota_facil/view/pages/perfil_pet_view.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Adota Fácil',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Adota Fácil'),
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
  // Posição inicial (1 = SearchPageView)
  int _currentIndex = 1;

  // Lista com as telas das abas principais
  final List<Widget> _pages = const [
    HomePageView(), // 0: Início
    SearchPageView(), // 1: Buscar Pets
    PerfilPet(), // 2: Anunciar Pet
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Mantém o estado das telas ao alternar entre as abas
      body: IndexedStack(index: _currentIndex, children: _pages),

      // Barra de navegação inferior compartilhada
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
      ),
    );
  }
}
