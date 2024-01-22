import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryListGroceryDetail extends StatefulWidget {
  GroceryListGrocery? groceryListGrocery;

  GroceryListGroceryDetail({Key? key, GroceryListGrocery? grocery}) : super(key: key);

  @override
  _GroceryListGroceryDetailState createState() => _GroceryListGroceryDetailState();
}

class _GroceryListGroceryDetailState extends State<GroceryListGroceryDetail> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  Grocery? _grocery = null;
  GroceryList? _groceryList = null;
  late final TextEditingController _quantity;
  late final TextEditingController _price;

  @override
  void initState() {
    _quantity = TextEditingController();
    _price = TextEditingController();

    if (widget.groceryListGrocery != null) {
      _grocery = widget.groceryListGrocery!.grocery;
      _groceryList = widget.groceryListGrocery!.groceryList;
      _quantity.text = widget.groceryListGrocery!.quantity.toString();
      _price.text = widget.groceryListGrocery!.price.toString();
    }

    super.initState();
  }

  @override
  void dispose() {
    _quantity.dispose();
    _price.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Form(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 35, 8, 8),
              child: StreamBuilder(
                stream: groceries.groceryLists$,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      final groceryLists = snapshot.data as List<GroceryList>;

                      return DropdownButton(
                        value: _groceryList,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        onChanged: (GroceryList? value) {
                          setState(() => _groceryList = value);
                        },
                        items: groceryLists.map((GroceryList value) {
                          return DropdownMenuItem(value: value, child: Text(value.name));
                        }).toList(),
                      );
                    default:
                      return const Text("Loading");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 35, 8, 8),
              child: StreamBuilder(
                stream: groceries.groceries$,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      final groceries = snapshot.data as List<Grocery>;

                      return DropdownButton(
                        value: _grocery,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        onChanged: (Grocery? value) {
                          setState(() => _grocery = value);
                        },
                        items: groceries.map((Grocery value) {
                          return DropdownMenuItem(value: value, child: Text(value.name));
                        }).toList(),
                      );
                    default:
                      return const Text("Loading");
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _quantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Quantity"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _price,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Price"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () async {
                  if (_grocery == null) return;

                  await groceries.addGroceryListGrocery(_grocery!.id, int.parse(_quantity.text), _price.text);

                  Navigator.of(context).pop();
                },
                child: const Text("Submit"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
