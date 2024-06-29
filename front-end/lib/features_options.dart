import 'package:flutter/material.dart';
import 'assessment_history.dart';
import 'toddler_profile_widget.dart';
import 'faq_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class FeaturesOptions extends StatelessWidget {
  final int userId;

  const FeaturesOptions({super.key, required this.userId});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              color: const Color.fromARGB(255, 1, 204, 209),
              child: IconButton(
                icon: Icon(
                  MdiIcons.textBoxCheckOutline,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ToddlerProfileWidget(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: const Text(
                'Tes Penilaian',
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              color: const Color.fromARGB(255, 1, 204, 209),
              child: IconButton(
                icon: Icon(
                  MdiIcons.clipboardTextClockOutline,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => AssessmentHistory(userId: userId),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: const Text(
                'Riwayat Penilaian',
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              color: const Color.fromARGB(255, 1, 204, 209),
              child: IconButton(
                icon: Icon(
                  MdiIcons.hospitalBuilding,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () {},
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: const Text(
                'Informasi Klinik Terapi',
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
        Column(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              margin: const EdgeInsets.fromLTRB(5, 10, 5, 10),
              color: const Color.fromARGB(255, 1, 204, 209),
              child: IconButton(
                icon: Icon(
                  MdiIcons.frequentlyAskedQuestions,
                  size: 40,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FAQPage(),
                    ),
                  );
                },
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.25,
              child: const Text(
                'FAQ',
                textAlign: TextAlign.center,
                maxLines: 2,
              ),
            ),
          ],
        ),
      ],
    );
  }
}