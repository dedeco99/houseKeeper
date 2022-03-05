class Grocery {
  String id;
  String name;
  double price;
  int quantity;

  Grocery(
      {required this.id,
      required this.name,
      this.price = 0,
      this.quantity = 1});

  total() {
    return this.price * this.quantity;
  }
}
