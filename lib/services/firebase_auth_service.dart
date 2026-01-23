import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/services.dart';

class FirebaseAuthService {
  FirebaseAuthService._();
  static final FirebaseAuthService instance = FirebaseAuthService._();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  /// ===============================
  /// LOGIN EMAIL
  /// ===============================
  Future<void> loginWithEmail({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty && password.isEmpty) {
      throw 'Email dan kata sandi wajib diisi.';
    }
    if (email.isEmpty) {
      throw 'Email wajib diisi.';
    }
    if (password.isEmpty) {
      throw 'Kata sandi wajib diisi.';
    }

    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _translateError(e);
    } on PlatformException {
      throw 'Tidak ada koneksi internet. Silakan periksa jaringan Anda.';
    } catch (_) {
      throw 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  /// ===============================
  /// REGISTER EMAIL
  /// ===============================
  Future<void> registerWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      throw 'Semua data wajib diisi.';
    }

    try {
      final result = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      await _firestore.collection('users').doc(result.user!.uid).set({
        'uid': result.user!.uid,
        'name': name,
        'email': email,
        'provider': 'email',
        'createdAt': Timestamp.now(),
      });
    } on FirebaseAuthException catch (e) {
      throw _translateError(e);
    } on PlatformException {
      throw 'Tidak ada koneksi internet. Silakan periksa jaringan Anda.';
    } catch (_) {
      throw 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  /// ===============================
  /// GOOGLE LOGIN / REGISTER
  /// ===============================
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      // User batal login
      if (googleUser == null) return;

      final googleAuth = await googleUser.authentication;

      final credential = GoogleAuthProvider.credential(
        idToken: googleAuth.idToken,
        accessToken: googleAuth.accessToken,
      );

      final result = await _auth.signInWithCredential(credential);

      final userDoc = _firestore.collection('users').doc(result.user!.uid);

      if (!(await userDoc.get()).exists) {
        await userDoc.set({
          'uid': result.user!.uid,
          'name': result.user!.displayName,
          'email': result.user!.email,
          'photo': result.user!.photoURL,
          'provider': 'google',
          'createdAt': Timestamp.now(),
        });
      }
    }
    // 🔴 ERROR GOOGLE / ANDROID (TANPA INTERNET)
    on PlatformException catch (e) {
      if (e.code == 'network_error') {
        throw 'Tidak ada koneksi internet. Silakan periksa jaringan Anda.';
      }
      throw 'Login Google gagal. Silakan coba lagi.';
    }
    // 🔴 ERROR FIREBASE
    on FirebaseAuthException catch (e) {
      throw _translateError(e);
    }
    // 🔴 ERROR LAIN
    catch (_) {
      throw 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }

  /// ===============================
  /// LOGOUT
  /// ===============================
  Future<void> logout() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  /// ===============================
  /// TERJEMAHAN ERROR FIREBASE
  /// ===============================
  String _translateError(FirebaseAuthException e) {
    switch (e.code) {
      case 'email-already-in-use':
        return 'Email sudah digunakan.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah (minimal 6 karakter).';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Email atau kata sandi salah.';
      case 'user-disabled':
        return 'Akun telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan coba lagi nanti.';
      case 'network-request-failed':
        return 'Tidak ada koneksi internet.';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
