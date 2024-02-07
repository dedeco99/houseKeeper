import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

import "package:housekeeper/components/grocery_card.dart";
import "package:housekeeper/components/grocery_detail.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceriesView extends StatefulWidget {
  const GroceriesView({super.key});

  @override
  _GroceriesViewState createState() => _GroceriesViewState();
}

class _GroceriesViewState extends State<GroceriesView> {
  Groceries groceries = GetIt.instance.get<Groceries>();
  RefreshController refreshController = RefreshController();

  void onRefresh() async {
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Groceries"), elevation: 0),
      body: StreamBuilder(
        stream: groceries.groceries$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return const Text("Loading");

          return SmartRefresher(
            enablePullDown: true,
            header: const WaterDropMaterialHeader(),
            controller: refreshController,
            onRefresh: onRefresh,
            child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                final Grocery grocery = snapshot.data[index];

                return GroceryCard(grocery: grocery);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context) => const GroceryDetail());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
