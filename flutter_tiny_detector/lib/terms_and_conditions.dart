import 'package:flutter/material.dart';
import 'question_answer_page.dart';

class TermsAndCondition extends StatefulWidget {
  final int userId;
  final int? responseId;

  const TermsAndCondition({Key? key, required this.userId, this.responseId}) : super(key: key);

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  bool isRead = false;

  void toggleRead() => setState(() => isRead = !isRead);

  void _showSnackbar(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Anda harus menyetujui ketentuan dan syarat untuk melanjutkan')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Ketentuan dan Syarat',
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
          padding: const EdgeInsets.all(30),
          color: const Color.fromARGB(255, 255, 161, 50),
          child: Container(
            padding: const EdgeInsets.all(30),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Penilaian yang akan dilakukan adalah penilaian untuk screening ASD pada balita. Hasil penilaian tidak menggantikan penilaian diagnosis formal. Oleh karena itu, sangat disarankan untuk melanjutkan penilaian diagnosis formal untuk mendapatkan penilaian sebenarnya.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Terdapat 20 pertanyaan yang perlu dijawab dengan respons "ya" atau "tidak". Setiap respons wajib dipilih berdasarkan kriteria tertentu yang akan disajikan dalam video.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Jika Anda baru pertama kali atau masih awam dengan pertanyaan-pertanyaan yang ada, silahkan menonton video untuk membantu memberikan penilaian.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Ketika penilaian berlangsung, diharapkan asesor dapat mempraktikkan secara langsung peristiwa yang terdapat di video agar penilaian dapat dilakukan seakurat mungkin.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 25),
                const Text(
                  'Apakah anda telah membaca dan menyetujui ketentuan dan syarat diatas?',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color.fromARGB(255, 255, 161, 50),
                  ),
                  textAlign: TextAlign.justify,
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    value: isRead,
                    onChanged: (bool? value) {
                      setState(() {
                        isRead = value!;
                      });
                    },
                    subtitle: const Text(
                      "Ya, saya telah membaca dan menelaah maksud dari ketentuan dan syarat diatas dan menyetujui secara penuh proses penilaian tersebut.",
                    ),
                    isThreeLine: true,
                  ),
                ),
                const SizedBox(height: 35),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextButton(
                      onPressed: () {
                        if (isRead) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => QuestionAnswerPage(
                                userId: widget.userId,
                                responseId: widget.responseId,
                              ),
                            ),
                          );
                        } else {
                          _showSnackbar(context);
                        }
                      },
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            const Color.fromARGB(255, 116, 91, 248)),
                        padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(10, 0, 10, 0)),
                      ),
                      child: const Text(
                        'Lanjutkan',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}