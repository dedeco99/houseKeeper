import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/components/grocery_list_grocery_detail.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryListGroceryCard extends StatefulWidget {
  final GroceryListGrocery groceryListGrocery;

  const GroceryListGroceryCard({Key? key, required this.groceryListGrocery}) : super(key: key);

  @override
  _GroceryCardState createState() => _GroceryCardState();
}

class _GroceryCardState extends State<GroceryListGroceryCard> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => showModalBottomSheet(
        context: context,
        builder: (context) => GroceryListGroceryDetail(groceryListGrocery: widget.groceryListGrocery),
      ),
      child: Card(
        margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(children: [
                Text(
                  widget.groceryListGrocery.grocery.name,
                  style: TextStyle(fontSize: 28, letterSpacing: 2),
                )
              ]),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    "${widget.groceryListGrocery.price} €",
                    style: TextStyle(fontSize: 20, letterSpacing: 2),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: widget.groceryListGrocery.quantity > 1
                            ? () {
                                groceries.addGroceryListGrocery(
                                  widget.groceryListGrocery.grocery,
                                  widget.groceryListGrocery.quantity - 1,
                                  widget.groceryListGrocery.price.toString(),
                                );
                              }
                            : null,
                      ),
                      Text(
                        "x${widget.groceryListGrocery.quantity}",
                        style: TextStyle(fontSize: 20, letterSpacing: 2),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          groceries.addGroceryListGrocery(
                            widget.groceryListGrocery.grocery,
                            widget.groceryListGrocery.quantity + 1,
                            widget.groceryListGrocery.price.toString(),
                          );
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
    );
  }
}
