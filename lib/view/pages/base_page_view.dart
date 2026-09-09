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
  static const double _alturaNav = 140;
  static const double _limiarParaAlternar = 8.0;

  int _currentIndex = 0;
  final PageController _pageController = PageController();
  bool _mostrarNav = true;
  double _deltaAcumulado = 0;

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
      _mostrarNav = true; // sempre visível ao trocar de aba
      _deltaAcumulado = 0;
    });
  }

  void _onBottomNavTap(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  bool _aoRolar(ScrollNotification notification) {
    // Ignora o swipe horizontal do PageView (troca de aba) — só reage
    // a rolagem vertical de conteúdo dentro da página atual.
    if (notification.metrics.axis != Axis.vertical) return false;

    if (notification is ScrollUpdateNotification) {
      final delta = notification.scrollDelta ?? 0;
      _deltaAcumulado += delta;

      if (_deltaAcumulado > _limiarParaAlternar && _mostrarNav) {
        setState(() => _mostrarNav = false); // rolando pra baixo -> esconde
        _deltaAcumulado = 0;
      } else if (_deltaAcumulado < -_limiarParaAlternar && !_mostrarNav) {
        setState(() => _mostrarNav = true); // rolando pra cima -> mostra
        _deltaAcumulado = 0;
      }
    } else if (notification is ScrollEndNotification) {
      _deltaAcumulado = 0;
    }
    return false; // deixa a notificação continuar subindo normalmente
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
      body: NotificationListener<ScrollNotification>(
        onNotification: _aoRolar,
        child: Stack(
          children: [
            PageView(
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
            AnimatedPositioned(
              duration: const Duration(milliseconds: 320),
              curve: Curves.easeOutCubic,
              left: 0,
              right: 0,
              bottom: _mostrarNav ? 0 : -_alturaNav,
              child: CustomBottomNav(
                currentIndex: _currentIndex,
                onTap: _onBottomNavTap,
              ),
            ),
          ],
        ),
      ),
    );
  }
}