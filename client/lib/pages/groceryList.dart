import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:pull_to_refresh/pull_to_refresh.dart";

import "package:housekeeper/components/groceryCard.dart";
import "package:housekeeper/components/groceryDetail.dart";
import "package:housekeeper/components/groceryListDetail.dart";

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
        title: StreamBuilder(
          stream: groceries.lists$,
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
                    if (value != null) groceries.getList(value.id);
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
      floatingActionButton: const Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: EdgeInsets.only(bottom: 65),
              child: AddFloatingActionButton(child: GroceryDetail()),
            ),
          ),
          Align(alignment: Alignment.bottomRight, child: AddFloatingActionButton(child: GroceryListDetail())),
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
        showBottomSheet(
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
