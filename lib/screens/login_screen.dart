import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

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
                ElevatedButton(
                  onPressed: () async {
                    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Username dan password tidak boleh kosong.')),
                      );
                      return;
                    }

                    // MOCKUP RESPONS API (Nanti bisa disambungkan dengan ApiService Anda)
                    final mockResponse = {
                      'status': true,
                      'token': 'secret_token_12345_celenganku',
                      'user': {
                        'id': 1,
                        'nama': _usernameController.text, // Mengambil input user untuk nama di sesi
                      }
                    };

                    if (mockResponse['status'] == true) {
                      // 1. Inisialisasi SharedPreferences
                      final prefs = await SharedPreferences.getInstance();
                      
                      // 2. Simpan data sesi ke penyimpanan lokal perangkat
                      await prefs.setString('token', mockResponse['token'] as String);
                      await prefs.setInt('user_id', (mockResponse['user'] as Map)['id'] as int);
                      await prefs.setString('user_name', (mockResponse['user'] as Map)['nama'] as String);

                      // Proteksi async gap untuk memastikan widget masih aktif di dalam tree
                      if (!mounted) return;

                      // 3. Arahkan pengguna langsung ke halaman utama
                      Navigator.pushReplacementNamed(context, '/home');
                    }
                  },
                  child: const Text('Masuk'),
                ),
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