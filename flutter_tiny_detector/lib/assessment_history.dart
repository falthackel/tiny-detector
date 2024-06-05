import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'low_result.dart';
import 'med_result.dart';
import 'high_result.dart';

class AssessmentHistory extends StatefulWidget {
  const AssessmentHistory({super.key});

  @override
  State<AssessmentHistory> createState() => _AssessmentHistoryState();
}

class _AssessmentHistoryState extends State<AssessmentHistory> {
  List<Map<String, dynamic>> assessments = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final url = 'http://localhost:3000/user-assessments';
    try {
      final response = await http.get(Uri.parse(url));
      print('Response status: ${response.statusCode}');
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('Parsed data: $data');
        if (data is Map<String, dynamic> && data.containsKey('message')) {
          setState(() {
            assessments = List<Map<String, dynamic>>.from(data['message']);
            errorMessage = '';
          });
        } else {
          setState(() {
            errorMessage = 'Unexpected data format';
            assessments = [];
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.statusCode}';
          assessments = [];
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        assessments = [];
      });
    }
  }

  void _navigateToResult(BuildContext context, int result) {
    Widget screen;
    switch (result) {
      case 1:
        screen = const LowResult();
        break;
      case 2:
        screen = const MedResult();
        break;
      case 3:
        screen = const HighResult();
        break;
      default:
        screen = const LowResult(); // Fallback to LowResult if an unexpected result value is encountered
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
      body: SingleChildScrollView(
        child: Container(
          margin: const EdgeInsets.all(15),
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: const Color(0xFFF0EDED),
            borderRadius: BorderRadius.circular(30.0), // Set corner radius to 30
          ),
          child: errorMessage.isNotEmpty
              ? Center(child: Text(errorMessage))
              : ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: assessments.length,
                  itemBuilder: (context, index) {
                    final assessment = assessments[index];
                    return ListTile(
                      title: Text("${assessment['name']} (${assessment['age']} bulan)"),
                      subtitle: Text('${assessment['domicile']}, ${assessment['gender'] == 1 ? 'Laki-laki' : 'Perempuan'}'),
                      trailing: ElevatedButton(
                        onPressed: () => _navigateToResult(context, assessment['results']),
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
                  },
                ),
        ),
      ),
    );
  }
}