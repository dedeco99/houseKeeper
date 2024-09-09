import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryCategoryDetail extends StatefulWidget {
  final GroceryCategory? groceryCategory;

  const GroceryCategoryDetail({super.key, this.groceryCategory});

  @override
  _GroceryCategoryDetailState createState() => _GroceryCategoryDetailState();
}

class _GroceryCategoryDetailState extends State<GroceryCategoryDetail> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  late final TextEditingController _name;

  @override
  void initState() {
    _name = TextEditingController();

    if (widget.groceryCategory != null) {
      _name.text = widget.groceryCategory!.name;
    }

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
                  if (_name.text == "") return;

                  if (widget.groceryCategory == null) {
                    await groceries.addGroceryCategory(_name.text);
                  } else {
                    await groceries.editGroceryCategory(widget.groceryCategory!, _name.text);
                  }

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
