import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../login/pages/login.dart';
import '../../beranda/pages/beranda.dart';
import '../controller/daftar_controller.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  DateTime? lastPressed;

  bool _isObscure = true;
  bool _isLoadingEmail = false;

  late final DaftarController controller;

  @override
  void initState() {
    super.initState();
    controller = DaftarController();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;

        final now = DateTime.now();
        if (lastPressed == null ||
            now.difference(lastPressed!) > const Duration(seconds: 2)) {
          lastPressed = now;
          _showSnackBar('Tekan sekali lagi untuk keluar');
        } else {
          SystemNavigator.pop();
        }
      },
      child: Scaffold(body: Stack(children: [_background(), _registerCard()])),
    );
  }

  /// ===============================
  /// BACKGROUND
  /// ===============================
  Widget _background() {
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/background.png'),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  /// ===============================
  /// REGISTER CARD
  /// ===============================
  Widget _registerCard() {
    return Center(
      child: SingleChildScrollView(
        child: Container(
          width: 350,
          padding: const EdgeInsets.symmetric(vertical: 35, horizontal: 25),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Daftar",
                style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 30),

              /// GOOGLE REGISTER (TANPA LOADING)
              OutlinedButton.icon(
                onPressed: _registerGoogle,
                icon: Image.asset('assets/images/google.png', height: 22),
                label: const Text(
                  "Daftar dengan Google",
                  style: TextStyle(color: Colors.black54),
                ),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                  shape: const StadiumBorder(),
                  side: const BorderSide(color: Color(0xFFEEEEEE)),
                ),
              ),

              const Padding(
                padding: EdgeInsets.symmetric(vertical: 15),
                child: Text("atau", style: TextStyle(color: Colors.grey)),
              ),

              _textField(
                hint: "Nama lengkap",
                controller: controller.nameController,
              ),
              const SizedBox(height: 15),

              _textField(hint: "Email", controller: controller.emailController),
              const SizedBox(height: 15),

              _textField(
                hint: "Kata sandi",
                isPassword: true,
                controller: controller.passwordController,
              ),
              const SizedBox(height: 25),

              /// REGISTER EMAIL (PAKAI LOADING)
              ElevatedButton(
                onPressed: _isLoadingEmail ? null : _registerEmail,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 29, 88, 11),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: _isLoadingEmail
                    ? const SizedBox(
                        height: 22,
                        width: 22,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text(
                        "Buat Akun",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
              ),

              const SizedBox(height: 20),
              const Text(
                "Dengan mendaftar akun, Anda menyetujui\nKebijakan Privasi dan Ketentuan Layanan.",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Punya akun? "),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                    child: const Text(
                      "Masuk di sini",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline,
                        color: Color.fromARGB(255, 29, 88, 11),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// ===============================
  /// TEXT FIELD
  /// ===============================
  Widget _textField({
    required String hint,
    bool isPassword = false,
    TextEditingController? controller,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword ? _isObscure : false,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: const Color(0xFFF5F5F5),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 18,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  _isObscure
                      ? Icons.visibility_outlined
                      : Icons.visibility_off_outlined,
                ),
                onPressed: () {
                  setState(() => _isObscure = !_isObscure);
                },
              )
            : null,
      ),
    );
  }

  /// ===============================
  /// REGISTER EMAIL
  /// ===============================
  Future<void> _registerEmail() async {
    setState(() => _isLoadingEmail = true);

    final error = await controller.register();

    if (!mounted) return;

    setState(() => _isLoadingEmail = false);

    if (error == null) {
      _showSnackBar('Registrasi berhasil');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      _showSnackBar(error);
    }
  }

  /// ===============================
  /// REGISTER GOOGLE (LANGSUNG BERANDA)
  /// ===============================
  Future<void> _registerGoogle() async {
    final error = await controller.registerWithGoogle();

    if (!mounted) return;

    if (error == null) {
      _showSnackBar('Berhasil masuk dengan Google');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const BerandaPage()),
      );
    } else {
      _showSnackBar(error);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }
}
