import "package:flutter/material.dart";

import "package:housekeeper/pages/groceries.dart";
import "package:housekeeper/pages/grocery_list.dart";

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  final List<Widget> _pages = [const GroceryListView(), const GroceriesView()];

  final List<NavigationDestination> _navigationOptions = [
    const NavigationDestination(icon: Icon(Icons.local_grocery_store_rounded), label: "Grocery List"),
    const NavigationDestination(icon: Icon(Icons.settings_rounded), label: "Settings"),
  ];
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: _pages.elementAt(_selectedIndex)),
      bottomNavigationBar: NavigationBar(
        destinations: _navigationOptions,
        selectedIndex: _selectedIndex,
        onDestinationSelected: (int index) => setState(() => _selectedIndex = index),
        height: 65,
      ),
    );
  }
}
