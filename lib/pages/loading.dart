import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import "package:housekeeper/services/groceries.dart";

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  void getGroceryList() async {
    Groceries groceries = Groceries(store: "lidl");

    await groceries.getList();

    Navigator.pushReplacementNamed(
      context,
      "/home",
      arguments: {"store": groceries.store, "list": groceries.list},
    );
  }

  @override
  void initState() {
    super.initState();

    getGroceryList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      body: Center(
        child: SpinKitWave(
          color: Colors.white,
          size: 75,
        ),
      ),
    );
  }
}
