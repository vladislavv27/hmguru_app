import 'package:flutter/material.dart';
import 'package:hmguru/src/controllers/payment_detail_controller.dart';
import 'package:hmguru/src/controllers/payment_list_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/payments_vm.dart';
import 'package:hmguru/src/pages/payment_details_view.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:intl/intl.dart';

class PaymentListView extends StatefulWidget {
  @override
  _PaymentListViewState createState() => _PaymentListViewState();
}

class _PaymentListViewState extends State<PaymentListView> {
  final PaymentListController _controller = PaymentListController();
  List<PaymentListVM> _paymentList = [];
  bool _isLoading = true;
  final _apiService = ApiService();
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
        title: Text('Payment List'),
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
                  "Period: $formattedPeriod",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Amount: ${payment.amount.toStringAsFixed(2)}',
                        style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textGrayColor,
                            fontWeight: FontWeight.bold)),
                    Text("Submitter: ${payment.submitter}",
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
