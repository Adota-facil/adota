import 'package:adota_facil/controllers/auth_controller.dart';
import 'package:adota_facil/controllers/home_controller.dart';
import 'package:adota_facil/controllers/notificacao_controller.dart';
import 'package:adota_facil/firebase_options.dart';
import 'package:adota_facil/models/repositories/animal_repository.dart';
import 'package:adota_facil/models/repositories/auth_repository.dart';
import 'package:adota_facil/models/repositories/usuario_repository.dart';
import 'package:adota_facil/services/armazenamento_base64.dart';
import 'package:adota_facil/services/firebase_analytics_service.dart';
import 'package:adota_facil/view/widgets/base_page_widget.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => NotificacaoController()),
        ChangeNotifierProvider(
          create: (context) => HomeController(
            AnimalRepositoryImpl(),
            ArmazenamentoBase64(),
            FirebaseAnalyticsService(),
            aoAtualizarAnimais:
                context.read<NotificacaoController>().atualizarPets,
          )..carregarAnimais(),
        ),
        ChangeNotifierProvider(
          create: (_) => AuthController(
            AuthRepositoryImpl(),
            UsuarioRepositoryImpl(),
          ),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BasePageView(),
      ),
    );
  }
}