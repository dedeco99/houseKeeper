import "package:http/http.dart";
import "dart:convert";

import "package:housekeeper/services/grocery.dart";
import "package:rxdart/rxdart.dart";

class Groceries {
  static const String host = "192.168.1.69";

  BehaviorSubject<List<Grocery>> groceriesSubject = BehaviorSubject.seeded([]);
  BehaviorSubject<List<GroceryList>> groceryListsSubject = BehaviorSubject.seeded([]);
  BehaviorSubject<List<GroceryListGrocery>> groceryListGroceriesSubject = BehaviorSubject.seeded([]);
  BehaviorSubject<GroceryList?> groceryListSubject = BehaviorSubject.seeded(null);

  Stream<List<Grocery>> get groceries$ => groceriesSubject.stream;
  List<Grocery> get groceries => groceriesSubject.value;
  Stream<List<GroceryList>> get groceryLists$ => groceryListsSubject.stream;
  List<GroceryList> get groceryLists => groceryListsSubject.value;
  Stream<List<GroceryListGrocery>> get groceryListGroceries$ => groceryListGroceriesSubject.stream;
  List<GroceryListGrocery> get groceryListGroceries => groceryListGroceriesSubject.value;
  Stream<GroceryList?> get groceryList$ => groceryListSubject.stream;
  GroceryList? get groceryList => groceryListSubject.value;

  Groceries() {
    getGroceryLists();
    getGroceries();
  }

  void dispose() {
    groceriesSubject.close();
    groceryListsSubject.close();
    groceryListGroceriesSubject.close();
    groceryListSubject.close();
  }

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

      if (response.statusCode != 200) throw json["message"];

      groceries.clear();

      for (var i = 0; i < json["data"].length; i++) {
        var grocery = json["data"][i];

        groceries.add(Grocery(
          id: grocery["id"],
          name: grocery["name"],
          defaultQuantity: grocery["default_quantity"],
          defaultPrice: num.parse(grocery["default_price"]),
        ));
      }

      groceriesSubject.add(groceries);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> addGrocery(String name, int defaultQuantity, String defaultPrice) async {
    try {
      Response response = await post(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/groceries",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"name": name, "defaultQuantity": defaultQuantity, "defaultPrice": defaultPrice}),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode != 201) throw json["message"];

      var grocery = json["data"];
      print(grocery);
      groceries.insert(
        0,
        Grocery(
          id: grocery["id"],
          name: grocery["name"],
          defaultQuantity: grocery["default_quantity"],
          defaultPrice: num.parse(grocery["default_price"]),
        ),
      );

      groceriesSubject.add(groceries);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> editGrocery(Grocery grocery, String name, int defaultQuantity, String defaultPrice) async {
    try {
      Response response = await put(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/groceries/${grocery.id}",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"name": name, "defaultQuantity": defaultQuantity, "defaultPrice": defaultPrice}),
      );
      print(jsonEncode({"name": name, "defaultQuantity": defaultQuantity, "defaultPrice": defaultPrice}));
      Map json = jsonDecode(response.body);

      if (response.statusCode != 200) throw json["message"];

      getGroceryListGroceries(groceryList!);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> deleteGrocery(Grocery grocery) async {
    try {
      Response response = await delete(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/groceries/${grocery.id}",
        ),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode != 200) throw json["message"];

      groceryListGroceries.removeWhere((g) => g.id == json["data"]["id"]);

      groceryListGroceriesSubject.add(groceryListGroceries);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> getGroceryLists() async {
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

      if (response.statusCode != 200) throw json["message"];

      groceryLists.clear();

      for (var i = 0; i < json["data"].length; i++) {
        var groceryList = json["data"][i];

        groceryLists.add(GroceryList(id: groceryList["id"], name: groceryList["name"]));
      }

      groceryListsSubject.add(groceryLists);

      if (groceryLists.isNotEmpty) getGroceryListGroceries(groceryLists.first);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> addGroceryList(String name) async {
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

      if (response.statusCode != 201) throw json["message"];

      var groceryList = GroceryList(id: json["data"]["id"], name: json["data"]["name"]);

      groceryLists.insert(0, groceryList);

      groceryListsSubject.add(groceryLists);

      getGroceryListGroceries(groceryList);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> getGroceryListGroceries(GroceryList groceryList) async {
    try {
      groceryListSubject.add(groceryList);

      Response response = await get(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists/${groceryList.id}",
        ),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode != 200) throw json["message"];

      groceryListGroceries.clear();

      if (json["data"] != null) {
        for (var i = 0; i < json["data"].length; i++) {
          var grocery = json["data"][i];

          groceryListGroceries.add(
            GroceryListGrocery(
              id: grocery["id"],
              groceryList: GroceryList(id: grocery["grocery_list"], name: grocery["grocery_list_name"]["String"]),
              grocery: Grocery(id: grocery["grocery"], name: grocery["name"]["String"]),
              price: num.parse(grocery["price"]),
              quantity: grocery["quantity"],
            ),
          );
        }
      }

      groceryListGroceriesSubject.add(groceryListGroceries);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> addGroceryListGrocery(Grocery grocery, int quantity, String price) async {
    try {
      Response response = await post(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists/${groceryList!.id}",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"grocery": grocery.id, "quantity": quantity, "price": price}),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode != 201) throw json["message"];

      getGroceryListGroceries(groceryList!);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> editGroceryListGrocery(
    GroceryListGrocery groceryListGrocery,
    GroceryList groceryList,
    int quantity,
    String price,
  ) async {
    try {
      Response response = await put(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists/groceries/${groceryListGrocery.id}",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"groceryList": groceryList.id, "quantity": quantity, "price": price}),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode != 200) throw json["message"];

      await getGroceryListGroceries(groceryList);
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> deleteGroceryListGrocery(GroceryListGrocery groceryListGrocery) async {
    try {
      Response response = await delete(
        Uri(
          scheme: "http",
          host: host,
          port: 5001,
          path: "/api/grocery_lists/groceries/${groceryListGrocery.id}",
        ),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode != 200) throw json["message"];

      groceryListGroceries.removeWhere((g) => g.id == json["data"]["id"]);

      groceryListGroceriesSubject.add(groceryListGroceries);
    } catch (err) {
      print("error $err");
    }
  }
}
