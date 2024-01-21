import "package:flutter/material.dart";
import "package:flutter_spinkit/flutter_spinkit.dart";

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: Future.delayed(const Duration(seconds: 1)),
      builder: (context, snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.done:
            return Scaffold(
              appBar: AppBar(title: const Text("House Keeper")),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        Navigator.pushNamed(context, "/groceryList");
                      },
                      icon: const Icon(Icons.local_grocery_store),
                      label: const Text("Grocery List"),
                    )
                  ],
                ),
              ),
            );
          default:
            return const Center(child: SpinKitWave(color: Colors.white, size: 75));
        }
      },
    );
  }
}
