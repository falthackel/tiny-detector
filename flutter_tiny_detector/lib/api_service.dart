import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  static const storage = FlutterSecureStorage();

  static Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/form'),
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      print('Response status: ${response.statusCode}');  // Add debug output
      print('Response body: ${response.body}');          // Add debug output
      throw Exception('Failed to create user');
    }
  }

  static Future<bool> checkUserExists(Map<String, dynamic> userData) async {
    final response = await http.post(
      Uri.parse('$baseUrl/checkToddler'),
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
        'toddler_id': responseId,
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
        'toddler_id': responseId,
      }),
    );
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Submit answers response: $data');
        return data;
      } catch (e) {
        print('Failed to decode JSON: $e');
        print('Response body: ${response.body}');
        throw Exception('Failed to decode JSON');
      }
    } else {
      print('Failed to submit answers with status code: ${response.statusCode}');
      print('Response body: ${response.body}');
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

  static Future<Map<String, dynamic>> fetchUserAssessment(int toddler_id) async {
    final response = await http.get(Uri.parse('$baseUrl/toddler/$toddler_id'));
    if (response.statusCode == 200) {
      try {
        final Map<String, dynamic> data = jsonDecode(response.body);
        print('Fetched user assessment: $data');
        return data;
      } catch (e) {
        print('Failed to decode JSON: $e');
        print('Response body: ${response.body}');
        throw Exception('Failed to decode JSON');
      }
    } else {
      print('Failed to load user assessment with status code: ${response.statusCode}');
      throw Exception('Failed to load user assessment');
    }
  }

  static Future<String> attemptLogIn(String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'assessor_email': email,
        'assessor_password': password,
      }),
    );

    if (response.statusCode == 200) {
      String token = jsonDecode(response.body)['token'];
      await storage.write(key: 'jwt_token', value: token);
      return token;
    } else {
      throw Exception('Failed to login');
    }
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  static Future<Map<String, dynamic>> attemptSignUp(String name, int age, String profession, String email, String password) async {
    final response = await http.post(Uri.parse('$baseUrl/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'assessor_name': name,
        'assessor_age': age.toString(),
        'assessor_profession': profession,
        'assessor_email': email,
        'assessor_password': password,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }
}