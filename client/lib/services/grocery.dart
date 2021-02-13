class Grocery {
  String id;
  String name;
  double price;
  int quantity;

  Grocery({this.id, this.name, this.price, this.quantity});

  total() {
    return this.price * this.quantity;
  }
}
