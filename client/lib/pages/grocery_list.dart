import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";
import "package:flutter_slidable/flutter_slidable.dart";

import "package:housekeeper/components/grocery_list_grocery_card.dart";
import "package:housekeeper/components/grocery_list_detail.dart";
import "package:housekeeper/components/grocery_list_grocery_detail.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryListView extends StatefulWidget {
  const GroceryListView({Key? key}) : super(key: key);

  @override
  _GroceryListViewState createState() => _GroceryListViewState();
}

class _GroceryListViewState extends State<GroceryListView> {
  Groceries groceries = GetIt.instance.get<Groceries>();
  RefreshController refreshController = RefreshController();

  GroceryList? groceryList;

  void onRefresh() async {
    refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                    onChanged: (GroceryList? value) {
                      if (value != null) {
                        setState(() => groceryList = value);

                        groceries.getGroceryListGroceries(value);
                      }
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
              showModalBottomSheet(context: context, builder: (context) => const GroceryListDetail());
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
                  child: GroceryListGroceryCard(groceryListGrocery: grocery),
                );
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(context: context, builder: (context) => GroceryListGroceryDetail());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
