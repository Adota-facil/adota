import 'package:adota_facil/view/pages/cadastro_pet_view.dart';
import 'package:adota_facil/view/pages/cadastro_usuario_view.dart';
import 'package:adota_facil/view/pages/perfil_pet_view.dart';
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
      

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const CadastroPetView()),
            );
          },
          child: const Text('Ir para pagina de Cadastro de usuario'),
        ),
      ),
    );
  }
}
