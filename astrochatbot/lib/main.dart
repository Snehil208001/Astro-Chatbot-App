import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/login_screen.dart';

void main() async {
  // Required for async operations in main
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase (uses google-services.json)
  await Firebase.initializeApp();
  runApp(const AstroChatbotApp());
}

class AstroChatbotApp extends StatelessWidget {
  const AstroChatbotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Astro Chatbot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepOrange),
        useMaterial3: true,
        // Using Google Fonts for a more spiritual/clean look
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}