import 'dart:convert';
import 'package:flutter/material.dart'; // Ditambahkan untuk mendukung debugPrint jika diperlukan
import 'package:http/http.dart' as http;
import '../models/celengan_model.dart';

class ApiService {
  static const String baseUrl = 'http://localhost/api-celenganku/celengan.php';

  // 1. READ: Ambil data
  Future<List<CelenganModel>> getAllCelengan() async {
    try {
      final response = await http.get(Uri.parse(baseUrl));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (responseData['status'] == true) {
          final List<dynamic> listData = responseData['data'];
          return listData.map((json) => CelenganModel.fromJson(json)).toList();
        } else {
          throw Exception(responseData['message'] ?? 'Gagal memuat data celengan.');
        }
      } else {
        throw Exception('Koneksi server bermasalah (Status: ${response.statusCode})');
      }
    } catch (e) {
      throw Exception('Gagal terhubung ke API: $e');
    }
  }

  // 2. CREATE: Tambah celengan
  Future<bool> createCelengan(String nama, double target, {String emoji = '💰'}) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama': nama,
          'target': target,
          'emoji': emoji,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == true;
      }
      return false;
    } catch (e) {
      // PERBAIKAN: Menggunakan debugPrint menggantikan print biasa
      debugPrint('Error pada CreateCelengan: $e');
      return false;
    }
  }

  // 3. UPDATE: Edit celengan
  Future<bool> updateCelengan(int id, String nama, double target) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/$id'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama': nama,
          'target': target,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == true;
      }
      return false;
    } catch (e) {
      // PERBAIKAN: Menggunakan debugPrint menggantikan print biasa
      debugPrint('Error pada UpdateCelengan: $e');
      return false;
    }
  }

  // 4. DELETE: Hapus celengan
  Future<bool> deleteCelengan(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == true;
      }
      return false;
    } catch (e) {
      // PERBAIKAN: Menggunakan debugPrint menggantikan print biasa
      debugPrint('Error pada DeleteCelengan: $e');
      return false;
    }
  }

  // 5. UPDATE SALDO: Menabung
  Future<bool> tambahSaldoCelengan(int id, double nominal) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/$id/tambah'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nominal': nominal,
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == true;
      }
      return false;
    } catch (e) {
      // PERBAIKAN: Menggunakan debugPrint menggantikan print biasa
      debugPrint('Error pada TambahSaldoCelengan: $e');
      return false;
    }
  }
}