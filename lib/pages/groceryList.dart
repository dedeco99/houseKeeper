import 'package:flutter/material.dart';

import 'package:housekeeper/components/groceryCard.dart';

import "package:housekeeper/services/groceries.dart";
import 'package:housekeeper/services/grocery.dart';

class GroceryList extends StatefulWidget {
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  List<Grocery> groceryList = [];

  @override
  void initState() {
    super.initState();

    getGroceryList();
  }

  void getGroceryList() async {
    Groceries groceries = Groceries(store: "lidl");

    await groceries.getList();

    setState(() => groceryList = groceries.list);
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
        itemCount: groceryList.length,
        itemBuilder: (context, index) {
          return GroceryCard(
            grocery: groceryList[index],
            onDelete: () => setState(() => groceryList.removeAt(index)),
          );
        },
      ),
    );
  }
}
