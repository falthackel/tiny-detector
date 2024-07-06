import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';

class ApiService {
  static const String baseUrl = 'tinydetector.com';
  static const storage = FlutterSecureStorage();
  static final Logger logger = Logger();

  static Future<Map<String, dynamic>> fetchAssessor(String email) async {
    Uri uri = Uri.https(baseUrl, '/api/users');
    final response = await http.post(
      // Uri.parse('$baseUrl/users'),
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        // 'assessor_name': name,
        'assessor_email': email,
      }),
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      if (responseData.isNotEmpty) {
        return Map<String, dynamic>.from(responseData[0]);
      } else {
        throw Exception('Assessor not found');
      }
    } else {
      throw Exception('Failed to get users');
    }
  }

  static Future<Map<String, dynamic>> createUser(Map<String, dynamic> userData) async {
    Uri uri = Uri.https(baseUrl, '/api/form');
    final response = await http.post(
      // Uri.parse('$baseUrl/form'),
      uri,
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

  static Future<bool> checkToddlerExists(Map<String, dynamic> userData) async {
    Uri uri = Uri.https(baseUrl, '/api/check/toddler');
    final response = await http.post(
      // Uri.parse('$baseUrl/check/toddler'),
      uri,
      body: jsonEncode(userData),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body)['exists'];
    } else {
      throw Exception('Failed to check if user exists');
    }
  }

  static Future<bool> checkAssessorExists(Map<String, dynamic> userData) async {
    Uri uri = Uri.https(baseUrl, '/api/check/assessor');
    final response = await http.post(
      // Uri.parse('$baseUrl/check/assessor'),
      uri,
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
    Uri uri = Uri.https(baseUrl, '/api/questions');
    final response = await http.get(
      // Uri.parse('$baseUrl/questions'),
      uri
      );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load questions');
    }
  }

  static Future<void> saveQuestionAnswer(int userId, int responseId, int questionNumber, int answer) async {
    Uri uri = Uri.https(baseUrl, '/api/form');
    final response = await http.put(
      // Uri.parse('$baseUrl/form'),
      uri,
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
    Uri uri = Uri.https(baseUrl, '/api/submit');
    final response = await http.post(
      // Uri.parse('$baseUrl/submit'),
      uri,
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

  static Future<List<Map<String, dynamic>>> fetchUserAssessments(int responseId) async {
    Uri uri = Uri.https(baseUrl, '/api/unsubmitted');
    final response = await http.post(
      // Uri.parse('$baseUrl/unsubmitted'),
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'assessor_id': responseId,
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user assessments');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchHistoryAssessments(int responseId) async {
    Uri uri = Uri.https(baseUrl, '/api/submitted');
    final response = await http.post(
      // Uri.parse('$baseUrl/submitted'),
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'assessor_id': responseId,
      }),
    );
    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return List<Map<String, dynamic>>.from(data);
    } else {
      throw Exception('Failed to load user assessments');
    }
  }

  static Future<Map<String, dynamic>> fetchUserAssessment(int toddler_id) async {
    Uri uri = Uri.https(baseUrl, '/api/toddler/$toddler_id');
    final response = await http.get(
      // Uri.parse('$baseUrl/toddler/$toddler_id'),
      uri
      );
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

  static Future<Map<String, dynamic>> attemptLogIn(String email, String password) async {
    Uri uri = Uri.https(baseUrl, '/api/login');
    // print('Constructed URI: $uri'); // Print the URI

    return http.post(
      uri,
      // Uri.parse('$baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'assessor_email': email,
        'assessor_password': password,
      }),
    ).then((response) async {

      if (response.statusCode == 200) {
        Map<String, dynamic> responseBody = jsonDecode(response.body);

        try {
          if (responseBody['token'] == null) {
            print('Token is null');
            throw Exception('Token is null');
          }
        } catch (e) {
          throw Exception("token in responseBody unaccessible");
        }
        
        try {
          if (responseBody['role'] == null) {
            print('Role is null');
            throw Exception('Role is null');
          }
        } catch (e) {
          throw Exception("role in responseBody unaccessible");
        }

        String token = responseBody['token'];
        String role = responseBody['role'];
        try {await storage.write(key: 'email', value: email);}
        catch (e, stackTrace) {print("a" + '$e'); print("a $stackTrace"); throw Exception("a");}
        try {await storage.write(key: 'jwt_token', value: token);}
        catch (e, stackTrace) {print("b" + '$e'); print("b $stackTrace"); Exception("b");}
        try {await storage.write(key: 'role', value: role);} // Save the role
        catch (e, stackTrace) {print("c" + '$e'); print("c +$stackTrace"); throw Exception("c");}
        return {'token': token, 'role': role};
      } else {
        print('Failed to login with status code: ${response.statusCode}');
        throw Exception('Failed to login with status code: ${response.statusCode}');
      }
    }).catchError((e) {
      print('Failed to login: $e');
      throw Exception('Failed to login: $e');
    });
  }

  static Future<String?> getToken() async {
    return await storage.read(key: 'jwt_token');
  }

  static Future<Map<String, dynamic>> attemptSignUp(String name, int age, String profession, String email, String password, String role) async {
    Uri uri = Uri.https(baseUrl, '/api/signup');
    final response = await http.post(
      // Uri.parse('$baseUrl/signup'),
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'assessor_name': name,
        'assessor_age': age.toString(),
        'assessor_profession': profession,
        'assessor_email': email,
        'assessor_password': password,
        'role': role,
      }),
    );

    if (response.statusCode == 201) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to sign up');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUnsubmittedAssessments() async {
    Uri uri = Uri.https(baseUrl, '/api/incomplete');
    final response = await http.get(
      // Uri.parse('$baseUrl/incomplete'),
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load unsubmitted assessments: ${response.reasonPhrase}');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchSubmittedAssessments() async {
    Uri uri = Uri.https(baseUrl, '/api/complete');
    final response = await http.get(
      // Uri.parse('$baseUrl/complete'),
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load submitted assessments: ${response.reasonPhrase}');
    }
  }

  static Future<int> fetchAssessmentCount() async {
    Uri uri = Uri.https(baseUrl, '/api/totalAssessments');
    final response = await http.get(
      // Uri.parse('$baseUrl/totalAssessments')
      uri
      );

    if (response.statusCode == 200) {
      return int.parse(jsonDecode(response.body)['count']);
    } else {
      throw Exception('Failed to load assessment count');
    }
  }

  static Future<int> fetchAsdCasesCount() async {
    Uri uri = Uri.https(baseUrl, '/api/totalCases');
    final response = await http.get(
      // Uri.parse('$baseUrl/totalCases')
      uri
      );

    if (response.statusCode == 200) {
      return int.parse(jsonDecode(response.body)['count']);
    } else {
      throw Exception('Failed to load ASD cases count');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchUser() async {
    Uri uri = Uri.https(baseUrl, '/api/assessor');
    final response = await http.get(
      // Uri.parse('$baseUrl/assessor'),
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load assessor: ${response.reasonPhrase}');
    }
  }

  static Future<int> fetchAssessorCount() async {
    Uri uri = Uri.https(baseUrl, '/api/totalAssessors');
    final response = await http.get(
      // Uri.parse('$baseUrl/totalAssessors')
      uri
      );

    if (response.statusCode == 200) {
      return int.parse(jsonDecode(response.body)['count']);
    } else {
      throw Exception('Failed to load ASD cases count');
    }
  }

  static Future<List<Map<String, dynamic>>> fetchAdmin() async {
    Uri uri = Uri.https(baseUrl, '/api/admin');
    final response = await http.get(
      // Uri.parse('$baseUrl/admin'),
      uri,
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load admin: ${response.reasonPhrase}');
    }
  }

  static Future<int> fetchAdminCount() async {
    Uri uri = Uri.https(baseUrl, '/api/totalAdmins');
    final response = await http.get(
      // Uri.parse('$baseUrl/totalAdmins')
      uri
      );

    if (response.statusCode == 200) {
      return int.parse(jsonDecode(response.body)['count']);
    } else {
      throw Exception('Failed to load total admin');
    }
  }

  static Future<Map<String, dynamic>> fetchDeleteAdmin(int assessor_id) async {
    Uri uri = Uri.https(baseUrl, '/api/deleteAdmin/$assessor_id');
    final response = await http.delete(
      // Uri.parse('$baseUrl/deleteAdmin/$assessor_id')
      uri
      );
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
      print('Failed to delete an with status code: ${response.statusCode}');
      throw Exception('Failed to delete an account');
    }
  }
}