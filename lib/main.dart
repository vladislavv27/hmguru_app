import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/pages/login_view.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
      ),
      home: LoginView(),
    );
  }
}
