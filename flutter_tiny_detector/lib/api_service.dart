import 'dart:convert';
import 'package:http/http.dart' as http;
import 'user.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';

  static Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/form'),
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
      Uri.parse('$baseUrl/check'),
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
    final response = await http.put(
      Uri.parse('$baseUrl/form'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': responseId,
        'qid': questionNumber,
        'answer': answer,
      }),
    );
    if (response.statusCode != 200) {
      throw Exception('Failed to save question answer');
    }
  }

  static Future<Map<String, dynamic>> submitAnswers(int responseId) async {
    final response = await http.post(
      Uri.parse('$baseUrl/submit'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'id': responseId,
      }),
    );
    if (response.statusCode == 200) {
      Map<String, dynamic> data = jsonDecode(response.body);
      return Map<String, dynamic>.from(data);
    } else {
      throw Exception('Failed to submit answers');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUserAssessments() async {
    final response = await http.get(Uri.parse('$baseUrl/unsubmitted'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user assessments');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchHistoryAssessments() async {
    final response = await http.get(Uri.parse('$baseUrl/submitted'));
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user assessments');
    }
  }

  static Future<Map<String, dynamic>> fetchUserAssessment(int id) async {
    final response = await http.get(Uri.parse('$baseUrl/toddler/$id'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load user assessment');
    }
  }

  static Future<String> attemptLogIn(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
      }),
    );

    print(email);
    print(password);
    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['token'];
      print(response.body);
      print('Token: $token');
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<String> attemptSignUp(String name, int age, String profession, String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'name': name,
        'age': age.toString(),
        'profession': profession,
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }
}