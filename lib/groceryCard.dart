import 'package:flutter/material.dart';

import "grocery.dart";

class GroceryCard extends StatelessWidget {
  final Grocery grocery;
  final Function onDelete;

  GroceryCard({this.grocery, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.fromLTRB(0, 5, 0, 5),
      color: Colors.grey[800],
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Text(
                  "${grocery.name}",
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
                TextButton.icon(
                  onPressed: onDelete,
                  icon: Icon(Icons.delete),
                  label: Text("Delete"),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
