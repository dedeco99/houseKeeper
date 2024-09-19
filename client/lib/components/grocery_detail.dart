import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/components/loading.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryDetail extends StatefulWidget {
  final Grocery? grocery;

  const GroceryDetail({super.key, this.grocery});

  @override
  _GroceryDetailState createState() => _GroceryDetailState();
}

class _GroceryDetailState extends State<GroceryDetail> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  late final TextEditingController _name;
  GroceryCategory? _category;
  late final TextEditingController _defaultQuantity;
  late final TextEditingController _defaultPrice;

  @override
  void initState() {
    _name = TextEditingController();
    _defaultQuantity = TextEditingController();
    _defaultPrice = TextEditingController();

    if (widget.grocery != null) {
      _name.text = widget.grocery!.name;
      _category = widget.grocery!.category;
      _defaultQuantity.text = widget.grocery!.defaultQuantity.toString();
      _defaultPrice.text = widget.grocery!.defaultPrice.toString();
    }

    super.initState();
  }

  @override
  void dispose() {
    _name.dispose();
    _defaultQuantity.dispose();
    _defaultPrice.dispose();

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
              child: StreamBuilder(
                stream: groceries.groceryCategories$,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  switch (snapshot.connectionState) {
                    case ConnectionState.active:
                      final groceries = snapshot.data as List<GroceryCategory>;

                      return Autocomplete<GroceryCategory>(
                        fieldViewBuilder: (context, textEditingController, focusNode, onFieldSubmitted) {
                          return TextField(
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              label: Text("Category"),
                            ),
                            controller: textEditingController,
                            focusNode: focusNode,
                          );
                        },
                        optionsBuilder: (textEditingValue) {
                          if (textEditingValue.text == "") return groceries;

                          return groceries.where((option) {
                            return option.name.toString().contains(textEditingValue.text.toLowerCase());
                          });
                        },
                        displayStringForOption: (option) => option.name,
                        initialValue: TextEditingValue(text: _category != null ? _category!.name : ""),
                        onSelected: (option) {
                          setState(() {
                            _category = option;
                          });
                        },
                      );
                    default:
                      return const Loading();
                  }
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _defaultQuantity,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Quantity"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextFormField(
                controller: _defaultPrice,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(border: OutlineInputBorder(), labelText: "Price"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: TextButton(
                onPressed: () async {
                  if (_name.text == "") return;

                  if (widget.grocery == null) {
                    await groceries.addGrocery(
                      _name.text,
                      _category,
                      int.parse(_defaultQuantity.text),
                      _defaultPrice.text,
                    );
                  } else {
                    await groceries.editGrocery(
                      widget.grocery!,
                      _name.text,
                      _category,
                      int.parse(_defaultQuantity.text),
                      _defaultPrice.text,
                    );
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
