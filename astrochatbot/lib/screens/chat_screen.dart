import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import '../widgets/astro_background.dart';

class ChatScreen extends StatefulWidget {
  final String userName;
  final String concern;
  final String place;
  final DateTime dob;
  final TimeOfDay time;

  const ChatScreen({
    super.key,
    required this.userName,
    required this.concern,
    required this.place,
    required this.dob,
    required this.time,
  });

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
    _addMessage(
      "ai",
      "Namaste ${widget.userName}. I have your birth chart details "
      "(${DateFormat('dd/MM/yyyy').format(widget.dob)} at ${widget.place}). "
      "I see your concern regarding ${widget.concern}. "
      "Ask me your specific question.",
    );
  }

  void _addMessage(String role, String text) {
    if (!mounted) return;
    setState(() {
      _messages.add({"role": role, "text": text});
    });
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
    
    _scrollToBottom();

    try {
      final apiKey = dotenv.env['API_KEY'];
      if (apiKey == null || apiKey.isEmpty) {
        _addMessage("ai", "System Error: API key missing.");
        return;
      }

      String formattedDate = DateFormat('dd/MM/yyyy').format(widget.dob);
      String formattedTime = widget.time.format(context);

      final systemInstruction = """
You are a professional Vedic astrologer.
User Details:
- Name: ${widget.userName}
- DOB: $formattedDate
- Time: $formattedTime
- Place: ${widget.place}
- Concern: ${widget.concern}

Instructions:
1. You already have their birth details. DO NOT ask for them again.
2. Calculate the planetary positions (Grahas, Lagna) mentally based on these details.
3. Answer the user's question: "$text" specifically based on this data.
4. Speak calmly and wisely. Never say you are an AI.
""";

      final url = Uri.parse(
        'https://generativelanguage.googleapis.com/v1/models/gemini-2.5-flash:generateContent?key=$apiKey',
      );

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "contents": [
            {
              "parts": [
                {"text": systemInstruction}
              ]
            }
          ]
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final reply =
            data['candidates']?[0]?['content']?['parts']?[0]?['text'];

        _addMessage(
          "ai",
          reply ?? "The stars are silent at the moment.",
        );
      } else {
        _addMessage(
          "ai",
          "Error ${response.statusCode}: ${response.body}",
        );
      }
    } catch (e) {
      _addMessage("ai", "Connection error: $e");
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Astrologer AI",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
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
                padding: const EdgeInsets.fromLTRB(16, 100, 16, 20),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final isUser = _messages[index]['role'] == 'user';
                  return Align(
                    alignment:
                        isUser ? Alignment.centerRight : Alignment.centerLeft,
                    child: Column(
                      crossAxisAlignment: isUser 
                          ? CrossAxisAlignment.end 
                          : CrossAxisAlignment.start,
                      children: [
                        // Name Label
                        Padding(
                          padding: const EdgeInsets.only(bottom: 4, left: 4, right: 4),
                          child: Text(
                            isUser ? widget.userName : "Astrologer AI",
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: Colors.black54, 
                            ),
                          ),
                        ),
                        
                        // Message Bubble
                        Container(
                          margin: const EdgeInsets.only(bottom: 16),
                          padding: const EdgeInsets.all(14),
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width * 0.75,
                          ),
                          decoration: BoxDecoration(
                            color: isUser 
                                ? Colors.white 
                                : Colors.orange.shade100, 
                            borderRadius: BorderRadius.only(
                              topLeft: const Radius.circular(16),
                              topRight: const Radius.circular(16),
                              bottomLeft: isUser
                                  ? const Radius.circular(16)
                                  : Radius.zero,
                              bottomRight: isUser
                                  ? Radius.zero
                                  : const Radius.circular(16),
                            ),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                offset: Offset(0, 2),
                              )
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
                      ],
                    ),
                  );
                },
              ),
            ),
            
            // Loading Indicator
            if (_isLoading)
              const Padding(
                padding: EdgeInsets.only(left: 20, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    "Reading the stars...",
                    style: TextStyle(
                      color: Colors.black54, 
                      fontWeight: FontWeight.bold,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                ),
              ),
              
            // Input Field
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 10,
                    offset: Offset(0, -2),
                  )
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _controller,
                        textCapitalization: TextCapitalization.sentences,
                        decoration: const InputDecoration(
                          hintText: "Ask the stars...",
                          hintStyle: TextStyle(color: Colors.grey),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 10),
                        ),
                        onSubmitted: (_) => _sendMessage(),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      decoration: const BoxDecoration(
                        color: Color(0xFFF6A623),
                        shape: BoxShape.circle,
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.send, color: Colors.white),
                        onPressed: _sendMessage,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}