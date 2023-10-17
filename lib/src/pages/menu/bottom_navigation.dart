import 'package:flutter/material.dart';
import 'package:hmguru/src/pages/home.dart';
import 'package:hmguru/src/pages/invoice_list.dart';

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
          label: 'Invoices', //все инвойсы (check or download)
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: (index) {
        widget.onTap(index);

        switch (index) {
          case 0:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ),
            );
            break;
          case 1:
            break;
          case 2:
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => InvoiceListPage(),
              ),
            );
            break;
        }
      },
    );
  }
}
