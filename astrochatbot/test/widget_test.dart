import 'package:flutter_test/flutter_test.dart';
import 'package:astrochatbot/main.dart'; // Imports your AstroChatbotApp

void main() {
  testWidgets('App loads login screen smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We use AstroChatbotApp because we renamed MyApp in main.dart
    await tester.pumpWidget(const AstroChatbotApp());

    // Verify that the Login Screen appears.
    // We check if the title "Astro Chatbot" is on the screen.
    expect(find.text('Astro Chatbot'), findsOneWidget);

    // Verify that the "Login" button is present.
    // Note: This finds the text 'Login' which appears on the button.
    expect(find.text('Login'), findsOneWidget);
  });
}