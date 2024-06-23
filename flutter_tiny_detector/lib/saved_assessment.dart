import 'package:flutter/material.dart';
import 'question_answer_page.dart';
import 'api_service.dart';

class SavedAssessment extends StatefulWidget {
  final int userId;

  const SavedAssessment({super.key, required this.userId});

  @override
  State<SavedAssessment> createState() => _SavedAssessmentState();
}

class _SavedAssessmentState extends State<SavedAssessment> {
  List<Map<String, dynamic>> savedAssessments = [];
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _fetchSavedAssessments();
  }

  Future<void> _fetchSavedAssessments() async {
    try {
      final response = await ApiService.fetchUserAssessment(widget.userId);
      setState(() {
        savedAssessments = List<Map<String, dynamic>>.from(response.values); // Ensure it's a list of maps
        errorMessage = savedAssessments.isEmpty ? 'Tidak ada penilaian yang dapat dilanjutkan' : '';
      });
    } catch (e) {
      setState(() {
        errorMessage = 'Error: $e';
        savedAssessments = [];
      });
    }
  }

  void _continueAssessment(BuildContext context, int responseId) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => QuestionAnswerPage(userId: widget.userId, responseId: responseId),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 161, 50),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(20),
      child: savedAssessments.isEmpty
          ? Center(child: Text(errorMessage.isNotEmpty ? errorMessage : 'No saved assessments'))
          : ListView.builder(
              itemCount: savedAssessments.length,
              itemBuilder: (context, index) {
                final assessment = savedAssessments[index];
                return Padding(
                  padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${assessment['name']}, ${assessment['age']} Bulan',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          _continueAssessment(context, assessment['response_id']);
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                              const Color.fromARGB(255, 1, 204, 209)),
                          padding: MaterialStateProperty.all<EdgeInsets>(
                              const EdgeInsets.fromLTRB(10, 0, 10, 0)),
                        ),
                        child: const Text(
                          'Lanjutkan tes',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}