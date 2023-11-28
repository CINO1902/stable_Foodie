import "package:http/http.dart" as http;

class networkHandler {
  static final client = http.Client();

  static Uri builderUrl(String endpoint) {
    String host = "https://foodie-s6d2.onrender.com/route";
    // String host = "https://foodie1902.herokuapp.com/route";
    // String host = "http://172.20.10.4:3000/route";
    final apiPath = host + endpoint;
    return Uri.parse(apiPath);
  }
}
