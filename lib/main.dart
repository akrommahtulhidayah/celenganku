import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'firebase_options.dart';

import 'providers/celengan_provider.dart';

import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/home_screen.dart';
import 'screens/add_celengan_screen.dart';
import 'screens/detail_celengan_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  final prefs = await SharedPreferences.getInstance();

  final String? token = prefs.getString('token');

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CelenganProvider(),
        ),
      ],
      child: CelenganKuApp(
        isLoggedIn: token != null,
      ),
    ),
  );
}

class CelenganKuApp extends StatelessWidget {
  final bool isLoggedIn;

  const CelenganKuApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'CelenganKu',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.blue,
      ),

      // LANGKAH 11
      home: isLoggedIn
          ? const HomeScreen()
          : const LoginScreen(),

      routes: {
        '/login': (context) => const LoginScreen(),

        '/register': (context) => const RegisterScreen(),

        '/home': (context) => const HomeScreen(),

        '/add-celengan': (context) =>
            const AddCelenganScreen(),

        '/detail-celengan': (context) =>
            const DetailCelenganScreen(),
      },
    );
  }
}