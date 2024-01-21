import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

import "package:housekeeper/components/grocery_card.dart";
import "package:housekeeper/components/grocery_detail.dart";
import "package:housekeeper/components/grocery_list_detail.dart";
import "package:housekeeper/components/grocery_list_grocery_detail.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryListView extends StatefulWidget {
  const GroceryListView({Key? key}) : super(key: key);

  @override
  _GroceryListState createState() => _GroceryListState();
}

class _GroceryListState extends State<GroceryListView> {
  Groceries groceries = GetIt.instance.get<Groceries>();
  RefreshController refreshController = RefreshController();

  GroceryList? groceryList;

  void onRefresh() async {
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Row(children: [
          StreamBuilder(
            stream: groceries.groceryLists$,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.active:
                  final lists = snapshot.data as List<GroceryList>;

                  return DropdownButton(
                    value: groceryList,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(height: 2, color: Colors.deepPurpleAccent),
                    onChanged: (GroceryList? value) {
                      if (value != null) groceries.getGroceryListGroceries(value.id);
                    },
                    items: lists.map((GroceryList value) {
                      return DropdownMenuItem(value: value, child: Text(value.name));
                    }).toList(),
                  );
                default:
                  return const Text("Loading");
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(
                context: context,
                builder: (context) => Container(
                  color: Colors.grey[900],
                  height: 550,
                  child: const Wrap(children: [GroceryListDetail()]),
                ),
              );
            },
          ),
        ]),
        elevation: 0,
      ),
      body: StreamBuilder(
        stream: groceries.groceryListGroceries$,
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
                      groceries.deleteGroceryListGrocery(snapshot.data[index].id);
                    },
                  );
                },
              ));
        },
      ),
      floatingActionButton: const Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 65),
              child: AddFloatingActionButton(child: GroceryDetail()),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: AddFloatingActionButton(child: GroceryListGroceryDetail()),
          ),
        ],
      ),
    );
  }
}

class AddFloatingActionButton extends StatelessWidget {
  const AddFloatingActionButton({Key? key, required this.child}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        showModalBottomSheet(
          context: context,
          builder: (context) => Container(
            color: Colors.grey[900],
            height: 550,
            child: Wrap(children: [child]),
          ),
        );
      },
      backgroundColor: Colors.blue,
      child: const Icon(Icons.add),
    );
  }
}
