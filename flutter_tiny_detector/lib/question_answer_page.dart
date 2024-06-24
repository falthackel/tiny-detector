import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'api_service.dart';
import 'main_page.dart';
import 'low_result.dart';
import 'med_result.dart';
import 'high_result.dart';

class QuestionAnswerPage extends StatefulWidget {
  final int userId;
  final int? responseId;

  const QuestionAnswerPage({Key? key, required this.userId, this.responseId}) : super(key: key);

  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> {
  int currentQuestionIndex = 0;
  String? currentAnswer;
  int totalScore = 0;
  List<String> questions = [];
  final Map<int, bool> answers = {};

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      List<String> fetchedQuestions = await ApiService.fetchQuestions();
      if (widget.responseId != null) {
        Map<int, bool> previousAnswers = await ApiService.fetchUserAssessment(widget.responseId!);
        setState(() {
          questions = fetchedQuestions;
          answers.addAll(previousAnswers);
          totalScore = answers.values.where((value) => value).length;
          currentAnswer = answers[currentQuestionIndex]?.toString();
        });
      } else {
        setState(() {
          questions = fetchedQuestions;
        });
      }
    } catch (e) {
      print('Failed to fetch questions: $e');
    }
  }

  void handleAnswer(bool answer) {
    setState(() {
      currentAnswer = answer.toString();
      answers[currentQuestionIndex] = answer;
      _saveAnswer(currentQuestionIndex, answer.toString());

      if ([1, 4, 11].contains(currentQuestionIndex) && answer) {
        totalScore++;
      } else if (currentQuestionIndex < 20 && !answer) {
        totalScore++;
      }

      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        currentAnswer = answers[currentQuestionIndex]?.toString();
      } else {
        _submitResults();
      }
    });
  }

  void _submitResults() async {
    try {
      Map<String, bool> jsonFriendlyAnswers = answers.map((key, value) => MapEntry(key.toString(), value));

      if (widget.responseId != null) {
        await ApiService.updateAssessment(widget.responseId!, jsonFriendlyAnswers);
      } else {
        await ApiService.submitAnswers(widget.userId, jsonFriendlyAnswers);
      }
      _navigateToResultPage();
    } catch (e) {
      print('Failed to submit results: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit results: $e')),
      );
    }
  }

  void _navigateToResultPage() {
    if (totalScore < 3) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LowResult(userId: widget.userId)),
      );
    } else if (totalScore >= 3 && totalScore <= 7) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MedResult(userId: widget.userId)),
      );
    } else if (totalScore >= 8) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HighResult(userId: widget.userId)),
      );
    }
  }

  void _saveAnswer(int index, String? answer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('question_$index', answer ?? '');
    await prefs.setInt('currentQuestionIndex', currentQuestionIndex);
  }

  void _navigateToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        currentAnswer = answers[currentQuestionIndex]?.toString();
      }
    });
  }

  void _navigateToPreviousQuestion() {
    setState(() {
      if (currentQuestionIndex > 0) {
        currentQuestionIndex--;
        currentAnswer = answers[currentQuestionIndex]?.toString();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            _saveAnswer(currentQuestionIndex, currentAnswer);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainPage(userId: widget.userId)),
            );
          },
        ),
      ),
      body: questions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Container(
              color: const Color.fromARGB(255, 255, 161, 50),
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  children: [
                    Text(
                      'Pertanyaan ${currentQuestionIndex + 1}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        fontSize: 40,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    const Text(
                      'Simak dan ikuti langkah demi langkah berdasarkan tayangan video di bawah ini.',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Container(
                      height: 150,
                    ),
                    Text(
                      questions[currentQuestionIndex],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentAnswer == 'true' ? Colors.green : Colors.white,
                          ),
                          onPressed: () {
                            handleAnswer(true);
                          },
                          child: const Text('Ya'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: currentAnswer == 'false' ? Colors.red : Colors.white,
                          ),
                          onPressed: () {
                            handleAnswer(false);
                          },
                          child: const Text('Tidak'),
                        ),
                      ],
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ElevatedButton(
                          onPressed: _navigateToPreviousQuestion,
                          child: const Text('Previous'),
                        ),
                        ElevatedButton(
                          onPressed: _navigateToNextQuestion,
                          child: const Text('Next'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}