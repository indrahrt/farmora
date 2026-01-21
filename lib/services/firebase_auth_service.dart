import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

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
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException catch (e) {
      throw _translateError(e);
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
    }
  }

  /// ===============================
  /// GOOGLE LOGIN / REGISTER
  /// ===============================
  Future<void> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
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
    } on FirebaseAuthException catch (e) {
      throw _translateError(e);
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
        return 'Email sudah digunakan, silakan gunakan email lain.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'weak-password':
        return 'Kata sandi terlalu lemah (minimal 6 karakter).';
      case 'user-not-found':
        return 'Akun tidak ditemukan.';
      case 'wrong-password':
        return 'Kata sandi salah.';
      case 'user-disabled':
        return 'Akun ini telah dinonaktifkan.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan, silakan coba lagi nanti.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah.';
      default:
        return 'Terjadi kesalahan. Silakan coba lagi.';
    }
  }
}
