import 'package:flutter/material.dart';
import 'app.dart';
import 'infrastructure/initializations/initializer.dart';
import 'infrastructure/initializations/registers/providers_initializer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Initializer.initializeConfigurations();

  final blocProviders = await ProvidersInitializer.initialize();

  runApp(App(blocProviders: blocProviders));
}
