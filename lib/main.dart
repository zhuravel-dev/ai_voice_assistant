import 'package:flutter/material.dart';
import 'infra/initializations/initializer.dart';
import 'infra/initializations/registers/providers_initializer.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Initializer.initializeConfigurations();

  final blocProviders = await ProvidersInitializer.initialize();

  runApp(App(blocProviders: blocProviders));
}
