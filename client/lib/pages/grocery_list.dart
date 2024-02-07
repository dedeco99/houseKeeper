import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:flutter_slidable/flutter_slidable.dart";
import "package:multiple_stream_builder/multiple_stream_builder.dart";

import "package:housekeeper/components/grocery_card.dart";
import "package:housekeeper/components/grocery_list_detail.dart";
import "package:housekeeper/components/grocery_list_grocery_detail.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryListView extends StatefulWidget {
  const GroceryListView({super.key});

  @override
  _GroceryListViewState createState() => _GroceryListViewState();
}

class _GroceryListViewState extends State<GroceryListView> {
  Groceries groceries = GetIt.instance.get<Groceries>();
  RefreshController refreshController = RefreshController();

  void onRefresh() async {
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(children: [
          StreamBuilder2<List<GroceryList>, GroceryList?>(
            streams: StreamTuple2(groceries.groceryLists$, groceries.groceryList$),
            builder: (context, snapshots) {
              switch (snapshots.snapshot1.connectionState) {
                case ConnectionState.active:
                  final groceryLists = snapshots.snapshot1.data as List<GroceryList>;
                  final groceryList = snapshots.snapshot2.data;

                  return DropdownMenu<GroceryList>(
                    label: const Text("List"),
                    inputDecorationTheme: const InputDecorationTheme(
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.all(10),
                      constraints: BoxConstraints(maxHeight: 45),
                    ),
                    initialSelection: groceryList,
                    dropdownMenuEntries: groceryLists.map((value) {
                      return DropdownMenuEntry(value: value, label: value.name);
                    }).toList(),
                    onSelected: (value) {
                      if (value != null) {
                        groceries.getGroceryListGroceries(value);
                      }
                    },
                  );
                default:
                  return const Text("Loading");
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              showModalBottomSheet(context: context, builder: (context) => const GroceryListDetail());
            },
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.list),
            onPressed: () {
              Navigator.pushNamed(context, "/groceries");
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
                final GroceryListGrocery grocery = snapshot.data[index];

                return Slidable(
                  key: Key(grocery.id),
                  endActionPane: ActionPane(
                    motion: const BehindMotion(),
                    children: [
                      SlidableAction(
                        onPressed: (context) => showModalBottomSheet(
                          context: context,
                          builder: (context) => GroceryListGroceryDetail(groceryListGrocery: grocery),
                        ),
                        backgroundColor: Colors.blue,
                        icon: Icons.edit,
                        label: "Editar",
                      ),
                      SlidableAction(
                        autoClose: false,
                        onPressed: (context) async {
                          await groceries.deleteGroceryListGrocery(grocery);
                        },
                        backgroundColor: Colors.red,
                        icon: Icons.delete,
                        label: "Apagar",
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(5),
                          bottomRight: Radius.circular(5),
                        ),
                      ),
                    ],
                  ),
                  child: GroceryCard(groceryListGrocery: grocery),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context) => const GroceryListGroceryDetail());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
