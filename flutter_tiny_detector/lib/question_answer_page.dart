import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class QuestionAnswerPage extends StatefulWidget {
  const QuestionAnswerPage({super.key});

  @override
  State<QuestionAnswerPage> createState() => _QuestionAnswerPageState();
}

class _QuestionAnswerPageState extends State<QuestionAnswerPage> with RouteAware {
  int currentQuestionIndex = 0;
  String? currentAnswer;
  int totalScore = 0; // Initialize totalScore variable
  final List<String> questions = [
    "Jika Anda menunjuk sesuatu di ruangan, apakah anak Anda melihatnya? (Misalnya, jika Anda menunjuk hewan atau mainan, apakah anak Anda melihat ke arah hewan atau mainan yang Anda tunjuk?)",
    "Pernahkah Anda berpikir bahwa anak Anda tuli?",
    "Apakah anak Anda pernah bermain pura-pura? (Misalnya, berpura-pura minum dari gelas kosong, berpura-pura berbicara menggunakan telepon, atau menyuapi boneka atau boneka binatang?)",
    "Apakah anak Anda suka memanjat benda-benda? (Misalnya, furniture, alat-alat bermain, atau tangga",
    "Apakah anak Anda menggerakkan jari-jari tangannya dengan cara yang tidak biasa di dekat matanya? (Misalnya, apakah anak Anda menggoyangkan jari dekat pada matanya?)",
    "Apakah anak Anda pernah menunjuk dengan satu jari untuk meminta sesuatu atau untuk meminta tolong? (Misalnya, menunjuk makanan atau mainan yang jauh dari jangkauannya)",
    "Apakah anak Anda pernah menunjuk dengan satu jari untuk menunjukkan sesuatu yang menarik pada Anda? (Misalnya, menunjuk pada pesawat di langit atau truk besar di jalan)",
    "Apakah anak Anda tertarik pada anak lain? (Misalnya, apakah anak Anda memperhatikan anak lain, tersenyum pada mereka atau pergi ke arah mereka)",
    "Apakah anak Anda pernah memperlihatkan suatu benda dengan membawa atau mengangkatnya kepada Anda tidak untuk minta tolong, hanya untuk berbagi? (Misalnya, memperlihatkan Anda bunga, binatang atau truk mainan)",
    "Apakah anak Anda memberikan respon jika namanya dipanggil? (Misalnya, apakah anak Anda melihat, bicara atau bergumam, atau menghentikan apa yang sedang dilakukannya saat Anda memanggil namanya)",
    "Saat Anda tersenyum pada anak Anda, apakah anak Anda tersenyum balik?",
    "Apakah anak Anda pernah marah saat mendengar suara bising sehari-hari? (Misalnya, apakah anak Anda berteriak atau menangis saat mendengar suara bising seperti vacuum cleaner atau musik keras)",
    "Apakah anak Anda bisa berjalan?",
    "Apakah anak Anda menatap mata Anda saat Anda bicara padanya, bermain bersamanya, atau saat memakaikan pakaian?",
    "Apakah anak Anda mencoba meniru apa yang Anda lakukan? (Misalnya, melambaikan tangan, tepuk tangan atau meniru saat Anda membuat suara lucu)",
    "Jika Anda memutar kepala untuk melihat sesuatu, apakah anak Anda melihat sekeliling untuk melihat apa yang Anda lihat?",
    "Apakah anak Anda mencoba utuk membuat Anda melihat kepadanya? (Misalnya, apakah anak Anda melihat Anda untuk dipuji atau berkata “lihat” atau “lihat aku”)",
    "Apakah anak Anda mengerti saat Anda memintanya melakukan sesuatu? (Misalnya, jika Anda tidak menunjuk, apakah anak Anda mengerti kalimat “letakkan buku itu di atas kursi” atau “ambilkan saya selimut”)",
    "Jika sesuatu yang baru terjadi, apakah anak Anda menatap wajah Anda untuk melihat perasaan Anda tentang hal tersebut? (Misalnya, jika anak Anda mendengar bunyi aneh atau lucu, atau melihat mainan baru, akankah dia menatap wajah Anda?)",
    "Apakah anak Anda menyukai aktivitas yang bergerak? (Misalnya, diayun-ayun atau dihentak-hentakkan pada lutut Anda)",
  ];
  final List<String> answers = [];

  void handleAnswer(String answer) {
    setState(() {
      currentAnswer = answer;
      answers.add(answer);
      _saveAnswer(currentQuestionIndex, answer);

      if (currentQuestionIndex == 1 && answer == 'Yes') {
        totalScore++;
      } else if (currentQuestionIndex == 4 && answer == 'Yes') {
        totalScore++;
      } else if (currentQuestionIndex == 11 && answer == 'Yes') {
        totalScore++;
      } else if (currentQuestionIndex < 20 && answer == 'No') {
        totalScore++;
      }

      currentQuestionIndex++;

      if (currentQuestionIndex == questions.length) {
        // Navigate to results page
      } else {
        // Load answer for the next question
        _loadAnswer(currentQuestionIndex);
      }
    });
  }

  void _saveAnswer(int index, String answer) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('question_$index', answer);
  }

  void _loadAnswer(int index) async {
    final prefs = await SharedPreferences.getInstance();
    final storedAnswer = prefs.getString('question_$index');
    if (storedAnswer != null) {
      setState(() {
        currentAnswer = storedAnswer;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadAnswer(currentQuestionIndex); // Load initial answer
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Penilaian'),
      ),
      body: Container(
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
                'Simak dan ikuti langkah demi langkah berdasarkan tayangan video dibawah ini.',
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
                    onPressed: () {
                      currentAnswer == null ? handleAnswer('Yes') : null;
                      currentQuestionIndex < 20 ? currentAnswer = null : currentAnswer = currentAnswer;
                    },
                    child: const Text('Yes'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      currentAnswer == null ? handleAnswer('No') : null;
                      currentQuestionIndex < 20 ? currentAnswer = null : currentAnswer = currentAnswer;
                    },
                    child: const Text('No'),
                  ),
                ],
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      if (currentQuestionIndex > 0) {
                        setState(() {
                          currentQuestionIndex--;
                          currentAnswer = answers[currentQuestionIndex];
                          _loadAnswer(currentQuestionIndex);
                        });
                      }
                    },
                    child: const Text('Previous'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      if (currentQuestionIndex < questions.length - 1) {
                        setState(() {
                          currentQuestionIndex++;
                          currentAnswer = answers[currentQuestionIndex];
                          _loadAnswer(currentQuestionIndex);
                        });
                      }
                    },
                    child: const Text('Next'),
                  ),
                ],
              ),
              const SizedBox(height: 20.0),
            ],
          ),
        ),
      ),
    );
  }
}