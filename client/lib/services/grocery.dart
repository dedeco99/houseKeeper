import "package:flutter/foundation.dart";

@immutable
class Grocery {
  final String id;
  final String name;
  final int defaultQuantity;
  final num defaultPrice;

  const Grocery({
    required this.id,
    required this.name,
    this.defaultQuantity = 1,
    this.defaultPrice = 0,
  });

  @override
  bool operator ==(covariant Grocery other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class GroceryList {
  final String id;
  final String name;

  const GroceryList({required this.id, required this.name});

  @override
  bool operator ==(covariant GroceryList other) => id == other.id;

  @override
  int get hashCode => id.hashCode;
}

@immutable
class GroceryListGrocery {
  final String id;
  final GroceryList groceryList;
  final Grocery grocery;
  final int quantity;
  final num price;

  const GroceryListGrocery({
    required this.id,
    required this.groceryList,
    required this.grocery,
    this.quantity = 1,
    this.price = 0,
  });

  @override
  bool operator ==(covariant GroceryListGrocery other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  total() {
    return quantity * price;
  }
}
