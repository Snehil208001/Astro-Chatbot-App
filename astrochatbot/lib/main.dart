import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Required for auth check
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'screens/login_screen.dart';
import 'screens/home_screen.dart'; // Required to navigate to Home

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // 1. Load the environment variables first
  try {
    await dotenv.load(fileName: ".env");
  } catch (e) {
    print("Error loading .env file: $e");
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
      // Use StreamBuilder to listen to authentication state changes
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          // 1. While Firebase is checking the token, show a loader
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(
                child: CircularProgressIndicator(color: Colors.deepOrange),
              ),
            );
          }

          // 2. If we have a user, go to Home Screen
          if (snapshot.hasData) {
            return const HomeScreen();
          }

          // 3. Otherwise, go to Login Screen
          return const LoginScreen();
        },
      ),
    );
  }
}