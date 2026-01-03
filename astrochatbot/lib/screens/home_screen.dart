import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../widgets/astro_background.dart';
import 'chat_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController placeController = TextEditingController();
  String? selectedGender;
  String? selectedConcern;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

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
      ),
      body: AstroBackground(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                _buildField(nameController, "Full Name", Icons.person),
                const SizedBox(height: 16),
                _buildDropdown("Gender", ["Male", "Female", "Other"], (val) => selectedGender = val),
                const SizedBox(height: 16),
                _buildDatePicker(),
                const SizedBox(height: 16),
                _buildTimePicker(),
                const SizedBox(height: 16),
                _buildField(placeController, "Place of Birth", Icons.location_on),
                const SizedBox(height: 16),
                _buildDropdown("Current Concern", ["Career", "Marriage", "Health", "Finance"], (val) => selectedConcern = val),
                const SizedBox(height: 40),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFFF6A623),
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate() && selectedDate != null && selectedTime != null) {
                      Navigator.push(context, MaterialPageRoute(builder: (context) => ChatScreen(userName: nameController.text, concern: selectedConcern!)));
                    }
                  },
                  child: const Text("Start Chat", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(TextEditingController controller, String label, IconData icon) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        prefixIcon: Icon(icon, color: const Color(0xFFF6A623)),
      ),
      validator: (v) => v!.isEmpty ? "Required" : null,
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(
        labelText: label,
        filled: true,
        fillColor: Colors.white.withOpacity(0.9),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(15), borderSide: BorderSide.none),
        prefixIcon: const Icon(Icons.arrow_drop_down_circle, color: Color(0xFFF6A623)),
      ),
      items: items.map((e) => DropdownMenuItem(value: e, child: Text(e))).toList(),
      onChanged: onChanged,
    );
  }

  Widget _buildDatePicker() {
    return ListTile(
      tileColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: const Icon(Icons.calendar_today, color: Color(0xFFF6A623)),
      title: Text(selectedDate == null ? "Select DOB" : DateFormat('dd/MM/yyyy').format(selectedDate!)),
      onTap: () async {
        DateTime? picked = await showDatePicker(context: context, initialDate: DateTime(2000), firstDate: DateTime(1900), lastDate: DateTime.now());
        if (picked != null) setState(() => selectedDate = picked);
      },
    );
  }

  Widget _buildTimePicker() {
    return ListTile(
      tileColor: Colors.white.withOpacity(0.9),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      leading: const Icon(Icons.access_time, color: Color(0xFFF6A623)),
      title: Text(selectedTime == null ? "Select Time" : selectedTime!.format(context)),
      onTap: () async {
        TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
        if (picked != null) setState(() => selectedTime = picked);
      },
    );
  }
}