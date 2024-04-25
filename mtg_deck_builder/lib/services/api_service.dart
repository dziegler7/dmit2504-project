import 'package:http/http.dart' as http;
import 'dart:convert';

class MTGApiService {
  final String baseUrl = "https://api.magicthegathering.io/v1/cards";

  Future<List<dynamic>> fetchCards(String query) async {
    final response = await http.get(Uri.parse('$baseUrl?name=$query'));

    if (response.statusCode == 200) {
      return json.decode(response.body)['cards'];
    } else {
      throw Exception('Failed to load cards');
    }
  }
}
