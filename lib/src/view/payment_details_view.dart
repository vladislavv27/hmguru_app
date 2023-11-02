import 'package:flutter/material.dart';
import 'package:hmguru/src/controllers/payment_detail_controller.dart';
import 'package:hmguru/src/models/app_colors.dart';
import 'package:hmguru/src/models/payments_vm.dart';
import 'package:intl/intl.dart';
import 'package:hmguru/l10n/global_localizations.dart';

class PaymentDetailView extends StatefulWidget {
  final String paymentId;

  const PaymentDetailView({super.key, required this.paymentId});

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
        title: Text(AppLocalizations.of(context)!.paymentDetails),
        backgroundColor: AppColors.primaryColor,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : _buildPaymentDetail(),
    );
  }

  Widget _buildPaymentDetail() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: _buildDetail(
                  AppLocalizations.of(context)!.invoice.toUpperCase(),
                  _paymentDetail?.invoiceUID.toString() ?? "No data",
                ),
              ),
              Expanded(
                child: _buildDetail(
                  AppLocalizations.of(context)!.submitter.toUpperCase(),
                  _paymentDetail?.submitter.toString() ?? "No data",
                ),
              ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _buildDetail(
                  AppLocalizations.of(context)!.period.toUpperCase(),
                  _formatDateYearMonth(_paymentDetail?.period),
                ),
              ),
              Expanded(
                child: _buildDetail(
                  AppLocalizations.of(context)!.bankTransactionNr.toUpperCase(),
                  _paymentDetail?.bankTransactionID.toString() ?? "No data",
                ),
              ),
            ],
          ),
          _buildDetail(
            AppLocalizations.of(context)!.paymentAmount.toUpperCase(),
            _paymentDetail?.amount.toStringAsFixed(2) ?? "No data",
            _paymentDetail?.currency,
          ),
          _buildDetail(
            AppLocalizations.of(context)!.bankTransactionComment.toUpperCase(),
            _paymentDetail?.bankTransactionComment.toString() ?? "No data",
          ),
          Row(
            children: [
              Expanded(
                child: _buildDetail(
                  AppLocalizations.of(context)!.receivedOn.toUpperCase(),
                  formatDateFulldate(_paymentDetail?.receivedOn),
                ),
              ),
              Expanded(
                child: _buildDetail(
                  AppLocalizations.of(context)!.submittedOn.toUpperCase(),
                  formatDateFulldate(_paymentDetail?.submittedOn),
                ),
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
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textGrayColor,
            fontSize: 12,
          ),
        ),
        Text(
          value,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  String formatDateFulldate(DateTime? date) {
    if (date != null) {
      return DateFormat('dd.MM.yyyy').format(date);
    } else {
      return AppLocalizations.of(context)!.noData;
    }
  }

  String _formatDateYearMonth(DateTime? date) {
    if (date != null) {
      return DateFormat('MMMM y').format(date);
    }
    return AppLocalizations.of(context)!.noData;
  }
}
