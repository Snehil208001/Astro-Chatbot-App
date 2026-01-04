🌟 Astro Chatbot – Flutter Intern Task

Astro Chatbot is a Flutter-based astrology chatbot application where users log in using email & password, submit their birth details, and chat with an AI-powered astrologer that responds in a calm, spiritual, Vedic tone.

This project was developed as part of a Flutter Intern Assignment to demonstrate UI development, form validation, state handling, and AI API integration.

📱 Screenshots
Login	Signup
<img src="assets/login.png" width="250"/>	<img src="assets/signup.png" width="250"/>
Astrology Details Form	Astrologer Chat
<img src="assets/homescreen.png" width="250"/>	<img src="assets/chatscreen.png" width="250"/>
🎯 Objective

Collect basic user and birth details

Start a chatbot session with an AI astrologer

Demonstrate clean Flutter UI, state handling, and API usage

🔄 User Flow

User opens the app

Login / Signup using Email & Password

Fill Astrology Details Form

Tap Start Astrology Chat

Chat with AI Astrologer

✨ Features
🔐 Authentication (Mandatory)

Email & Password Login / Signup

Firebase Authentication

Auto-redirect based on auth state

📝 Astrology Details Form (Mandatory)

Full Name

Gender

Date of Birth (DD/MM/YYYY)

Time of Birth (HH:MM AM/PM)

Place of Birth (City, State, Country)

Current Concern (Dropdown):

Career

Marriage

Love

Health

Finance

General

✔ All fields are validated before proceeding.

💬 Astrologer Chat Interface (Mandatory)

Left-aligned AI messages

Right-aligned User messages

Typing indicator while AI responds

Auto-scroll to latest message

Calm, wise, Vedic astrologer persona

Uses astrology terms (kundli, graha, dasha, lagna)

Never reveals it is an AI

🤖 AI Integration

Google Gemini API

REST API using http

Basic error handling for failed responses

🛠️ Tech Stack

Framework: Flutter (Dart)

UI: Material 3

Authentication: Firebase Auth

AI API: Google Gemini

Networking: http

State Management: setState, StreamBuilder

Environment Variables: flutter_dotenv

Fonts: google_fonts

🚀 Getting Started
Prerequisites

Flutter SDK (>= 3.0.0)

Firebase Project

Google Gemini API Key

1️⃣ Clone Repository
git clone https://github.com/yourusername/astro-chatbot-app.git
cd astrochatbot

2️⃣ Install Dependencies
flutter pub get

3️⃣ Firebase Setup

Create a Firebase project

Enable Email/Password Authentication

Add config files:

android/app/google-services.json

ios/Runner/GoogleService-Info.plist

4️⃣ Environment Variables

Create a .env file in root:

API_KEY=your_gemini_api_key_here


⚠️ Do not commit .env file

5️⃣ Run the App
flutter run

📂 Project Structure
lib/
├── main.dart                 # App entry & auth gate
├── screens/
│   ├── login_screen.dart     # Login UI
│   ├── signup_screen.dart    # Signup UI
│   ├── home_screen.dart      # Astrology details form
│   └── chat_screen.dart      # AI chat logic
└── widgets/
    └── astro_background.dart # Reusable background UI

✅ MVP Checklist (Task Requirements)

 Email + Password Login

 Astrology Details Form with Validation

 AI Astrologer Chat UI

 AI API Integration

 Clean & Runnable Flutter Project

🔮 Future Enhancements (Optional)

Kundli / Birth chart visualization

Chat history persistence

Multi-language support (Hindi / English)

Daily horoscope

Premium chat features

📌 Notes

Backend & chat persistence are optional as per task scope

Focus is on clean UI, logic, and code quality

Over-engineering avoided intentionally

👨‍💻 Developed by

Snehil
Flutter Developer | Internship Submission
