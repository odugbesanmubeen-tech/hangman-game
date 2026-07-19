import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hangman_game/homepage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF7E57C2),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Your logo/image
            const CircleAvatar(
              radius: 70,
              backgroundImage: AssetImage("asset/images/lasa.jpg"),
            ),

            const SizedBox(height: 25),

            const Text(
              "Hangman game",
              style: TextStyle(
                color: Colors.white,
                fontSize: 30,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 10),

            const Text(
              "Enjoy Your Moment With Hangman ",
              style: TextStyle(color: Colors.white70, fontSize: 16),
            ),

            const SizedBox(height: 40),

            const CircularProgressIndicator(color: Colors.white),
          ],
        ),
      ),
    );
  }
}
