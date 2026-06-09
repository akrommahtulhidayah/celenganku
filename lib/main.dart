import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_celengan_screen.dart';
import 'screens/detail_celengan_screen.dart';

void main() async {
  // Memastikan binding Flutter siap sebelum membaca SharedPreferences
  WidgetsFlutterBinding.ensureInitialized();
  
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString('token');

  runApp(CelenganKuApp(initialRoute: token != null ? '/home' : '/login'));
}

class CelenganKuApp extends StatelessWidget {
  final String initialRoute;
  
  const CelenganKuApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CelenganKu',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
        useMaterial3: true,
      ),
      // Rute awal ditentukan berdasarkan keberadaan token sesi
      initialRoute: initialRoute,
      routes: {
        '/splash': (context) => const SplashScreen(),
        '/login': (context) => const LoginScreen(),
        '/register': (context) => const RegisterScreen(),
        '/home': (context) => const HomeScreen(),
        '/add-celengan': (context) => const AddCelenganScreen(),
        '/detail-celengan': (context) => const DetailCelenganScreen(),
      },
    );
  }
}