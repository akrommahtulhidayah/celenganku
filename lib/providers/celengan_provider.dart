import 'package:flutter/material.dart';
import '../models/celengan_model.dart';
import '../services/api_service.dart';

class CelenganProvider extends ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<CelenganModel> _listCelengan = [];
  bool _isLoading = false;

  // Getter untuk diakses oleh UI/Widget
  List<CelenganModel> get listCelengan => _listCelengan;
  bool get isLoading => _isLoading;

  // Menghitung total target akumulatif dari semua celengan secara global
  double get totalTargetAkumulatif =>
      _listCelengan.fold(0, (sum, item) => sum + item.target);

  // 1. FETCH DATA (READ)
  Future<void> fetchAllCelengan() async {
    _isLoading = true;
    notifyListeners(); // Beritahu UI untuk menampilkan loading spinner

    try {
      _listCelengan = await _apiService.getAllCelengan();
    } catch (e) {
      debugPrint('Error fetch data pada Provider: $e');
      _listCelengan = [];
    } finally {
      _isLoading = false;
      notifyListeners(); // Beritahu UI bahwa data selesai dimuat
    }
  }

  // 2. TAMBAH DATA (CREATE)
  Future<bool> addCelengan(String nama, double target) async {
    bool sukses = await _apiService.createCelengan(nama, target, emoji: '🪙');
    if (sukses) {
      await fetchAllCelengan(); // Sinkronisasi otomatis daftar data terbaru
    }
    return sukses;
  }

  // 3. UBAH DATA (UPDATE)
  Future<bool> editCelengan(int id, String nama, double target) async {
    bool sukses = await _apiService.updateCelengan(id, nama, target);
    if (sukses) {
      await fetchAllCelengan(); // Perbarui state data global
    }
    return sukses;
  }

  // 4. HAPUS DATA (DELETE)
  Future<bool> removeCelengan(int id) async {
    bool sukses = await _apiService.deleteCelengan(id);
    if (sukses) {
      await fetchAllCelengan(); // Bersihkan data dari state global
    }
    return sukses;
  }
}