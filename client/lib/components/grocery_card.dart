import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/services/groceries.dart";
import "package:housekeeper/services/grocery.dart";

class GroceryCard extends StatefulWidget {
  final Grocery grocery;

  const GroceryCard({Key? key, required this.grocery}) : super(key: key);

  @override
  _GroceryCardState createState() => _GroceryCardState();
}

class _GroceryCardState extends State<GroceryCard> {
  Groceries groceries = GetIt.instance.get<Groceries>();

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  widget.grocery.name,
                  style: TextStyle(fontSize: 28, letterSpacing: 2),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${widget.grocery.price} €",
                  style: TextStyle(fontSize: 20, letterSpacing: 2),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove),
                      onPressed: widget.grocery.quantity > 1
                          ? () {
                              groceries.addGroceryListGrocery(
                                widget.grocery.id,
                                widget.grocery.quantity - 1,
                                widget.grocery.price.toString(),
                              );
                            }
                          : null,
                    ),
                    Text(
                      "x${widget.grocery.quantity}",
                      style: TextStyle(fontSize: 20, letterSpacing: 2),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        groceries.addGroceryListGrocery(
                          widget.grocery.id,
                          widget.grocery.quantity + 1,
                          widget.grocery.price.toString(),
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
    );
  }
}
