import 'package:flutter_test/flutter_test.dart';
import 'package:astrochatbot/main.dart'; 

void main() {
  testWidgets('App loads login screen smoke test', (WidgetTester tester) async {
    
    await tester.pumpWidget(const AstroChatbotApp());

   
    expect(find.text('Astro Chatbot'), findsOneWidget);

    
    expect(find.text('Login'), findsOneWidget);
  });
}