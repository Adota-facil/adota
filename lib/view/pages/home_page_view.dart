import 'package:adota_facil/view/widgets/appBar_Widget.dart';
import 'package:adota_facil/view/widgets/custom_bottom_nav.dart';
import 'package:flutter/material.dart';

class HomePageView extends StatelessWidget {
  const HomePageView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.white,
      appBar: AppbarWidget(leadingName: "Bem vindo! \n Eduardo"),
     bottomNavigationBar: CustomBottomNav(
        currentIndex: 0, // Deixa a aba "Início" sempre marcada por enquanto
        onTap: (index) {// Função vazia: não faz nada quando o usuário clica
        },
      ),
    );
  }
}
