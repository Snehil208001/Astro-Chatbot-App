import 'package:flutter/material.dart';
import '../widgets/astro_background.dart';
import 'home_screen.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent, // Transparent to show background
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: AstroBackground(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // REPLACED Icon with the Image
                  Image.asset(
                    'assets/image1.png',
                    height: 120,
                    fit: BoxFit.contain,
                  ),
                  
                  const SizedBox(height: 20),
                  
                  const Text(
                    "Join the Stars",
                    style: TextStyle(
                      fontSize: 28, 
                      fontWeight: FontWeight.bold, 
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(0, 2),
                          blurRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                  
                  _buildField("Full Name", Icons.person),
                  const SizedBox(height: 16),
                  _buildField("Email", Icons.email),
                  const SizedBox(height: 16),
                  _buildField("Password", Icons.lock, obscure: true),
                  const SizedBox(height: 30),
                  
                  // Sign Up Button (White button, Orange text)
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFFF6A623), // Theme Orange
                      minimumSize: const Size(double.infinity, 55),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30)
                      ),
                      elevation: 4,
                    ),
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        Navigator.pushReplacement(
                          context, 
                          MaterialPageRoute(builder: (context) => const HomeScreen())
                        );
                      }
                    },
                    child: const Text(
                      "Sign Up", 
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Helper widget to keep code clean
  Widget _buildField(String hint, IconData icon, {bool obscure = false}) {
    return TextFormField(
      obscureText: obscure,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30), 
          borderSide: BorderSide.none
        ),
        prefixIcon: Icon(icon, color: const Color(0xFFF6A623)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      ),
      validator: (value) => (value == null || value.isEmpty) ? "Required" : null,
    );
  }
}