import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:flutter_slidable/flutter_slidable.dart";

import "package:housekeeper/components/grocery_detail.dart";
import "package:housekeeper/components/grocery_list_grocery_detail.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryCard extends StatefulWidget {
  final Grocery? grocery;
  final GroceryListGrocery? groceryListGrocery;

  const GroceryCard({super.key, this.grocery, this.groceryListGrocery});

  @override
  _GroceryCardState createState() => _GroceryCardState();
}

class _GroceryCardState extends State<GroceryCard> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  dynamic _grocery;
  String _name = "";
  int _quantity = 1;
  num _price = 0;
  Widget? _detail;
  Function? _deleteFunction;

  @override
  void initState() {
    if (widget.grocery != null) {
      _deleteFunction = groceries.deleteGrocery;
    } else {
      _deleteFunction = groceries.deleteGroceryListGrocery;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.grocery != null) {
      _grocery = widget.grocery;
      _name = widget.grocery!.name;
      _quantity = widget.grocery!.defaultQuantity;
      _price = widget.grocery!.defaultPrice;
      _detail = GroceryDetail(grocery: _grocery);
    } else {
      _grocery = widget.groceryListGrocery;
      _name = widget.groceryListGrocery!.grocery.name;
      _quantity = widget.groceryListGrocery!.quantity;
      _price = widget.groceryListGrocery!.price;
      _detail = GroceryListGroceryDetail(groceryListGrocery: _grocery);
    }

    return GestureDetector(
      onTap: () => showModalBottomSheet(context: context, builder: (context) => _detail!),
      child: Slidable(
        key: Key(_grocery.id),
        endActionPane: ActionPane(
          motion: const BehindMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => showModalBottomSheet(context: context, builder: (context) => _detail!),
              backgroundColor: Colors.blue,
              icon: Icons.edit,
              label: "Editar",
            ),
            SlidableAction(
              autoClose: false,
              onPressed: (context) async => await _deleteFunction!(_grocery),
              backgroundColor: Colors.red,
              icon: Icons.delete,
              label: "Apagar",
              borderRadius: const BorderRadius.only(topRight: Radius.circular(5), bottomRight: Radius.circular(5)),
            ),
          ],
        ),
        child: Card(
          margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(children: [Text(_name, style: const TextStyle(fontSize: 28, letterSpacing: 2))]),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text("$_price €", style: const TextStyle(fontSize: 20, letterSpacing: 2)),
                    Row(
                      children: widget.grocery != null
                          ? [Text("x$_quantity", style: const TextStyle(fontSize: 20, letterSpacing: 2))]
                          : [
                              IconButton(
                                icon: const Icon(Icons.remove),
                                onPressed: _quantity > 1
                                    ? () async {
                                        await groceries.editGroceryListGrocery(
                                          _grocery,
                                          _grocery.groceryList,
                                          _quantity - 1,
                                          _price.toString(),
                                        );

                                        setState(() {});
                                      }
                                    : null,
                              ),
                              Text("x$_quantity", style: const TextStyle(fontSize: 20, letterSpacing: 2)),
                              IconButton(
                                icon: const Icon(Icons.add),
                                onPressed: () async {
                                  await groceries.editGroceryListGrocery(
                                    _grocery,
                                    _grocery.groceryList,
                                    _quantity + 1,
                                    _price.toString(),
                                  );

                                  setState(() {});
                                },
                              ),
                            ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
