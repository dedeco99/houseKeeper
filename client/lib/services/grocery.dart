import 'package:flutter/foundation.dart';

@immutable
class Grocery {
  final String id;
  final String name;
  final int quantity;
  final num price;

  const Grocery({
    required this.id,
    required this.name,
    this.quantity = 1,
    this.price = 0,
  });

  @override
  bool operator ==(covariant Grocery other) => id == other.id;

  @override
  int get hashCode => id.hashCode;

  total() {
    return quantity * price;
  }
}
