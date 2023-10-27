import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/pages/login_view.dart';
import 'package:hmguru/src/services/preference_service.dart';

class NotResidentView extends StatelessWidget {
  final _prefservice = PreferenceService();

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
              style: TextStyle(
                  fontSize: 18,
                  color: AppColors.accentColor,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _handleLogout(context);
              },
              child: Text(AppLocalizations.of(context)!.logoutButton),
              style: ElevatedButton.styleFrom(
                primary: AppColors.primaryColor,
              ),
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
        builder: (BuildContext context) => LoginView(),
      ),
      (Route<dynamic> route) => false,
    );
  }
}
