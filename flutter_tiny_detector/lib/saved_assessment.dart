import 'package:flutter/material.dart';

class SavedAssessment extends StatefulWidget {
  const SavedAssessment({super.key});

  @override
  State<SavedAssessment> createState() => _SavedAssessmentState();
}

class _SavedAssessmentState extends State<SavedAssessment> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 255, 161, 50),
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(20),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          const Padding(
            padding: EdgeInsets.fromLTRB(0, 6, 0, 6),
            child: Text(
              'Anda masih belum menyelesaikan tes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.white,
                fontSize: 22,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Farrel, 24 Bulan',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton( // Replace Container with TextButton
                  onPressed: () {
                    // Handle button press action here (e.g., navigate to another screen)
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 1, 204, 209)), // Set button background color
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(10, 0, 10, 0)), // Maintain padding
                  ),
                  child: const Text(
                    'Lanjutkan tes',
                    style: TextStyle(
                      color: Colors.white
                    ), // Adjust text color for better contrast
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Benny, 36 Bulan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton( // Replace Container with TextButton
                  onPressed: () {
                    // Handle button press action here (e.g., navigate to another screen)
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 1, 204, 209)), // Set button background color
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(10, 0, 10, 0)), // Maintain padding
                  ),
                  child: const Text(
                    'Lanjutkan tes',
                    style: TextStyle(
                      color: Colors.white
                    ), // Adjust text color for better contrast
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 2, 20, 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Teddy, 12 Bulan',
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                TextButton( // Replace Container with TextButton
                  onPressed: () {
                    // Handle button press action here (e.g., navigate to another screen)
                  },
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        const Color.fromARGB(255, 1, 204, 209)), // Set button background color
                    padding: MaterialStateProperty.all<EdgeInsets>(
                        const EdgeInsets.fromLTRB(10, 0, 10, 0)), // Maintain padding
                  ),
                  child: const Text(
                    'Lanjutkan tes',
                    style: TextStyle(
                      color: Colors.white
                    ), // Adjust text color for better contrast
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}