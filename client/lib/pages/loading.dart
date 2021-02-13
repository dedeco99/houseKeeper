import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {
  @override
  void initState() {
    super.initState();

    redirect();
  }

  void redirect() async {
    await Future.delayed(Duration(seconds: 1));

    Navigator.pushReplacementNamed(context, "/groceryList");
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
