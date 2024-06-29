import 'package:flutter/material.dart';
import 'package:flutter_tiny_detector/footer.dart';
import 'features_options.dart';
import 'saved_assessment.dart';
import 'search_widget.dart';

class MainPage extends StatefulWidget {
  final int userId;

  const MainPage({super.key, required this.userId});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 204, 209),
        title: const SizedBox(
          height: 40,
          child: Center(
            child: Image(
              image: AssetImage('assets/tiny-detector-white.png'),
              fit: BoxFit.contain,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 35, color: Colors.white),
          onPressed: () {},
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {},
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SearchWidget(),
          SavedAssessment(userId: widget.userId),
          const Text(
            'Fitur',
            textAlign: TextAlign.left,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
              color: Color.fromARGB(255, 1, 204, 209),
            ),
          ),
          Flexible(
            child: FeaturesOptions(userId: widget.userId),
          ),
          Footer(),
        ],
      ),
    );
  }
}