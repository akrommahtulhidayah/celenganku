import 'package:flutter/material.dart';
import '../models/celengan_model.dart';
import '../services/api_service.dart';
import '../widgets/celengan_card.dart'; 

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ApiService _apiService = ApiService();

  // ========================================================
  // 1. DIALOG FORM (CREATE & UPDATE)
  // ========================================================
  void _bukaFormDialog([CelenganModel? celengan]) {
    final isEdit = celengan != null;
    final namaController = TextEditingController(text: isEdit ? celengan.nama : '');
    final targetController = TextEditingController(text: isEdit ? celengan.target.toString() : '');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(isEdit ? 'Ubah Celengan' : 'Buat Celengan Baru'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: namaController,
              decoration: const InputDecoration(labelText: 'Nama Celengan (Impian)'),
            ),
            TextField(
              controller: targetController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Target Nominal (Rp)'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (namaController.text.isEmpty || targetController.text.isEmpty) return;

              final nama = namaController.text;
              final target = double.parse(targetController.text);
              bool sukses = false;

              if (isEdit) {
                sukses = await _apiService.updateCelengan(celengan.id, nama, target);
              } else {
                sukses = await _apiService.createCelengan(nama, target, emoji: '🪙');
              }

              // Mencegah kebocoran context setelah operasi asinkronus selesai
              if (!mounted) return;

              if (sukses) {
                Navigator.of(context).pop(); // Berhasil: Menutup dialog dengan context state yang valid
                setState(() {}); // Segarkan UI
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menyimpan data ke server.')),
                );
              }
            },
            child: Text(isEdit ? 'Simpan' : 'Tambah'),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // 2. DIALOG KONFIRMASI HAPUS (DELETE)
  // ========================================================
  void _konfirmasiHapus(int id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus celengan?'),
        content: const Text('Data yang terhapus dari database tidak bisa dikembalikan.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () async {
              bool sukses = await _apiService.deleteCelengan(id);

              if (!mounted) return;

              if (sukses) {
                Navigator.of(context).pop(); // Berhasil: Menutup dialog konfirmasi hapus
                setState(() {}); // Segarkan UI
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Gagal menghapus data dari server.')),
                );
              }
            },
            child: const Text('Hapus', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // ========================================================
  // 3. WIDGET INTERFACE UTAMA (READ)
  // ========================================================
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('CelenganKu'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<CelenganModel>>(
        future: _apiService.getAllCelengan(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'Belum ada data celengan.\nMulai buat celengan pertamamu!',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            );
          }

          final listData = snapshot.data!;
          return ListView.builder(
            itemCount: listData.length,
            itemBuilder: (context, i) {
              return CelenganCard(
                celengan: listData[i],
                onEdit: () => _bukaFormDialog(listData[i]),
                onDelete: () => _konfirmasiHapus(listData[i].id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _bukaFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}