import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegramm/screen/contact_screen.dart';
import 'package:telegramm/screen/register_screen.dart';
import 'package:telegramm/service/firebase_auth_service.dart';
import 'package:telegramm/utils/helpers.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final firebaseAuthService = FirebaseAuthService();

  void submit() async {
    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      try {
        await firebaseAuthService.login(
          emailController.text,
          passwordController.text,
        );
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) {
          return ContactsScreen(
              currentUserId: FirebaseAuth.instance.currentUser!.uid);
        }));
      } on FirebaseAuthException catch (error) {
        Helpers.showErrorDialog(context, error.message ?? "Xatolik");
      } catch (e) {
        Helpers.showErrorDialog(context, "Tizimda xatolik");
      }
    } else {
      Helpers.showErrorDialog(
          context, "Iltimos, barcha maydonlarni to'ldiring.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "LOGIN",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Email",
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true, // Parolni yashirish uchun
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: "Parol",
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: submit,
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text("LOGIN"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const RegisterScreen();
                }));
              },
              child: const Text("Akkauntingiz yo'qmi? Registratsiyadan o'ting"),
            ),
          ],
        ),
      ),
    );
  }
}
