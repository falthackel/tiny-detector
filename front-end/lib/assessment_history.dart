import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tiny_detector/footer.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'api_service.dart';
import 'low_result.dart';
import 'med_result.dart';
import 'high_result.dart';

class AssessmentHistory extends StatefulWidget {
  final int userId;

  const AssessmentHistory({super.key, required this.userId});

  @override
  _AssessmentHistoryState createState() => _AssessmentHistoryState();
}

class _AssessmentHistoryState extends State<AssessmentHistory> {
  List<Map<String, dynamic>> userAssessments = [];
  String errorMessage = '';
  final storage = const FlutterSecureStorage();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future<int?> getUserId() async {
    try {
      String? token = await storage.read(key: 'jwt_token');
      if (token != null && !isTokenExpired(token)) {
        return JwtDecoder.decode(token)['userId'] as int?;
      }
    } catch (e) {
      print('Error retrieving user ID: $e');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    int? userId = await getUserId();
    if (userId != null) {
      try {
        final data = await ApiService.fetchHistoryAssessments(userId);
        setState(() {
          userAssessments = List<Map<String, dynamic>>.from(data);
          errorMessage = '';
        });
      } catch (e) {
        setState(() {
          errorMessage = 'Error: $e';
          userAssessments = [];
        });
      }
    } else {
      setState(() {
        errorMessage = 'User ID not found.';
      });
    }
  }

  void _navigateToResult(BuildContext context, int userId, dynamic results) {
    if (results == null || results is! int) {
      setState(() {
        errorMessage = 'Invalid results data';
      });
      return;
    }

    Widget screen;
    switch (results) {
      case 1:
        screen = LowResult(userId: userId);
        break;
      case 2:
        screen = MedResult(userId: userId);
        break;
      case 3:
        screen = HighResult(userId: userId);
        break;
      default:
        screen = LowResult(userId: userId); // Fallback to LowResult if an unexpected results value is encountered
    }

    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => screen),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Riwayat Penilaian',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 161, 50),
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color(0xFFF0EDED),
          borderRadius: BorderRadius.circular(30.0), // Set corner radius to 30
        ),
        child: errorMessage.isNotEmpty
            ? Center(child: Text(errorMessage))
            : userAssessments.isEmpty
                ? const Center(child: Text('Tidak ada historis penilaian'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        ...userAssessments.map((toddler) {
                          return ListTile(
                            title: Text("${toddler['toddler_name']} (${toddler['toddler_age']} bulan)"),
                            subtitle: Text('${toddler['toddler_domicile']}, ${toddler['toddler_gender'] == 1 ? 'Laki-laki' : 'Perempuan'}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _navigateToResult(context, toddler['toddler_id'], toddler['result']);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color.fromARGB(255, 255, 161, 50), // Set button color using hex code
                              ),
                              child: const Text(
                                'Lihat Penilaian',
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          );
                        }),
                        const SizedBox(height: 20),
                        Footer(),
                      ],
                    ),
                  ),
      ),
    );
  }
}