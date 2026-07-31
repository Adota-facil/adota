import 'package:adota_facil/view/pages/perfil_pet_view.dart';
import 'package:adota_facil/view/pages/search_page_view.dart'; // Importe a sua tela aqui
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatefulWidget {
  const HomePageView({super.key});

  @override
  State<HomePageView> createState() => _HomePageViewState();
}

class _HomePageViewState extends State<HomePageView> {
  int _currentIndex = 0;

  // Lista de páginas que mudam conforme o clique no menu inferior
  final List<Widget> _pages = [
    // 0: Tela Inicial (Home)
    Center(
      child: Builder(
        builder: (context) => ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PerfilPet()),
            );
          },
          child: const Text('Ir para página de Perfil Pet'),
        ),
      ),
    ),
    // 1: Tela de Busca (A sua tela)
    const SearchPageView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Opcional: só mostra a AppBar global se estiver na aba Home (índice 0)
      appBar: _currentIndex == 0
          ? const AppbarWidget(leadingName: "Bem vindo! \n Eduardo")
          : null,
      body: IndexedStack(index: _currentIndex, children: _pages),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index; // Atualiza qual tela deve aparecer
          });
        },
      ),
    );
  }
}
