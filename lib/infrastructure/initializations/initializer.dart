import 'package:ai_voice_assistant/infrastructure/initializations/registers/api_initializer.dart';
import 'package:ai_voice_assistant/infrastructure/initializations/registers/repositories_initializer.dart';

abstract class Initializer {
  static Future<void> initializeConfigurations() async {
    ApiInitializer.initialize();
    RepositoriesInitializer.initialize(useFake: true);
  }
}
