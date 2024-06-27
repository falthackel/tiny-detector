import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users'),
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to create user');
    }
  }

  static Future<bool> checkUserExists(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/users/check'),
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['exists'];
    } else {
      throw Exception('Failed to check if user exists');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchQuestions() async {
    final response = await http.get(Uri.parse('$baseUrl/questions'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<void> saveQuestionAnswer(int userId, int responseId, int questionNumber, int answer) async {
    final response = await http.post(
      Uri.parse('$baseUrl/assessments'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userId,
        'responseId': responseId,
        'questionNumber': questionNumber,
        'answer': answer,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save question answer');
    }
  }

  static Future<void> submitAnswers(int userId, int responseId, Map<String, int> answers, int totalScore, int results) async {
    final response = await http.post(
      Uri.parse('$baseUrl/assessments/submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': userId,
        'responseId': responseId,
        'answers': answers,
        'total_score': totalScore,
        'results': results,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to submit answers');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUserAssessments() async {
    final response = await http.get(Uri.parse('$baseUrl/user-assessments'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user assessments');
    }
  }

  static Future<Map<String, dynamic>> fetchUserAssessment(int responseId) async {
    final response = await http.get(Uri.parse('$baseUrl/assessments/$responseId'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user assessment');
    }
  }

  static Future<List<User>> fetchUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/users'));

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map<User>((json) => User.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load users');
    }
  }
}