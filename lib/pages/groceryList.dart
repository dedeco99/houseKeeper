import 'package:flutter/material.dart';

import "../grocery.dart";

import "../groceryCard.dart";

class GroceryList extends StatefulWidget {
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<Grocery> groceries = [
    Grocery(name: "Leite", price: 1.5, quantity: 4),
    Grocery(name: "Cereais", price: 3.2, quantity: 2),
    Grocery(name: "Bolachas", price: 0.99, quantity: 6),
    Grocery(name: "Tremoços", price: 2.35, quantity: 3)
  ];

  @override
  Widget build(BuildContext context) {
    print("build ran");

    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("House Keeper"),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: groceries
              .map(
                (grocery) => new GroceryCard(
                  grocery: grocery,
                  onDelete: () {
                    setState(() {
                      groceries.remove(grocery);
                    });
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
