import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/pages/login_view.dart';

void main() async {
  await dotenv.load();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();

  // Define a static method to allow changing the app's locale
  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>()!;
    state.setLocale(newLocale);
  }
}

class _MyAppState extends State<MyApp> {
  Locale _appLocale = Locale('en'); // Default locale is English

  // Method to update the app's locale
  void setLocale(Locale newLocale) {
    setState(() {
      _appLocale = newLocale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialAppWithLocale(
      appLocale: _appLocale, // Pass the app's locale to MaterialAppWithLocale
    );
  }
}

class MaterialAppWithLocale extends StatelessWidget {
  final Locale appLocale;

  MaterialAppWithLocale({required this.appLocale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
      ),
      home: LoginView(),
      localizationsDelegates: [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en'),
        const Locale('lv'),
        const Locale('ru'),
      ],
      locale: appLocale, // Use the selected locale
    );
  }
}
