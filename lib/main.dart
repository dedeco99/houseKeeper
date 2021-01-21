import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    home: App(),
  ));
}

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  List<String> groceries = ["Leite", "Cereais", "Bolachas", "Tremoços"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        title: Text("House Keeper"),
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 40, 30, 0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: groceries.map((grocery) {
            return Center(
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Text(
                  grocery,
                  style: TextStyle(
                    fontSize: 28,
                    letterSpacing: 2,
                    color: Colors.grey[200],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
