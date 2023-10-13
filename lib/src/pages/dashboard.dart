import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DashboardTab extends StatefulWidget {
  @override
  _DashboardTabState createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab> {
  String catFact = ''; // Initialize a variable to store the cat fact.

  // Function to fetch data from the API.
  Future<void> fetchCatFact() async {
    final response = await http.get(Uri.parse('https://catfact.ninja/fact'));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      setState(() {
        catFact = data['fact'];
      });
    } else {
      // Handle errors here.
      print('Failed to load data: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchCatFact(); // Fetch the initial cat fact when the widget initializes.
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Cat Fact of the Day:',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 10),
          Text(
            catFact, // Display the cat fact.
            style: TextStyle(fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              // Add your logic to fetch and update the cat fact here.
              fetchCatFact(); // Fetch a new cat fact when the button is pressed.
            },
            child: Text('Refresh Cat Fact'),
          ),
        ],
      ),
    );
  }
}
