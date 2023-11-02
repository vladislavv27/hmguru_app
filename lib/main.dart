import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hmguru/src/controllers/material_app_with_locale.dart';

void main() async {
  await dotenv.load();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _appLocale = const Locale('en');

  void setLocale(Locale newLocale) {
    setState(() {
      _appLocale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialAppWithLocale(
      appLocale: _appLocale,
    );
  }
}
