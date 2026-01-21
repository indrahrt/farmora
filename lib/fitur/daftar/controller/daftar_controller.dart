import 'package:flutter/material.dart';
import '../../../services/firebase_auth_service.dart';

class DaftarController {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  final authService = FirebaseAuthService.instance;

  Future<String?> register() async {
    if (nameController.text.isEmpty ||
        emailController.text.isEmpty ||
        passwordController.text.isEmpty) {
      return 'Semua data wajib diisi.';
    }

    try {
      await authService.registerWithEmail(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String?> registerWithGoogle() async {
    try {
      await authService.signInWithGoogle();
      return null;
    } catch (e) {
      return e.toString();
    }
  }

  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
  }
}
