import 'package:flutter/material.dart';
import 'package:hmguru/src/controllers/payment_detail_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/payments_vm.dart';
import 'package:intl/intl.dart';

class PaymentDetailView extends StatefulWidget {
  final String paymentId;

  PaymentDetailView({required this.paymentId});

  @override
  _PaymentDetailViewState createState() => _PaymentDetailViewState();
}

class _PaymentDetailViewState extends State<PaymentDetailView> {
  final PaymentDetailController _controller = PaymentDetailController();
  PaymentDetailVM? _paymentDetail;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPaymentDetail();
  }

  Future<void> _loadPaymentDetail() async {
    final paymentDetail = await _controller.loadPaymentDetail(widget.paymentId);
    setState(() {
      _paymentDetail = paymentDetail;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Payment Details'),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _buildPaymentDetail(),
    );
  }

  Widget _buildPaymentDetail() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetail("invoice",
                    _paymentDetail?.invoiceUID.toString() ?? "No data"),
              ),
              Expanded(
                child: _buildDetail("submitter",
                    _paymentDetail?.submitter.toString() ?? "No data"),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildDetail(
                    "perido", _formatDateYearMonth(_paymentDetail?.period)),
              ),
              Expanded(
                child: _buildDetail("bank transaction nr",
                    _paymentDetail?.bankTransactionID.toString() ?? "No data"),
              ),
            ],
          ),
          _buildDetail(
            "payment amount",
            _paymentDetail?.amount.toStringAsFixed(2) ?? "No data",
            _paymentDetail?.currency,
          ),
          _buildDetail("bank transaction comment",
              _paymentDetail?.bankTransactionComment.toString() ?? "No data"),
          Row(
            children: [
              Expanded(
                child: _buildDetail("Received on",
                    formatDateFulldate(_paymentDetail?.receivedOn)),
              ),
              Expanded(
                child: _buildDetail("submitted on".toUpperCase(),
                    formatDateFulldate(_paymentDetail?.submittedOn)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetail(String label, String value, [String? currency]) {
    if (currency != null) {
      value = '$value $currency';
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textGrayColor,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        SizedBox(height: 16),
      ],
    );
  }

  String formatDateFulldate(DateTime? date) {
    if (date != null) {
      return DateFormat('dd.MM.yyyy').format(date);
    } else {
      return 'No data';
    }
  }

  String _formatDateYearMonth(DateTime? date) {
    if (date != null) {
      return DateFormat('MMMM y').format(date);
    }
    return "No data";
  }
}
