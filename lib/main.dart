import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_celengan_screen.dart';
import 'screens/detail_celengan_screen.dart';

void main() {
  runApp(const CelenganKuApp());
}

class CelenganKuApp extends StatelessWidget {
  const CelenganKuApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CelenganKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Rute awal aplikasi mengarah ke Splash Screen
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-celengan': (context) => const AddCelenganScreen(),
        '/detail-celengan': (context) => const DetailCelenganScreen(),
      },
    );
  }
}