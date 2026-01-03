import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart'; // Import dotenv
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
  final ScrollController _scrollController = ScrollController();
  final List<Map<String, String>> _messages = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Initial greeting from the Astrologer persona
    _addMessage("ai", "Namaste ${widget.userName}. I am here to guide you. The stars align to shed light on your ${widget.concern}. Ask me anything, and we shall look into your Kundli.");
  }

  void _addMessage(String role, String text) {
    setState(() => _messages.add({"role": role, "text": text}));
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage() async {
    final text = _controller.text.trim();
    if (text.isEmpty) return;
    
    _controller.clear();
    _addMessage("user", text);
    setState(() => _isLoading = true);

    try {
      // 1. SECURELY GET API KEY
      final apiKey = dotenv.env['GEMINI_API_KEY'];
      
      if (apiKey == null || apiKey.isEmpty) {
        _addMessage("ai", "Error: API Key not found. Please check your .env file.");
        setState(() => _isLoading = false);
        return;
      }

// Updated to use the latest 'gemini-2.5-flash' model
final url = Uri.parse('https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=$apiKey');      
      // 2. CONSTRUCT THE PERSONA PROMPT
      final String systemPrompt = """
      You are a professional Vedic astrologer.
      Speak calmly and wisely.
      Use astrology concepts like kundli, graha, dasha, lagna.
      Never say you are an AI.
      Give guidance, not absolute predictions.
      
      User Name: ${widget.userName}
      User Concern: ${widget.concern}
      Current Question: $text
      """;

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [{
            "parts": [{"text": systemPrompt}]
          }]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['candidates'] != null && data['candidates'].isNotEmpty) {
           final aiResponse = data['candidates'][0]['content']['parts'][0]['text'];
           _addMessage("ai", aiResponse);
        } else {
           _addMessage("ai", "The stars are cloudy today. Please try again.");
        }
      } else {
        _addMessage("ai", "I cannot read the stars right now (API Error: ${response.statusCode}).");
      }
    } catch (e) {
      _addMessage("ai", "A spiritual disturbance occurred: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text("Astrologer AI", style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: AstroBackground(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 16),
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
                        color: isUser ? Colors.white : Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(16),
                          topRight: const Radius.circular(16),
                          bottomLeft: isUser ? const Radius.circular(16) : Radius.zero,
                          bottomRight: isUser ? Radius.zero : const Radius.circular(16),
                        ),
                        boxShadow: [
                           const BoxShadow(color: Colors.black12, blurRadius: 4, offset: Offset(0, 2))
                        ],
                      ),
                      child: Text(
                        _messages[index]['text']!,
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                          height: 1.4,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
            if (_isLoading) 
              Container(
                padding: const EdgeInsets.all(8.0), 
                alignment: Alignment.centerLeft,
                child: const Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Text("Reading the stars...", style: TextStyle(color: Colors.white70, fontStyle: FontStyle.italic)),
                )
              ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                style: const TextStyle(color: Colors.black87),
                decoration: InputDecoration(
                  hintText: "Ask the stars...",
                  hintStyle: const TextStyle(color: Colors.black54),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(30), borderSide: BorderSide.none),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.send, color: Colors.deepOrange),
                    onPressed: _sendMessage
                  ),
                ),
                onSubmitted: (_) => _sendMessage(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}