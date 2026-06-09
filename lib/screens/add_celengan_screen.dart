import 'package:flutter/material.dart';

class AddCelenganScreen extends StatelessWidget {
  const AddCelenganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tambah Impian'),
      ),
      body: const SafeArea(
        child: Center(
          child: Text('Formulir Tambah Data (Gunakan tombol + di halaman utama)'),
        ),
      ),
    );
  }
}