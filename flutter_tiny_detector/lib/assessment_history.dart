import 'package:flutter/material.dart';

class AssessmentHistory extends StatefulWidget {
  const AssessmentHistory({super.key});

  @override
  State<AssessmentHistory> createState() => _AssessmentHistoryState();
}

class _AssessmentHistoryState extends State<AssessmentHistory> {
  final List<Map<String, String>> assessments = [
    {
      'name': 'Odela',
      'age': '24 Bulan',
      'location': 'Bandung',
      'gender': 'Laki-laki',
    },
    {
      'name': 'Ayu',
      'age': '36 Bulan',
      'location': 'Bandung',
      'gender': 'Perempuan',
    },
    {
      'name': 'Agus',
      'age': '48 Bulan',
      'location': 'Bandung',
      'gender': 'Laki-laki',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 119,
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
          child: ListView.builder(
            itemCount: assessments.length,
            itemBuilder: (context, index) {
              final assessment = assessments[index];
              return ListTile(
                title: Text("${assessment['name']} (${assessment['age']})"),
                subtitle: Text(assessment['location']! + ', ' + assessment['gender']!),
                trailing: ElevatedButton(
                    onPressed: () {},
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