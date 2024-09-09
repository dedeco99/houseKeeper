import "package:flutter/material.dart";
import "package:flutter/foundation.dart";
import "package:flutter_dotenv/flutter_dotenv.dart";
import "package:get_it/get_it.dart";

import "package:housekeeper/pages/home.dart";
import "package:housekeeper/pages/grocery_list.dart";
import "package:housekeeper/pages/groceries.dart";
import "package:housekeeper/pages/grocery_categories.dart";

import "package:housekeeper/services/groceries.dart";

Future<void> main() async {
  await dotenv.load(fileName: kReleaseMode ? ".env.production" : ".env");

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
      "/grocery_list": (context) => const GroceryListView(),
      "/groceries": (context) => const GroceriesView(),
      "/grocery_categories": (context) => const GroceryCategoriesView(),
    },
  ));
}
