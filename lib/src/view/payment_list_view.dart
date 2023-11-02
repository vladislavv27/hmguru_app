import 'package:flutter/material.dart';
import 'package:hmguru/src/controllers/payment_list_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/payments_vm.dart';
import 'package:hmguru/src/view/payment_details_view.dart';
import 'package:intl/intl.dart';
import 'package:hmguru/l10n/global_localizations.dart';

class PaymentListView extends StatefulWidget {
  @override
  _PaymentListViewState createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  final PaymentListController _controller = PaymentListController();
  List<PaymentListVM> _paymentList = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentData();
  }

  Future<void> _loadPaymentData() async {
    final paymentData = await _controller.loadPaymentList();
    setState(() {
      _paymentList = paymentData!;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.paymentList),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildPaymentListView(),
    );
  }

  Widget _buildPaymentListView() {
    return ListView.builder(
      itemCount: _paymentList.length,
      itemBuilder: (context, index) {
        final payment = _paymentList[index];

        final periodDateTime = DateTime.parse(payment.period);
        final formattedPeriod = DateFormat.yMMM().format(periodDateTime);

        return Row(
          children: [
            Expanded(
              child: ListTile(
                title: Text(
                  '${AppLocalizations.of(context)!.period}: $formattedPeriod',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                        '${AppLocalizations.of(context)!.amount}: ${payment.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGrayColor,
                            fontWeight: FontWeight.bold)),
                    Text(
                        "${AppLocalizations.of(context)!.submitter}: ${payment.submitter}",
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGrayColor,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            _buildInfoButton(payment.id!),
          ],
        );
      },
    );
  }

  Widget _buildInfoButton(String id) {
    return IconButton(
      onPressed: () {
        _openAdditionalInformationPage(id);
      },
      icon: Icon(
        Icons.info,
        color: AppColors.secondaryColor,
      ),
    );
  }

  Future<void> _openAdditionalInformationPage(String id) async {
    Navigator.of(context).push(MaterialPageRoute(
      builder: (context) => PaymentDetailView(paymentId: id),
    ));
  }
}
