import 'package:flutter/material.dart';

import 'package:housekeeper/components/groceryCard.dart';

import "package:housekeeper/services/groceries.dart";

class GroceryList extends StatefulWidget {
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  Groceries groceries = Groceries(store: "Lidl");
  bool rebuild = false;

  @override
  void initState() {
    super.initState();

    getGroceryList();
  }

  void getGroceryList() async {
    await groceries.getList();

    setState(() => rebuild = !rebuild);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("House Keeper"),
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: groceries.list.length,
        itemBuilder: (context, index) {
          return Dismissible(
            key: Key(groceries.list[index].id),
            background: Container(color: Colors.red),
            child: GroceryCard(grocery: groceries.list[index]),
            onDismissed: (direction) {
              groceries.deleteGrocery(groceries.list[index].id);
            },
          );
        },
      ),
    );
  }
}
