import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../core/constants.dart';
import '../models/analysis_model.dart';

class ApiService {
  final String baseUrl;
  final _storage = const FlutterSecureStorage();

  ApiService({this.baseUrl = AppConstants.baseUrl});

  Future<AnalysisModel> analyzePitch(String pitchText) async {
    final url = Uri.parse('$baseUrl${AppConstants.analyzeEndpoint}');
    final token = await _storage.read(key: 'jwt_token');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          if (token != null) 'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'pitch_text': pitchText}),
      ).timeout(const Duration(seconds: 30));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        return AnalysisModel.fromJson(data);
      } else {
        throw Exception('Server Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is http.ClientException) {
        throw Exception('Network Error: Please check your connection.');
      }
      rethrow;
    }
  }

  Future<AnalysisModel> getAnalysisById(String id) async {
    final url = Uri.parse('$baseUrl/analysis/$id');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return AnalysisModel.fromJson(jsonDecode(response.body));
      } else {
        throw Exception('Failed to fetch analysis: ${response.statusCode}');
      }
    } catch (e) {
      rethrow;
    }
  }
}
