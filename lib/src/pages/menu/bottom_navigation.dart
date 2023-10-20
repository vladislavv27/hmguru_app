import 'package:flutter/material.dart';
import 'package:hmguru/src/pages/home_view.dart';
import 'package:hmguru/src/pages/invoice_list_view.dart';
import 'package:hmguru/src/pages/meter_readings_view.dart';

class MyBottomNavigationMenu extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  MyBottomNavigationMenu({required this.currentIndex, required this.onTap});

  @override
  _MyBottomNavigationMenuState createState() => _MyBottomNavigationMenuState();
}

class _MyBottomNavigationMenuState extends State<MyBottomNavigationMenu> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'My apartment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.electric_meter),
          label: 'Meter', //Ввести счетчики
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.receipt),
          label: 'Invoices',
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: (index) {
        widget.onTap(index);

        switch (index) {
          case 0:
            _navigateWithAnimation(context, HomePage());
            break;
          case 1:
            _navigateWithAnimation(context, MeterReadingPage());
            break;
          case 2:
            _navigateWithAnimation(context, InvoiceListPage());
            break;
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
