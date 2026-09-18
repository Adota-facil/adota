import 'package:adota_facil/services/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
class FirebaseAnalyticsService implements AnalyticsService {
  final FirebaseAnalytics _analytics;

  FirebaseAnalyticsService({FirebaseAnalytics? analytics})
      : _analytics = analytics ?? FirebaseAnalytics.instance;

  @override
  Future<void> logPetCadastrado({required String especie}) {
    return _analytics.logEvent(
      name: 'pet_cadastrado',
      parameters: {'especie': especie},
    );
  }

  @override
  Future<void> logFiltroCategoriaUsado({required String categoria}) {
    return _analytics.logEvent(
      name: 'filtro_categoria_usado',
      parameters: {'categoria': categoria},
    );
  }

  @override
  Future<void> logTelaVisualizada({required String nomeTela}) {
    return _analytics.logScreenView(screenName: nomeTela);
  }
}