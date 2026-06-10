import 'dart:developer' as developer;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<UserCredential?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser =
          await _googleSignIn.signIn();

      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;

      final AuthCredential credential =
          GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      final UserCredential userCredential =
          await _auth.signInWithCredential(
        credential,
      );

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.setString(
        'token',
        userCredential.user?.uid ?? '',
      );

      await prefs.setString(
        'user_name',
        userCredential.user?.displayName ??
            'Pengguna Google',
      );

      await prefs.setInt(
        'user_id',
        1,
      );

      return userCredential;
    } catch (e, stackTrace) {
      developer.log(
        'Error saat Google Sign-In',
        error: e,
        stackTrace: stackTrace,
        name: 'celenganku.auth',
      );

      return null;
    }
  }

  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();

      await _auth.signOut();

      final prefs =
          await SharedPreferences.getInstance();

      await prefs.clear();
    } catch (e, stackTrace) {
      developer.log(
        'Error saat Sign Out',
        error: e,
        stackTrace: stackTrace,
        name: 'celenganku.auth',
      );
    }
  }
}