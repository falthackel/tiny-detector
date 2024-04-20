import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tiny_detector/features_options.dart';
import 'package:flutter_tiny_detector/saved_assessment.dart';
import 'package:flutter_tiny_detector/search_widget.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 119,
        backgroundColor: const Color.fromARGB(255, 1, 204, 209),
        title: const SizedBox(
          height: 40,
          child: Center(
            child: Image(
              image: AssetImage(
                'assets/tiny-detector-white.png'), // Replace with your image path
                fit: BoxFit.contain, // Adjust image fitting if needed
            ),
          ),
        ),
        // Leading for sidebar menu
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 35, color: Colors.white,), // Sidebar menu icon
          onPressed: () {
            // Handle sidebar menu button press
          },
        ),
        // Row for search bar and profile icon
        actions: [
          Container(
            margin: const EdgeInsets.all(5), // Adjust margin for aesthetics
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.person), // Profile icon
              onPressed: () {
                  // Handle profile button press (navigate to profile page, etc.)
              },
            ),
          ),
        ],
      ),
      body: const Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SearchWidget(),
            SavedAssessment(),
            Text(
              'Fitur', 
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 22,
                color:Color.fromARGB(255, 1, 204, 209),
                ),
              ),
            Flexible(
              child: FeaturesOptions(),
            ),
          ],
        ),
      );
  }
}
