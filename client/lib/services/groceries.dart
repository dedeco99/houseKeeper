import "package:http/http.dart";
import "dart:convert";

import "package:housekeeper/services/grocery.dart";
import "package:rxdart/rxdart.dart";

class Groceries {
  String? groceryList;

  BehaviorSubject<List<Grocery>> groceriesSubject = BehaviorSubject.seeded([]);
  BehaviorSubject<List<GroceryList>> listsSubject = BehaviorSubject.seeded([]);
  BehaviorSubject listSubject = BehaviorSubject.seeded([]);

  Groceries() {
    getLists();
    getGroceries();
  }

  Stream<List<Grocery>> get groceries$ => groceriesSubject.stream;
  List<Grocery> get groceries => groceriesSubject.value;
  Stream<List<GroceryList>> get lists$ => listsSubject.stream;
  List<GroceryList> get lists => listsSubject.value;
  Stream get list$ => listSubject.stream;
  List get list => listSubject.value;
  String host = "192.168.1.69";

  Future<void> getGroceries() async {
    try {
      Response response = await get(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/groceries",
        ),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      groceries.clear();

      for (var i = 0; i < json["data"].length; i++) {
        var grocery = json["data"][i];

        groceries.add(Grocery(id: grocery["id"], name: grocery["name"]));
      }

      groceriesSubject.add(groceries);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> getLists() async {
    try {
      Response response = await get(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists",
        ),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      lists.clear();

      for (var i = 0; i < json["data"].length; i++) {
        var groceryList = json["data"][i];

        lists.add(GroceryList(id: groceryList["id"], name: groceryList["name"]));
      }

      listsSubject.add(lists);

      if (lists.isNotEmpty) getList(lists.first.id);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> getList(String groceryList) async {
    try {
      Response response = await get(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists/$groceryList",
        ),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      list.clear();

      if (json["data"] != null) {
        for (var i = 0; i < json["data"].length; i++) {
          var grocery = json["data"][i];

          list.add(
            Grocery(
              id: grocery["id"],
              name: grocery["name"]["String"],
              price: int.parse(grocery["price"]),
              quantity: grocery["quantity"],
            ),
          );
        }
      }

      listSubject.add(list);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> addGroceryList(name) async {
    try {
      Response response = await post(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"name": name}),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      var grocery = json["data"];

      lists.insert(0, GroceryList(id: grocery["id"], name: grocery["name"]));

      listsSubject.add(lists);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> addGroceryListGrocery(grocery, quantity, price) async {
    try {
      Response response = await post(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists/:id/groceries",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"grocery": grocery, "quantity": quantity, "price": price}),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      var groceryListGrocery = json["data"];

      list.insert(
        0,
        Grocery(
          id: groceryListGrocery["id"],
          name: groceryListGrocery["name"],
          price: int.parse(groceryListGrocery["default_price"]),
          quantity: groceryListGrocery["default_quantity"],
        ),
      );

      listSubject.add(list);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> deleteGrocery(id) async {
    try {
      Response response = await delete(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists/groceries/$id",
        ),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      var grocery = json["data"];

      list.removeWhere((g) => g.id == grocery["id"]);

      listSubject.add(list);
    } catch (err) {
      print("error $err");
    }
  }

  void dispose() {
    listSubject.close();
  }
}
