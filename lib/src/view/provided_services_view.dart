import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/controllers/provided_services_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/provided_service_vm.dart';

class ProvidedServiceListView extends StatefulWidget {
  final String userId;

  const ProvidedServiceListView({
    required this.userId,
    Key? key,
  }) : super(key: key);

  @override
  _ProvidedServiceListViewState createState() =>
      _ProvidedServiceListViewState(userId: userId);
}

class _ProvidedServiceListViewState extends State<ProvidedServiceListView> {
  final ProvidedServiceController _controller;
  List<ProvidedServiceSimpleVM> _providedServiceList = [];
  bool _isLoading = true;

  _ProvidedServiceListViewState({required String userId})
      : _controller = ProvidedServiceController(userId: userId);

  @override
  void initState() {
    super.initState();
    _loadProvidedServiceData();
  }

  Future<void> _loadProvidedServiceData() async {
    final providedServiceData = await _controller.loadProvidedServices();
    if (mounted) {
      setState(() {
        _providedServiceList = providedServiceData;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.providedservices),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildProvidedServiceListView(),
    );
  }

  Widget _buildProvidedServiceListView() {
    return ListView.builder(
      itemCount: _providedServiceList.length,
      itemBuilder: (context, index) {
        final providedService = _providedServiceList[index];

        return Card(
          child: ExpansionTile(
            title: Text(
              providedService.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            children: [
              _buildText(
                  "${AppLocalizations.of(context)!.fee}${providedService.fee.toStringAsFixed(2)}"),
              _buildText(
                  "${AppLocalizations.of(context)!.formula}${providedService.formula}"),
              _buildText(
                  "${AppLocalizations.of(context)!.penalty}${providedService.penalty.toString()}"),
              _buildText(
                  "${AppLocalizations.of(context)!.coefficient}${providedService.coefficient.toString()}"),
              _buildText(
                  "${AppLocalizations.of(context)!.taxesFromFee}${providedService.taxesFromFee.toStringAsFixed(2)}"),
            ],
          ),
        );
      },
    );
  }

  Widget _buildText(String text) {
    return Container(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
        ),
      ),
    );
  }
}
