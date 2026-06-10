import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/celengan_model.dart';
import '../providers/celengan_provider.dart';
import '../widgets/celengan_card.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _userName = 'Pengguna';

  @override
  void initState() {
    super.initState();

    _loadUserData();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CelenganProvider>().fetchAllCelengan();
    });
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    if (!mounted) return;

    setState(() {
      _userName = prefs.getString('user_name') ?? 'Pengguna';
    });
  }

  Future<void> _logout() async {
    final navigator = Navigator.of(context);

    final authService = AuthService();

    await authService.signOut();

    if (!mounted) return;

    navigator.pushReplacementNamed('/login');
  }

  void _bukaFormDialog([CelenganModel? celengan]) {
    final bool isEdit = celengan != null;

    final namaController = TextEditingController(
      text: isEdit ? celengan.nama : '',
    );

    final targetController = TextEditingController(
      text: isEdit ? celengan.target.toString() : '',
    );

    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(
            isEdit ? 'Ubah Celengan' : 'Tambah Celengan',
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: namaController,
                decoration: const InputDecoration(
                  labelText: 'Nama Celengan',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: targetController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Target Nominal',
                ),
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
                final navigator = Navigator.of(ctx);
                final messenger =
                    ScaffoldMessenger.of(context);

                if (namaController.text.isEmpty ||
                    targetController.text.isEmpty) {
                  return;
                }

                final nama = namaController.text;

                final target =
                    double.tryParse(
                          targetController.text,
                        ) ??
                        0;

                final provider =
                    context.read<CelenganProvider>();

                bool sukses = false;

                if (isEdit) {
                  sukses =
                      await provider.editCelengan(
                    celengan!.id,
                    nama,
                    target,
                  );
                } else {
                  sukses =
                      await provider.addCelengan(
                    nama,
                    target,
                  );
                }

                if (!mounted) return;

                navigator.pop();

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      sukses
                          ? (isEdit
                              ? 'Data berhasil diubah'
                              : 'Data berhasil ditambahkan')
                          : 'Gagal menyimpan data',
                    ),
                  ),
                );
              },
              child: Text(
                isEdit ? 'Simpan' : 'Tambah',
              ),
            ),
          ],
        );
      },
    );
  }

  void _konfirmasiHapus(int id) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Hapus Celengan'),
          content: const Text(
            'Apakah Anda yakin ingin menghapus data ini?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () async {
                final navigator = Navigator.of(ctx);
                final messenger =
                    ScaffoldMessenger.of(context);

                final sukses = await context
                    .read<CelenganProvider>()
                    .removeCelengan(id);

                if (!mounted) return;

                navigator.pop();

                messenger.showSnackBar(
                  SnackBar(
                    content: Text(
                      sukses
                          ? 'Data berhasil dihapus'
                          : 'Gagal menghapus data',
                    ),
                  ),
                );
              },
              child: const Text(
                'Hapus',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider =
        context.watch<CelenganProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'CelenganKu ($_userName)',
        ),
        actions: [
          IconButton(
            onPressed: _logout,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: provider.isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : provider.listCelengan.isEmpty
              ? const Center(
                  child: Text(
                    'Belum ada data celengan.\nTekan tombol + untuk menambah.',
                    textAlign: TextAlign.center,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      color: Colors.blue.shade50,
                      child: Text(
                        'Total Target Tabungan : Rp ${provider.totalTargetAkumulatif.toStringAsFixed(0)}',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount:
                            provider.listCelengan.length,
                        itemBuilder: (context, index) {
                          final item =
                              provider.listCelengan[index];

                          return CelenganCard(
                            celengan: item,
                            onEdit: () =>
                                _bukaFormDialog(item),
                            onDelete: () =>
                                _konfirmasiHapus(
                              item.id,
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
      floatingActionButton:
          FloatingActionButton(
        onPressed: () => _bukaFormDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}