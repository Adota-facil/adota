import 'package:adota_facil/controller/controllers/home_controller.dart';
import 'package:adota_facil/firebase_options.dart';
import 'package:adota_facil/model/models/repositories/animal_repository.dart';
import 'package:adota_facil/view/pages/base_page_view.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// Precisa ser uma função top-level (fora de qualquer classe) para funcionar em background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  print('Notificação recebida em background: ${message.notification?.title}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Registra o handler de notificações em background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Pede permissão pro usuário (obrigatório no iOS)
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission(
    alert: true,
    badge: true,
    sound: true,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Listener para notificações recebidas com o app aberto (foreground)
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Notificação recebida em foreground: ${message.notification?.title}');
    });

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