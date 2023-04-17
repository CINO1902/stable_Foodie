import "package:http/http.dart" as http;

class networkHandler {
  static final client = http.Client();

  static Uri builderUrl(String endpoint) {
    // String host = "https://faithful-beanie-lamb.cyclic.app/route";
    String host = "https://foodie1902.herokuapp.com/route";
    // String host = "http://192.168.0.135:3000/route";
    final apiPath = host + endpoint;
    return Uri.parse(apiPath);
  }
}
