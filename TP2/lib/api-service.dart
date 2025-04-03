import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000";

  static Future<List<Map<String, dynamic>>> getShows() async {
    final response = await http.get(Uri.parse('$baseUrl/shows'));
    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception('Failed to load shows');
    }
  }

  static Future<void> addShow(Map<String, dynamic> showData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/shows'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode(showData),
    );
    
    if (response.statusCode != 201) {
      throw Exception('Failed to add show');
    }
  }

  static Future<void> deleteShow(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/shows/$id'),
    );
    
    if (response.statusCode != 200) {
      throw Exception('Failed to delete show');
    }
  }
}