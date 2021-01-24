class Grocery {
  String name;
  double price;
  int quantity;

  Grocery({this.name, this.price, this.quantity});

  total() {
    return this.price * this.quantity;
  }
}
