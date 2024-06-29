import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> questions = [];
  final Map<int, bool> answers = {};
  final Map<String, int> intAnswers = {};

  @override
  void initState() {
    super.initState();
    fetchQuestions();
  }

  Future<void> fetchQuestions() async {
    try {
      List<Map<String, dynamic>> fetchedQuestions = await ApiService.fetchQuestions();
      if (widget.responseId != null) {
        Map<String, dynamic> previousAnswers = await ApiService.fetchUserAssessment(widget.responseId!);
        setState(() {
          questions = fetchedQuestions;
          previousAnswers.forEach((key, value) {
            if (key.startsWith('q') && value != null) {
              int questionNumber = int.parse(key.substring(1));
              answers[questionNumber] = value == 1;
              intAnswers[key] = value;
              if (questionNumber > currentQuestionIndex) {
                currentQuestionIndex = questionNumber;
              }
            }
          });
          currentAnswer = answers[currentQuestionIndex + 1]?.toString();
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

  void handleAnswer(bool answer) async {
    try {
      setState(() {
        currentAnswer = answer.toString();
        answers[currentQuestionIndex + 1] = answer;
        intAnswers['q${currentQuestionIndex + 1}'] = answer ? 1 : 0;

      });

      // Save the answer to the database
      await ApiService.saveQuestionAnswer(
        widget.userId,
        widget.responseId ?? 0,
        currentQuestionIndex + 1,
        answer ? 1 : 0,
      );

      if (currentQuestionIndex < questions.length - 1) {
        setState(() {
          currentQuestionIndex++;
          currentAnswer = answers[currentQuestionIndex + 1]?.toString();
        });
      } else {
        _submitResults();
      }
    } catch (e) {
      print('Failed to save answer: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to save answer: $e')),
      );
    }
  }

  void _submitResults() async {
    try {
      Map<String, dynamic> response = await ApiService.submitAnswers(widget.responseId ?? 0);
      int result = response['result'];
      _navigateToResultPage(result);
    } catch (e) {
      print('Failed to submit results: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to submit results: $e')),
      );
    }
  }

  void _navigateToResultPage(int result) {
    if (result == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LowResult(userId: widget.userId)),
      );
    } else if (result == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MedResult(userId: widget.userId)),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HighResult(userId: widget.userId)),
      );
    }
  }

  void _navigateToNextQuestion() {
    setState(() {
      if (currentQuestionIndex < questions.length - 1) {
        currentQuestionIndex++;
        currentAnswer = answers[currentQuestionIndex + 1]?.toString();
      }
    });
  }

  void _navigateToPreviousQuestion() {
    print(intAnswers);
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
                      'Pertanyaan ${currentQuestionIndex+1}',
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
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(questions[currentQuestionIndex]['imageUrl'] ?? ''),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20.0),
                    Text(
                      questions[currentQuestionIndex]['text'] ?? 'No question text available',
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
                            backgroundColor: intAnswers['q${currentQuestionIndex+1}'] == 1 ? Colors.green : Colors.white,
                          ),
                          onPressed: () {
                            handleAnswer(true);
                          },
                          child: const Text('Ya'),
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: intAnswers['q${currentQuestionIndex+1}'] == 0 ? Colors.red : Colors.white,
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