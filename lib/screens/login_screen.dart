import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isGoogleLoading = false;

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Masuk Aplikasi'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Selamat Datang Kembali!',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username / Email',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                
                // ========================================================
                // BUTTON LOGIN BIASA
                // ========================================================
                ElevatedButton(
                  onPressed: _isGoogleLoading 
                    ? null 
                    : () async {
                        if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Username dan password tidak boleh kosong.')),
                          );
                          return;
                        }

                        // AMBIL NAVIGATOR STATE SEBELUM ASYNC GAP
                        final navigator = Navigator.of(context);

                        final mockResponse = {
                          'status': true,
                          'token': 'secret_token_12345_celenganku',
                          'user': {
                            'id': 1,
                            'nama': _usernameController.text,
                          }
                        };

                        if (mockResponse['status'] == true) {
                          final prefs = await SharedPreferences.getInstance();
                          await prefs.setString('token', mockResponse['token'] as String);
                          await prefs.setInt('user_id', (mockResponse['user'] as Map)['id'] as int);
                          await prefs.setString('user_name', (mockResponse['user'] as Map)['nama'] as String);

                          if (!mounted) return;
                          
                          // Eksekusi via variabel lokal, 100% aman dari async gaps
                          navigator.pushReplacementNamed('/home');
                        }
                      },
                  child: const Text('Masuk'),
                ),
                
                const SizedBox(height: 12),
                const Row(
                  children: [
                    Expanded(child: Divider()),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text('atau', style: TextStyle(color: Colors.grey)),
                    ),
                    Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 12),

                // ========================================================
                // INTEGRASI TOMBOL GOOGLE SIGN-IN
                // ========================================================
                OutlinedButton.icon(
                  icon: _isGoogleLoading
                      ? const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(
                        Icons.login,
                        size: 18,
                      ),
                      // : Image.asset(
                      //     'assets/images/google.png',
                      //     height: 18,
                      //   )
                      label: const Text('Masuk dengan Akun Google'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Colors.grey),
                  ),
                  onPressed: _isGoogleLoading
                      ? null 
                      : () async {
                          setState(() {
                            _isGoogleLoading = true;
                          });

                          // AMBIL INSTANCE STATE SEBELUM ASYNC GAP
                          final navigator = Navigator.of(context);
                          final messenger = ScaffoldMessenger.of(context);

                          final authService = AuthService();
                          final userCred = await authService.signInWithGoogle();

                          if (!mounted) return;

                          setState(() {
                            _isGoogleLoading = false;
                          });

                          if (userCred != null) {
                            // Eksekusi via variabel lokal
                            navigator.pushReplacementNamed('/home');
                          } else {
                            // Eksekusi via variabel lokal
                            messenger.showSnackBar(
                              const SnackBar(
                                content: Text('Proses masuk dengan Google dibatalkan/gagal.'),
                              ),
                            );
                          }
                        },
                ),
                
                const SizedBox(height: 16),
                TextButton(
                  onPressed: () => Navigator.pushNamed(context, '/register'),
                  child: const Text('Belum punya akun? Daftar di sini'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}