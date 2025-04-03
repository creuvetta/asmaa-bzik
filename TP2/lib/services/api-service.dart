import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../services/auth_service.dart';

class ApiService {
  static const String baseUrl = "http://10.0.2.2:5000";

  static Future<Map<String, String>> _getHeaders() async {
    final token = await AuthService.getToken();
    return {
      'Content-Type': 'application/json',
      if (token != null) 'Authorization': 'Bearer $token',
    };
  }

  static Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      body: json.encode({'email': email, 'password': password}),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(json.decode(response.body)['error'] ?? 'Login failed');
    }
  }

  static Future<List<Show>> getShows() async {
    final response = await http.get(
      Uri.parse('$baseUrl/shows'),
      headers: await _getHeaders(),
    );

    if (response.statusCode == 200) {
      return (json.decode(response.body) as List)
          .map((data) => Show.fromJson(data))
          .toList();
    } else {
      throw Exception('Failed to load shows');
    }
  }

  static Future<void> addShow(Map<String, dynamic> data, File? image) async {
    var request = http.MultipartRequest('POST', Uri.parse('$baseUrl/shows'));
    request.headers.addAll(await _getHeaders());
    
    request.fields.addAll({
      'title': data['title'],
      'description': data['description'],
      'category': data['category'],
    });

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();
    if (response.statusCode != 201) {
      throw Exception('Failed to add show');
    }
  }

  static Future<void> updateShow(int id, Map<String, dynamic> data, File? image) async {
    var request = http.MultipartRequest('PUT', Uri.parse('$baseUrl/shows/$id'));
    request.headers.addAll(await _getHeaders());
    
    request.fields.addAll({
      'title': data['title'],
      'description': data['description'],
      'category': data['category'],
    });

    if (image != null) {
      request.files.add(await http.MultipartFile.fromPath('image', image.path));
    }

    final response = await request.send();
    if (response.statusCode != 200) {
      throw Exception('Failed to update show');
    }
  }

  static Future<void> deleteShow(int id) async {
    final response = await http.delete(
      Uri.parse('$baseUrl/shows/$id'),
      headers: await _getHeaders(),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to delete show');
    }
  }
}