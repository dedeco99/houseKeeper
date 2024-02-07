import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/services/groceries.dart";

class GroceryListDetail extends StatefulWidget {
  const GroceryListDetail({super.key});

  @override
  _GroceryListDetailState createState() => _GroceryListDetailState();
}

class _GroceryListDetailState extends State<GroceryListDetail> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  late final TextEditingController _name;

  @override
  void initState() {
    _name = TextEditingController();

    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();

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
              child: TextButton(
                onPressed: () async {
                  await groceries.addGroceryList(_name.text);

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
