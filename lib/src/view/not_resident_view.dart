import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/view/login_view.dart';
import 'package:hmguru/src/services/preference_service.dart';

class NotResidentView extends StatelessWidget {
  final _prefservice = PreferenceService();

  NotResidentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.notResidentTitle),
        backgroundColor: AppColors.primaryColor,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              AppLocalizations.of(context)!.notResidentMessage,
              style: const TextStyle(
                  fontSize: 18,
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleLogout(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryColor,
              ),
              child: Text(AppLocalizations.of(context)!.logoutButton),
            ),
          ],
        ),
      ),
    );
  }

  void _handleLogout(BuildContext context) async {
    await _prefservice.clearAllPreferences();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (BuildContext context) => const LoginView(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
