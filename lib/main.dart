import 'package:adota_facil/controller/controllers/home_controller.dart';
import 'package:adota_facil/firebase_options.dart';
import 'package:adota_facil/model/repositories/animal_repository.dart';
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
        ChangeNotifierProvider(
          create: (_) =>
              HomeController(AnimalRepositoryImpl())..carregarAnimais(),
        ),
      ],
      child: const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: BasePageView(),
      ),
    );
  }
}
