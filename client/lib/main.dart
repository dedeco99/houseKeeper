import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/pages/home.dart";
import "package:housekeeper/pages/groceryList.dart";
import "package:housekeeper/services/groceries.dart";

void main() {
  GetIt.instance.registerSingleton<Groceries>(Groceries(store: "Lidl"));

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: "House Keeper",
    theme: ThemeData(primarySwatch: Colors.blue),
    home: const Home(),
    routes: {
      "/home": (context) => const Home(),
      "/groceryList": (context) => const GroceryList(),
    },
  ));
}
