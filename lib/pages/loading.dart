import 'package:flutter/material.dart';
import "package:http/http.dart";
import "dart:convert";

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();

    getGroceryList();
  }

  void getGroceryList() async {
    Response response =
        await get("https://worldtimeapi.org/api/timezone/Europe/Madrid");

    Map json = jsonDecode(response.body);

    String dateTime = json["datetime"];
    String offset = json["utc_offset"].substring(1, 3);

    DateTime now = DateTime.parse(dateTime);
    print(now);

    now = now.add(Duration(hours: int.parse(offset)));

    print(now);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Text("Loading"),
    );
  }
}
