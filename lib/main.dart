import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hmguru/src/pages/login.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Color(
            0xFF1875F0), // Set your desired primary color using the hexadecimal color code
      ),
      home: LoginView(), // Set LoginView as the home page
    );
  }
}
