import 'package:flutter/material.dart';
import 'package:hmguru/src/controllers/residents_controller.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/residents_vm.dart';

class ResidentsView extends StatefulWidget {
  @override
  _ResidentsViewState createState() => _ResidentsViewState();
}

class _ResidentsViewState extends State<ResidentsView> {
  final ResidentsViewController _controller = ResidentsViewController();
  List<ResidentTableVM?> _residentList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadResidentData();
  }

  Future<void> _loadResidentData() async {
    final residents = await _controller.loadResidentList();
    setState(() {
      if (residents != null) {
        _residentList = residents;
        _isLoading = false;
      } else {
        _isLoading = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(labels!.residents),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _buildResidentsListView(labels),
    );
  }

  Widget _buildResidentsListView(AppLocalizations labels) {
    final labelStyle = TextStyle(
      color: AppColors.textGrayColor,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );

    final valueStyle = TextStyle(
      color: Colors.black,
      fontSize: 18,
    );
    final ownerStyle = TextStyle(
      color: AppColors.accentColor,
      fontSize: 20,
    );

    String ownerTranslation = labels.owner;
    String residentTranslation = labels.resident;

    return ListView.builder(
      itemCount: _residentList.length,
      itemBuilder: (context, index) {
        final resident = _residentList[index];

        return ListTile(
          title: Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: '${labels.name}: ',
                  style: labelStyle,
                ),
                TextSpan(
                  text: resident!.fullName,
                  style: valueStyle,
                ),
              ],
            ),
          ),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${labels.phone}: ',
                      style: labelStyle,
                    ),
                    TextSpan(
                      text: resident.phone,
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${labels.email}: ',
                      style: labelStyle,
                    ),
                    TextSpan(
                      text: resident.email,
                      style: valueStyle,
                    ),
                  ],
                ),
              ),
              Text.rich(
                TextSpan(
                  children: [
                    TextSpan(
                      text: '${labels.role}: ',
                      style: labelStyle,
                    ),
                    TextSpan(
                      text: resident.isOwner
                          ? ownerTranslation
                          : residentTranslation,
                      style: ownerStyle,
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
