import "package:http/http.dart";
import "dart:convert";

import "package:housekeeper/services/grocery.dart";

class Groceries {
  String store;
  List<Grocery> list = [];

  Groceries({this.store});

  Future<void> getList() async {
    try {
      Response response =
          await get("http://192.168.1.205:5000/api/groceries/$store");

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      list = [];

      for (var i = 0; i < json["data"].length; i++) {
        var grocery = json["data"][i];

        list.add(new Grocery(
          id: grocery["_id"],
          name: grocery["name"],
          price: grocery["price"],
          quantity: grocery["quantity"],
        ));
      }
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> addGrocery(name, category, store, quantity) async {
    try {
      Response response = await post(
        "http://192.168.1.205:5000/api/groceries",
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({
          "name": name,
          "category": category,
          "store": store,
          "quantity": quantity
        }),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      var grocery = json["data"];

      list.add(new Grocery(
        id: grocery["_id"],
        name: grocery["name"],
        price: grocery["price"],
        quantity: grocery["quantity"],
      ));
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> deleteGrocery(id) async {
    try {
      Response response =
          await delete("http://192.168.1.205:5000/api/groceries/$id");

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      var grocery = json["data"];

      list.removeWhere((g) => g.id == grocery["_id"]);
    } catch (err) {
      print("error $err");
    }
  }
}
