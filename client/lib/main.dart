import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'package:housekeeper/pages/home.dart';
import 'package:housekeeper/pages/loading.dart';
import 'package:housekeeper/pages/groceryList.dart';
import 'package:housekeeper/services/groceries.dart';

void main() {
  GetIt.instance.registerSingleton<Groceries>(Groceries(store: "Lidl"));

  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => Loading(),
      "/home": (context) => Home(),
      "/groceryList": (context) => GroceryList(),
    },
  ));
}
