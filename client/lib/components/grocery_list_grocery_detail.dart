import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/components/loading.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryListGroceryDetail extends StatefulWidget {
  final GroceryListGrocery? groceryListGrocery;

  const GroceryListGroceryDetail({super.key, this.groceryListGrocery});

  @override
  _GroceryListGroceryDetailState createState() => _GroceryListGroceryDetailState();
}

class _GroceryListGroceryDetailState extends State<GroceryListGroceryDetail> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  Grocery? _grocery;
  GroceryCategory? _groceryCategory;
  GroceryList? _groceryList;
  late final TextEditingController _quantity;
  late final TextEditingController _price;

  @override
  void initState() {
    _quantity = TextEditingController();
    _price = TextEditingController();

    if (widget.groceryListGrocery != null) {
      _grocery = widget.groceryListGrocery!.grocery;
      _groceryCategory = widget.groceryListGrocery!.groceryCategory;
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
        child: StreamBuilder(
          stream: groceries.groceryList$,
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.active:
                final groceryList = snapshot.data as GroceryList;

                return Column(
                  children: [
                    Padding(
                        padding: widget.groceryListGrocery == null && groceryList.id != "all"
                            ? const EdgeInsets.all(0)
                            : const EdgeInsets.fromLTRB(8, 35, 8, 8),
                        child: widget.groceryListGrocery != null || groceryList.id == "all"
                            ? StreamBuilder(
                                stream: groceries.groceryLists$,
                                builder: (BuildContext context, AsyncSnapshot snapshot) {
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.active:
                                      final groceryLists = snapshot.data as List<GroceryList>;

                                      return Autocomplete<GroceryList>(
                                        fieldViewBuilder:
                                            (context, textEditingController, focusNode, onFieldSubmitted) {
                                          return TextField(
                                            decoration: const InputDecoration(
                                              border: OutlineInputBorder(),
                                              label: Text("Grocery List"),
                                            ),
                                            controller: textEditingController,
                                            focusNode: focusNode,
                                          );
                                        },
                                        optionsBuilder: (textEditingValue) {
                                          return textEditingValue.text == ""
                                              ? groceryLists.where((l) => l.id != "all")
                                              : groceryLists.where((l) {
                                                  return l.id != "all" &&
                                                      l.name
                                                          .toString()
                                                          .contains(textEditingValue.text.toLowerCase());
                                                });
                                        },
                                        displayStringForOption: (option) => option.name,
                                        initialValue: TextEditingValue(
                                            text: widget.groceryListGrocery != null
                                                ? widget.groceryListGrocery!.groceryList.name
                                                : ""),
                                        onSelected: (option) {
                                          setState(() => _groceryList = option);
                                        },
                                      );
                                    default:
                                      return const Loading();
                                  }
                                },
                              )
                            : const Padding(padding: EdgeInsets.all(0))),
                    Padding(
                      padding: widget.groceryListGrocery == null
                          ? EdgeInsets.fromLTRB(8, groceryList.id == "all" ? 8 : 35, 8, 8)
                          : const EdgeInsets.all(0),
                      child: widget.groceryListGrocery == null
                          ? StreamBuilder(
                              stream: groceries.groceries$,
                              builder: (BuildContext context, AsyncSnapshot snapshot) {
                                switch (snapshot.connectionState) {
                                  case ConnectionState.active:
                                    final groceries = snapshot.data as List<Grocery>;

                                    return Autocomplete<Grocery>(
                                      fieldViewBuilder:
                                          (context, textEditingController, focusNode, onFieldSubmitted) {
                                        return TextField(
                                          decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            label: Text("Grocery"),
                                          ),
                                          controller: textEditingController,
                                          focusNode: focusNode,
                                        );
                                      },
                                      optionsBuilder: (textEditingValue) {
                                        if (textEditingValue.text == "") return groceries;

                                        return groceries.where((option) {
                                          return option.name
                                              .toString()
                                              .contains(textEditingValue.text.toLowerCase());
                                        });
                                      },
                                      displayStringForOption: (option) => option.name,
                                      onSelected: (option) {
                                        setState(() {
                                          _grocery = option;
                                          _groceryCategory = option.category;
                                          _quantity.text = option.defaultQuantity.toString();
                                          _price.text = option.defaultPrice.toString();
                                        });
                                      },
                                    );
                                  default:
                                    return const Loading();
                                }
                              },
                            )
                          : null,
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

                          if (widget.groceryListGrocery == null) {
                            await groceries.addGroceryListGrocery(
                              _groceryList!,
                              _grocery!,
                              _groceryCategory,
                              int.parse(_quantity.text),
                              _price.text,
                            );
                          } else {
                            await groceries.editGroceryListGrocery(
                              widget.groceryListGrocery!,
                              _groceryList!,
                              int.parse(_quantity.text),
                              _price.text,
                            );
                          }

                          Navigator.of(context).pop();
                        },
                        child: const Text("Submit"),
                      ),
                    ),
                  ],
                );
              default:
                return const Loading();
            }
          },
        ),
      ),
    );
  }
}
