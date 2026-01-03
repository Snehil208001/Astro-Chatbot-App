import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Load Environment Variables with error handling
  try {
    await dotenv.load(fileName: ".env");
    print("✅ SUCCESS: .env file loaded.");
  } catch (e) {
    print("❌ ERROR: Could not load .env file. Make sure it exists in assets.");
    print(e);
  }

  // 2. Initialize Firebase
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
        textTheme: GoogleFonts.poppinsTextTheme(),
      ),
      home: const LoginScreen(),
    );
  }
}