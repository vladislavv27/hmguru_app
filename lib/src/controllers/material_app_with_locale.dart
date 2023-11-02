import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/view/login_view.dart';

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
      locale: appLocale,
    );
  }
}
