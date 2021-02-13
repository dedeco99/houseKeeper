import 'package:flutter/material.dart';

import 'package:housekeeper/pages/home.dart';
import 'package:housekeeper/pages/loading.dart';
import 'package:housekeeper/pages/groceryList.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: "/",
    routes: {
      "/": (context) => Loading(),
      "/home": (context) => Home(),
      "/groceryList": (context) => GroceryList(),
    },
  ));
}
