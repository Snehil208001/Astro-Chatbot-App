import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/astro_background.dart';
import 'chat_screen.dart';
import 'login_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  final TextEditingController dateController = TextEditingController(); // Added
  final TextEditingController timeController = TextEditingController(); // Added
  
  String? selectedGender;
  String? selectedConcern;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  void dispose() {
    nameController.dispose();
    placeController.dispose();
    dateController.dispose();
    timeController.dispose();
    super.dispose();
  }

  void _logout() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to exit?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _startChat() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context, 
        MaterialPageRoute(
          builder: (context) => ChatScreen(
            userName: nameController.text.trim(), 
            concern: selectedConcern!,
            dob: selectedDate!, 
            time: selectedTime!, 
            place: placeController.text.trim(), 
          )
        )
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Please fill all details correctly"),
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        )
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Enter Details", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: "Logout",
            onPressed: _logout,
          ),
        ],
      ),
      body: AstroBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 20),
                
                _buildField(
                  controller: nameController, 
                  label: "Full Name", 
                  icon: Icons.person,
                  validator: (v) {
                    if (v == null || v.trim().isEmpty) return "Please enter your name";
                    if (v.trim().length < 3) return "Name must be at least 3 chars";
                    return null;
                  }
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  label: "Gender", 
                  items: ["Male", "Female", "Other"], 
                  onChanged: (val) => setState(() => selectedGender = val),
                  value: selectedGender,
                ),
                const SizedBox(height: 16),
                
                _buildDatePicker(),
                const SizedBox(height: 16),
                
                _buildTimePicker(),
                const SizedBox(height: 16),
                
                _buildField(
                  controller: placeController, 
                  label: "Place of Birth", 
                  icon: Icons.location_on,
                  validator: (v) => (v == null || v.trim().isEmpty) ? "Please enter place of birth" : null
                ),
                const SizedBox(height: 16),
                
                _buildDropdown(
                  label: "Current Concern", 
                  items: ["Career", "Marriage", "Health", "Finance", "Education", "Relationships"], 
                  onChanged: (val) => setState(() => selectedConcern = val),
                  value: selectedConcern,
                ),
                const SizedBox(height: 40),
                
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFF6A623),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    elevation: 4,
                  ),
                  onPressed: _startChat,
                  child: const Text(
                    "Start Chat", 
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }


  Widget _buildField({
    required TextEditingController controller, 
    required String label, 
    required IconData icon,
    String? Function(String?)? validator
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        prefixIcon: Icon(icon, color: const Color(0xFFF6A623)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      validator: validator ?? (v) => v!.isEmpty ? "Required" : null,
    );
  }

  Widget _buildDropdown({
    required String label, 
    required List<String> items, 
    required Function(String?) onChanged,
    required String? value,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.arrow_drop_down_circle, color: Color(0xFFF6A623)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
      validator: (v) => v == null ? "Please select $label" : null,
    );
  }

  Widget _buildDatePicker() {
    return TextFormField(
      controller: dateController,
      readOnly: true, 
      decoration: InputDecoration(
        labelText: "Date of Birth",
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.calendar_today, color: Color(0xFFF6A623)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onTap: () async {
        DateTime? picked = await showDatePicker(
          context: context, 
          initialDate: DateTime(2000), 
          firstDate: DateTime(1900), 
          lastDate: DateTime.now()
        );
        if (picked != null) {
          setState(() {
            selectedDate = picked;
            dateController.text = DateFormat('dd/MM/yyyy').format(picked);
          });
        }
      },
      validator: (v) => v!.isEmpty ? "Please select Date of Birth" : null,
    );
  }

  Widget _buildTimePicker() {
    return TextFormField(
      controller: timeController,
      readOnly: true, 
      decoration: InputDecoration(
        labelText: "Time of Birth",
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.access_time, color: Color(0xFFF6A623)),
        contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      ),
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(
          context: context, 
          initialTime: TimeOfDay.now()
        );
        if (picked != null) {
          setState(() {
            selectedTime = picked;
            timeController.text = picked.format(context);
          });
        }
      },
      validator: (v) => v!.isEmpty ? "Please select Time of Birth" : null,
    );
  }
}