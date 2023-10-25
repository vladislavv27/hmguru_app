import 'package:flutter/material.dart';
import 'package:hmguru/src/pages/invoice_details_view.dart';
import 'package:intl/intl.dart';
import 'package:hmguru/src/models/Invoice_Info.dart';
import 'package:hmguru/src/models/my_leasehold.dart';
import 'package:hmguru/src/services/api_service.dart';
import 'package:hmguru/src/services/preference_service.dart';

class HomeController {
  final PreferenceService _prefservice = PreferenceService();
  final ApiService _apiservice = ApiService();
  MyLeaseholdVM? leaseholdData;
  InvoiceInfo? invoiceInfoData;
  bool isLoading = true;

  Future<void> loadLeaseholdData(Function setState) async {
    try {
      final myLeaseholdVM = await _prefservice.loadLeaseholdData();
      if (myLeaseholdVM != null) {
        setState(() {
          leaseholdData = myLeaseholdVM;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> loadInvoiceData(Function setState) async {
    try {
      final myinvoiceInfo = await _prefservice.loadInvoiceInfo();
      if (myinvoiceInfo != null) {
        setState(() {
          invoiceInfoData = myinvoiceInfo;
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  String getPreviousMonthDate() {
    final now = DateTime.now();
    final lastMonth = DateTime(now.year, now.month - 1, now.day);
    final formattedDate = DateFormat.MMMM().format(lastMonth);
    return formattedDate;
  }

  Future<void> openAdditionalInformationPage(
      BuildContext context, Function setState) async {
    if (invoiceInfoData != null) {
      try {
        await _apiservice.getInvoiceDataFormId(invoiceInfoData!.invoiceId);
        final additionalData = await _prefservice.loadInvoiceDetails();
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => InvoiceDetailPage(data: additionalData),
        ));
      } catch (e) {
        print(e);
      }
    }
  }
}
