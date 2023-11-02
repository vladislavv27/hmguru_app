import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/view/login_view.dart';

class MaterialAppWithLocale extends StatelessWidget {
  final Locale appLocale;

  const MaterialAppWithLocale({super.key, required this.appLocale});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: AppColors.primaryColor,
      ),
      home: const LoginView(),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('lv'),
        Locale('ru'),
      ],
      locale: appLocale,
    );
  }
}
