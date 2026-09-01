import 'package:adota_facil/view/pages/cadastro_pet_view.dart';
import 'package:adota_facil/view/pages/config_view.dart';
import 'package:adota_facil/view/pages/home_page_view.dart';
import 'package:adota_facil/view/pages/perfil_usuario_view.dart';
import 'package:adota_facil/view/pages/search_page_view.dart';
import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class BasePageView extends StatefulWidget {
  const BasePageView({super.key});

  @override
  State<BasePageView> createState() => _BasePageViewState();
}

class _BasePageViewState extends State<BasePageView> {
  int _currentIndex = 0;
  final PageController _pageController = PageController();

  final List<String> _titulosAppBar = [
    "Adota Pet",
    "Pets",
    "Novo Pet:",
    "Meu Perfil",
    "Config.",
  ];

  void _onPageChanged(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _onBottomNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppbarWidget(
        leadingName: _titulosAppBar[_currentIndex],
      ),
      bottomNavigationBar: CustomBottomNav(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTap,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        //physics: const NeverScrollableScrollPhysics(),
        children: [
          HomePageView(),
          const SearchPageView(),
          const CadastroPetView(),
          const PerfilUsuarioView(),
          const ConfigView(),
        ],
      ),
    );
  }
}
