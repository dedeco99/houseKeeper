import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

import "package:housekeeper/components/groceryCard.dart";
import "package:housekeeper/components/groceryDetail.dart";

import "package:housekeeper/services/groceries.dart";

class GroceryList extends StatefulWidget {
  const GroceryList({Key? key}) : super(key: key);

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryList> {
  Groceries groceries = GetIt.instance.get<Groceries>();
  RefreshController refreshController = RefreshController();

  void onRefresh() async {
    await groceries.getList();

    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: const Text("House Keeper"),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: groceries.list$,
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
                  return Dismissible(
                    key: Key(snapshot.data[index].id),
                    background: Container(color: Colors.red),
                    child: GroceryCard(grocery: snapshot.data[index]),
                    onDismissed: (direction) {
                      groceries.deleteGrocery(snapshot.data[index].id);
                    },
                  );
                },
              ));
        },
      ),
      floatingActionButton: const AddGroceryFloatingActionButton(),
    );
  }
}

class AddGroceryFloatingActionButton extends StatelessWidget {
  const AddGroceryFloatingActionButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showBottomSheet(
          context: context,
          builder: (context) => Container(
            color: Colors.grey[900],
            height: 550,
            child: Wrap(children: const [GroceryDetail()]),
          ),
        );
      },
      child: const Icon(Icons.add),
      backgroundColor: Colors.blue,
    );
  }
}
