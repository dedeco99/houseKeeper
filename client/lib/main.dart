import "package:flutter/material.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/pages/home.dart";
import "package:housekeeper/pages/grocery_list.dart";
import "package:housekeeper/pages/groceries.dart";

import "package:housekeeper/services/groceries.dart";

void main() {
  GetIt.instance.registerSingleton<Groceries>(Groceries());

  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    title: "House Keeper",
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.dark,
      ),
    ),
    home: const Home(),
    routes: {
      "/home": (context) => const Home(),
      "/groceryList": (context) => const GroceryListView(),
      "/groceries": (context) => const GroceriesView(),
    },
  ));
}
