import 'package:ai_voice_assistant/infra/initializations/registers/api_initializer.dart';
import 'package:ai_voice_assistant/infra/initializations/registers/providers_initializer.dart';
import 'package:ai_voice_assistant/infra/initializations/registers/repositories_initializer.dart';

abstract class Initializer {
  static Future<void> initializeConfigurations() async {
    ApiInitializer.initialize();
    RepositoriesInitializer.initialize();
    await ProvidersInitializer.initialize();
  }
}