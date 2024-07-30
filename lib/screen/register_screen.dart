import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:telegramm/screen/chat_screen.dart';
import 'package:telegramm/screen/login_screen.dart';
import 'package:telegramm/service/firebase_auth_service.dart';
import 'package:telegramm/utils/helpers.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
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
          return ChatScreen();
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
              "REGISTER",
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
                child: const Text("REGISTER"),
              ),
            ),
            TextButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const LoginScreen();
                }));
              },
              child: const Text("Akkauntingiz bormi? Kiring"),
            ),
          ],
        ),
      ),
    );
  }
}
