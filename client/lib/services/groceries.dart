import "package:http/http.dart";
import "dart:convert";

import "package:housekeeper/services/grocery.dart";
import 'package:rxdart/rxdart.dart';

class Groceries {
  String store;
  BehaviorSubject listSubject = BehaviorSubject.seeded([]);

  Groceries({this.store}) {
    getList();
  }

  Stream get list$ => listSubject.stream;
  List get list => listSubject.value;

  Future<void> getList() async {
    try {
      Response response =
          await get("http://192.168.1.205:5000/api/groceries/$store");

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      list.clear();

      for (var i = 0; i < json["data"].length; i++) {
        var grocery = json["data"][i];

        list.add(new Grocery(
          id: grocery["_id"],
          name: grocery["name"],
          price: grocery["price"],
          quantity: grocery["quantity"],
        ));
      }

      listSubject.add(list);
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

      listSubject.add(list);
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

      listSubject.add(list);
    } catch (err) {
      print("error $err");
    }
  }

  void dispose() {
    listSubject.close();
  }
}
