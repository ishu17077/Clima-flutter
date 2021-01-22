import 'dart:convert';
import 'package:http/http.dart' as http;

class NetworkHelper {
  final String url;
  NetworkHelper(this.url);
  Future geData() async {
    http.Response response = await http.get(url);
    if (response.statusCode == 200) {
      print(response.body);
      var jsonData = jsonDecode(response.body);
      return jsonData;
    } else {
      print(response.statusCode);
    }
  }
}
