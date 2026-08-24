import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'pagina_principale.dart';
import 'phoenix_viewport.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Solo Android/iOS: modalità orizzontale
  if (!kIsWeb) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
    ]);
  }

  runApp(const MyApp());
}

// Widget principale dell'app
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Points Counter - Phoenix',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: kIsWeb
          ? const PhoenixViewport(
        child: HomeScreen(),
      )
          : const HomeScreen(),
    );
  }
}