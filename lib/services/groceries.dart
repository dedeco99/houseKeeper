import "package:http/http.dart";
import "dart:convert";

import 'package:housekeeper/services/grocery.dart';

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

      for (var i = 0; i < json["data"].length; i++) {
        var grocery = json["data"][i];

        list.add(new Grocery(
          name: grocery["name"],
          price: grocery["price"],
          quantity: grocery["quantity"],
        ));
      }
    } catch (err) {
      print("error $err");
    }
  }
}
