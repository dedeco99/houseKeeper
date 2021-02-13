import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'package:housekeeper/components/groceryCard.dart';

import "package:housekeeper/services/groceries.dart";

class GroceryList extends StatefulWidget {
  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  Groceries groceries = Groceries(store: "Lidl");
  bool rebuild = false;
  RefreshController refreshController = RefreshController();

  @override
  void initState() {
    super.initState();

    getGroceryList();
  }

  void getGroceryList() async {
    await groceries.getList();

    setState(() => rebuild = !rebuild);
  }

  void onRefresh() async {
    await groceries.getList();

    setState(() => rebuild = !rebuild);

    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("House Keeper"),
        elevation: 0,
      ),
      body: SmartRefresher(
        enablePullDown: true,
        enablePullUp: true,
        header: WaterDropMaterialHeader(),
        controller: refreshController,
        onRefresh: onRefresh,
        child: ListView.builder(
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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          groceries.addGrocery("Krave", "Cereais", "Lidl", 3);
        },
        child: Icon(Icons.add),
        backgroundColor: Colors.blue,
      ),
    );
  }
}
