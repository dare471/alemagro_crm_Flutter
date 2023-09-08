import 'dart:convert';
import 'package:http/http.dart' as http;

class YourApiClient {
  final String baseUrl;

  YourApiClient({required this.baseUrl});

  Future<List<dynamic>> fetchContracts() async {
    final response =
        await http.get(Uri.parse('https://crm.alemagro.com:8080/api/client'));

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load contracts');
    }
  }

  // Добавьте другие методы для других API-запросов
}
