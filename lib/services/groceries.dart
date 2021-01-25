import "package:http/http.dart";
import "dart:convert";

class Groceries {
  String store;
  List list;

  Groceries({this.store});

  Future<void> getList() async {
    try {
      Response response =
          await get("http://192.168.1.205:5000/api/groceries/$store");

      Map json = jsonDecode(response.body);

      if (response.statusCode == 404) throw json["message"];

      list = json["data"];
    } catch (err) {
      print("error $err");
      list = ["error"];
    }
  }
}
