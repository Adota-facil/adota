import 'package:adota_facil/services/analytics_service.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

/// Implementação concreta de [AnalyticsService] usando o Firebase Analytics.
/// Eventos pensados pro que o adota_facil realmente faz — cadastro de pet,
/// uso de filtro por categoria e visualização de tela — bem diferente de
/// eventos de e-commerce como logBeginCheckout, que não se aplicam aqui
/// (o app não vende nada, não tem carrinho nem cupom).
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