import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/services/groceries.dart";

class GroceryDetail extends StatefulWidget {
  const GroceryDetail({Key? key}) : super(key: key);

  @override
  _GroceryDetailState createState() => _GroceryDetailState();
}

class _GroceryDetailState extends State<GroceryDetail> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  late final TextEditingController _name;
  late final TextEditingController _category;
  late final TextEditingController _store;
  late final TextEditingController _quantity;
  late final TextEditingController _price;

  @override
  void initState() {
    _name = TextEditingController();
    _category = TextEditingController();
    _store = TextEditingController();
    _quantity = TextEditingController();
    _price = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _category.dispose();
    _store.dispose();
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
              child: TextFormField(
                controller: _name,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Name"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _category,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Category"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _store,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Store"),
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
                  /*
                  await groceries.addGrocery(
                    _name.text,
                    _category.text,
                    _store.text,
                    _quantity.text,
                    _price.text,
                  );
                  */
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
