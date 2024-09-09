import "package:flutter/material.dart";
import "package:get_it/get_it.dart";
import "package:flutter_slidable/flutter_slidable.dart";

import "package:housekeeper/components/grocery_category_detail.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryCategoryCard extends StatefulWidget {
  final GroceryCategory? groceryCategory;

  const GroceryCategoryCard({super.key, this.groceryCategory});

  @override
  _GroceryCategoryCardState createState() => _GroceryCategoryCardState();
}

class _GroceryCategoryCardState extends State<GroceryCategoryCard> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  dynamic _groceryCategory;
  String _name = "";
  Widget? _detail;
  Function? _deleteFunction;

  @override
  void initState() {
    if (widget.groceryCategory != null) {
      _deleteFunction = groceries.deleteGroceryCategory;
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.groceryCategory != null) {
      _groceryCategory = widget.groceryCategory;
      _name = widget.groceryCategory!.name;
      _detail = GroceryCategoryDetail(groceryCategory: _groceryCategory);
    }

    return GestureDetector(
      onTap: () => showModalBottomSheet(context: context, builder: (context) => _detail!),
      child: Slidable(
        key: Key(_groceryCategory.id),
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
              onPressed: (context) async => await _deleteFunction!(_groceryCategory),
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
              children: [Text(_name, style: const TextStyle(fontSize: 28, letterSpacing: 2))],
            ),
          ),
        ),
      ),
    );
  }
}
