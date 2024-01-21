import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryListGroceryDetail extends StatefulWidget {
  const GroceryListGroceryDetail({Key? key}) : super(key: key);

  @override
  _GroceryListGroceryDetailState createState() => _GroceryListGroceryDetailState();
}

class _GroceryListGroceryDetailState extends State<GroceryListGroceryDetail> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  Grocery? grocery = null;
  late final TextEditingController _quantity;
  late final TextEditingController _price;

  @override
  void initState() {
    _quantity = TextEditingController();
    _price = TextEditingController();

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
                stream: groceries.groceries$,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      final groceries = snapshot.data as List<Grocery>;

                      return DropdownButton(
                        value: grocery,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        onChanged: (Grocery? value) {
                          setState(() => grocery = value);
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
                  if (grocery == null) return;

                  await groceries.addGroceryListGrocery(grocery!.id, int.parse(_quantity.text), _price.text);

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
