import 'package:flutter/material.dart';
import 'package:flutter_tiny_detector/footer.dart';
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

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final data = await ApiService.fetchHistoryAssessments();
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
                ? Center(child: Text('Loading...'))
                : SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: userAssessments.map((assessment) {
                          return ListTile(
                            title: Text("${assessment['name']} (${assessment['age']} bulan)"),
                            subtitle: Text('${assessment['domicile']}, ${assessment['gender'] == 1 ? 'Laki-laki' : 'Perempuan'}'),
                            trailing: ElevatedButton(
                              onPressed: () {
                                _navigateToResult(context, assessment['id'], assessment['result']);
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
                      }).toList(),
                    ),
                  ),
      ),
    );
  }
}