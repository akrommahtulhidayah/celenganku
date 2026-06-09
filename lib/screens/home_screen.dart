import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  String _userName = 'Pengguna'; // Variabel penampung nama pengguna dari sesi

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Muat data sesi saat halaman pertama kali dibuka
  }

  // Fungsi membaca data dari SharedPreferences
  void _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pengguna';
    });
  }

  // Fungsi menghapus sesi ketika tombol logout ditekan
  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Menghapus seluruh token, id, dan nama user di lokal

    if (!mounted) return;
    // Pindahkan pengguna kembali ke halaman login secara bersih
    Navigator.pushReplacementNamed(context, '/login');
  }

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

              if (!mounted) return;

              if (sukses) {
                Navigator.of(context).pop(); 
                setState(() {}); // Segarkan UI (Read ulang data)
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
                Navigator.of(context).pop(); 
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
        title: Text('CelenganKu ($_userName)'), // MENAMPILKAN BUKTI SESI USER AKTIF
        centerTitle: false,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.red),
            tooltip: 'Keluar Akun',
            onPressed: _logout, // Memicu proses hapus sesi
          ),
        ],
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