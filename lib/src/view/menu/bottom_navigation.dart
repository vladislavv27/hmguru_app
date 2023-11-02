import 'package:flutter/material.dart';
import 'package:hmguru/l10n/global_localizations.dart';
import 'package:hmguru/src/view/home_view.dart';
import 'package:hmguru/src/view/invoice_list_view.dart';
import 'package:hmguru/src/view/meter_readings_view.dart';

class MyBottomNavigationMenu extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  MyBottomNavigationMenu({required this.currentIndex, required this.onTap});

  @override
  _MyBottomNavigationMenuState createState() => _MyBottomNavigationMenuState();
}

class _MyBottomNavigationMenuState extends State<MyBottomNavigationMenu> {
  final List<Widget> pages = [
    HomePage(),
    MeterReadingPage(),
    InvoiceListPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: AppLocalizations.of(context)!.myApartment,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.electric_meter),
          label: AppLocalizations.of(context)!.meter,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: AppLocalizations.of(context)!.invoices,
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: (index) {
        widget.onTap(index);

        if (index != widget.currentIndex) {
          _navigateWithAnimation(context, pages[index]);
        }
      },
    );
  }

  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        var offsetAnimation = animation.drive(tween);
        return SlideTransition(
          position: offsetAnimation,
          child: child,
        );
      },
    ));
  }
}
