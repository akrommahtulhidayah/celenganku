import 'package:flutter/material.dart';
import '../models/celengan_model.dart'; 

class CelenganCard extends StatelessWidget {
  final CelenganModel celengan;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CelenganCard({
    super.key,
    required this.celengan,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.amber.shade50,
          radius: 24,
          child: Text(
            celengan.emoji.isNotEmpty ? celengan.emoji : '🪙',
            style: const TextStyle(fontSize: 24),
          ),
        ),
        title: Text(
          celengan.nama,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4), // PERBAIKAN: Menggunakan .only()
          child: Text(
            'Target: Rp ${celengan.target.toStringAsFixed(0)}',
            style: TextStyle(
              color: Colors.green.shade700,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.blue),
              tooltip: 'Ubah Celengan',
              onPressed: onEdit, 
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              tooltip: 'Hapus Celengan',
              onPressed: onDelete, 
            ),
          ],
        ),
      ),
    );
  }
}