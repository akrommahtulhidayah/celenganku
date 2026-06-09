import 'package:flutter/material.dart';

class DetailCelenganScreen extends StatelessWidget {
  const DetailCelenganScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detail Celenganku'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Card(
                color: Colors.blue.shade50,
                child: const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Text('🪙', style: TextStyle(fontSize: 40)),
                      SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Target Impian', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                          Text('Status Koneksi API: Aktif', style: TextStyle(color: Colors.green)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Text('Riwayat Menabung:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Expanded(
                child: Center(
                  child: Text('Belum ada riwayat transaksi.', style: TextStyle(color: Colors.grey)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}