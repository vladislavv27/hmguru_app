import 'package:flutter/material.dart';
import 'package:hmguru/src/pages/home.dart';

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
          icon: Icon(Icons.dashboard_customize),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.apartment),
          label: 'My apartment',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.school),
          label: 'Page 3',
        ),
      ],
      currentIndex: widget.currentIndex,
      onTap: (index) {
        widget.onTap(index);

        // Implement navigation logic based on the index
        switch (index) {
          case 0:
            // Navigate to the home page (Dashboard)
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                builder: (BuildContext context) => HomePage(),
              ),
            );
            break;
          case 1:
            // Navigate to My Apartment page
            // Implement navigation to My Apartment page here
            break;
          case 2:
            // Navigate to Page 3
            // Implement navigation to Page 3 here
            break;
        }
      },
    );
  }
}
