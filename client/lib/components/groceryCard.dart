import "package:flutter/material.dart";

import "package:housekeeper/services/grocery.dart";

class GroceryCard extends StatelessWidget {
  const GroceryCard({Key? key, required this.grocery}) : super(key: key);

  final Grocery grocery;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.fromLTRB(0, 5, 0, 5),
      color: Colors.grey[800],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  grocery.name,
                  style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 2,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "${grocery.price} €",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                    color: Colors.grey[200],
                  ),
                ),
                Text(
                  "x${grocery.quantity}",
                  style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 2,
                    color: Colors.grey[200],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
