import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/celengan_model.dart';

class ApiService {
  // Gunakan 'localhost' untuk Real Device (HP Fisik) / Web, atau '10.0.2.2' untuk Emulator Android
  static const String baseUrl = 'http://localhost/api-celenganku/celengan.php';

  // 1. READ: Mengambil seluruh daftar celengan user secara asinkron
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

  // 2. CREATE: Menambahkan celengan target baru ke MySQL
  Future<bool> createCelengan(String nama, double target, {String emoji = '💰'}) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          'nama': nama,
          'target': target,
          'emoji': emoji, // Menyimpan simbol pelacak keuangan pilihan
        }),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == true;
      }
      return false;
    } catch (e) {
      print('Error pada CreateCelengan: $e');
      return false;
    }
  }

  // 3. UPDATE: Mengubah nama atau nominal target celengan
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
      print('Error pada UpdateCelengan: $e');
      return false;
    }
  }

  // 4. DELETE: Menghapus celengan dari sistem database
  Future<bool> deleteCelengan(int id) async {
    try {
      final response = await http.delete(Uri.parse('$baseUrl/$id'));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        return responseData['status'] == true;
      }
      return false;
    } catch (e) {
      print('Error pada DeleteCelengan: $e');
      return false;
    }
  }

  // 5. UPDATE SALDO: Menabung ke celengan tertentu
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
      print('Error pada TambahSaldoCelengan: $e');
      return false;
    }
  }
}