import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../widgets/astro_background.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String concern;

  const ChatScreen({super.key, required this.userName, required this.concern});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;
  final String _apiKey = 'YOUR_API_KEY_HERE'; // Remember to keep your key here

  @override
  void initState() {
    super.initState();
    _addMessage("ai", "Namaste ${widget.userName}. The stars align to shed light on your ${widget.concern}. Ask me anything.");
  }

  void _addMessage(String role, String text) {
    setState(() => _messages.add({"role": role, "text": text}));
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    _controller.clear();
    _addMessage("user", text);
    setState(() => _isLoading = true);

    try {
      final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=$_apiKey');
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{"parts": [{"text": "You are a Vedic Astrologer. User: ${widget.userName}, Concern: ${widget.concern}. Question: $text"}]}]
        }),
      );
      if (response.statusCode == 200) {
        _addMessage("ai", jsonDecode(response.body)['candidates'][0]['content']['parts'][0]['text']);
      } else {
        _addMessage("ai", "The stars are silent (Error).");
      }
    } catch (e) {
      _addMessage("ai", "Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Astrologer AI", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AstroBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final isUser = _messages[index]['role'] == 'user';
                  return Align(
                    alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      padding: const EdgeInsets.all(14),
                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
                      decoration: BoxDecoration(
                        color: isUser ? Colors.white : Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                          bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                        ),
                      ),
                      child: Text(_messages[index]['text']!, style: const TextStyle(fontSize: 16)),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) const Padding(padding: EdgeInsets.all(8.0), child: CircularProgressIndicator(color: Colors.white)),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: "Ask the stars...",
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  suffixIcon: IconButton(icon: const Icon(Icons.send, color: Color(0xFFF6A623)), onPressed: _sendMessage),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}