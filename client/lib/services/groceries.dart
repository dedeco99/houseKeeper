import "package:http/http.dart";
import "dart:convert";

import "package:housekeeper/services/grocery.dart";
import "package:rxdart/rxdart.dart";

class Groceries {
  static const String host = "192.168.1.69";

  BehaviorSubject<List<Grocery>> groceriesSubject = BehaviorSubject.seeded([]);
  BehaviorSubject<List<GroceryList>> groceryListsSubject = BehaviorSubject.seeded([]);
  BehaviorSubject<List<GroceryListGrocery>> groceryListGroceriesSubject = BehaviorSubject.seeded([]);

  Stream<List<Grocery>> get groceries$ => groceriesSubject.stream;
  List<Grocery> get groceries => groceriesSubject.value;
  Stream<List<GroceryList>> get groceryLists$ => groceryListsSubject.stream;
  List<GroceryList> get groceryLists => groceryListsSubject.value;
  Stream<List<GroceryListGrocery>> get groceryListGroceries$ => groceryListGroceriesSubject.stream;
  List<GroceryListGrocery> get groceryListGroceries => groceryListGroceriesSubject.value;

  GroceryList? currentGroceryList;

  Groceries() {
    getGroceryLists();
    getGroceries();
  }

  void dispose() {
    groceriesSubject.close();
    groceryListsSubject.close();
    groceryListGroceriesSubject.close();
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

        groceries.add(Grocery(id: grocery["id"], name: grocery["name"]));
      }

      groceriesSubject.add(groceries);
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

      var groceryList = json["data"];

      groceryLists.insert(0, GroceryList(id: groceryList["id"], name: groceryList["name"]));

      groceryListsSubject.add(groceryLists);

      currentGroceryList = groceryList["id"];
    } catch (err) {
      print("error $err");
    }
  }

  Future<void> getGroceryListGroceries(GroceryList groceryList) async {
    try {
      currentGroceryList = groceryList;

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
              price: int.parse(grocery["price"]),
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
          path: "/api/grocery_lists/${currentGroceryList!.id}",
        ),
        headers: <String, String>{
          "Content-Type": "application/json; charset=UTF-8",
        },
        body: jsonEncode({"grocery": grocery.id, "quantity": quantity, "price": price}),
      );

      Map json = jsonDecode(response.body);

      if (response.statusCode != 201 && response.statusCode != 200) throw json["message"];

      getGroceryListGroceries(currentGroceryList!);
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

      getGroceryListGroceries(currentGroceryList!);
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

      var grocery = json["data"];

      groceryListGroceries.removeWhere((g) => g.id == grocery["id"]);

      groceryListGroceriesSubject.add(groceryListGroceries);
    } catch (err) {
      print("error $err");
    }
  }
}
