import 'package:flutter/material.dart'; // Wajib ada agar debugPrint dikenali
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      // 1. Memicu alur interaksi pop-up akun Google di HP
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null; 

      // 2. Mengambil detail autentikasi dari akun
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // 3. Membuat kredensial baru untuk Firebase
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // 4. Masuk ke Firebase menggunakan kredensial Google
      final UserCredential userCredential = await _auth.signInWithCredential(credential);

      // 5. Simpan nama pengguna ke SharedPreferences sebagai sesi lokal
      final prefs = await SharedPreferences.getInstance();
      
      await prefs.setString('token', 'secret_token_12345_celenganku'); 
      await prefs.setString('user_name', userCredential.user!.displayName ?? 'Pengguna Google');
      await prefs.setInt('user_id', 1); 
      
      return userCredential;
    } catch (e) {
      debugPrint("Error saat Google Sign-In: $e");
      return null;
    }
  }
}