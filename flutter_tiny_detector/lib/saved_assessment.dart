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
      final data = await ApiService.fetchUserAssessments();
      final userAssessments = data;
      if (userAssessments.isNotEmpty) {
        setState(() {
          savedAssessments = List<Map<String, dynamic>>.from(userAssessments);
          errorMessage = savedAssessments.isEmpty ? 'Tidak ada penilaian yang dapat dilanjutkan' : '';
        });
      } else {
        setState(() {
          errorMessage = 'Tidak ada penilaian yang dapat dilanjutkan';
          savedAssessments = [];
        });
      }
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
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(20),
      child: savedAssessments.isEmpty
          ? Center(
              child: Text(
                errorMessage.isNotEmpty ? errorMessage : 'Tidak ada penilaian yang dapat dilanjutkan. Silakan membuat penilaian baru',

                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Anda masih belum menyelesaikan tes.',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 20),
                Flexible(
                  child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: savedAssessments.length,
                    itemBuilder: (context, index) {
                      final assessment = savedAssessments[index];
                      return Padding(
                        padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '${assessment['toddler_name']}, ${assessment['toddler_age']} Bulan',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                _continueAssessment(context, assessment['toddler_id']);
                              },
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(
                                  const Color.fromARGB(255, 1, 204, 209),
                                ),
                                padding: MaterialStateProperty.all<EdgeInsets>(
                                  const EdgeInsets.fromLTRB(10, 5, 10, 5),
                                ),
                                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              child: const Text(
                                'Lanjutkan Tes',
                                style: TextStyle(color: Colors.white),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}