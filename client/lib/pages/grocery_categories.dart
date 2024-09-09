import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

import "package:housekeeper/components/loading.dart";
import "package:housekeeper/components/grocery_card.dart";
import "package:housekeeper/components/grocery_detail.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryCategoriesView extends StatefulWidget {
  const GroceryCategoriesView({super.key});

  @override
  _GroceryCategoriesViewState createState() => _GroceryCategoriesViewState();
}

class _GroceryCategoriesViewState extends State<GroceryCategoriesView> {
  Groceries groceries = GetIt.instance.get<Groceries>();
  RefreshController refreshController = RefreshController();

  void onRefresh() async {
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Grocery Categories"), elevation: 0),
      body: StreamBuilder(
        stream: groceries.groceryCategories$,
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) return const Loading();

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: SmartRefresher(
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
