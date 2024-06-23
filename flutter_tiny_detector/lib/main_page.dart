import 'package:flutter/material.dart';
import 'features_options.dart';
import 'saved_assessment.dart';
import 'search_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MainPage extends StatefulWidget {
  final int userId;

  const MainPage({super.key, required this.userId});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  String _apiMessage = 'Loading...';

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    try {
      final response = await http.get(Uri.parse('http://localhost:3000/users'));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _apiMessage = data['message'] ?? 'Data loaded successfully';
        });
      } else {
        setState(() {
          _apiMessage = 'Failed to load data';
        });
      }
    } catch (e) {
      setState(() {
        _apiMessage = 'Error: $e';
      });
    }
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
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              _apiMessage,
              style: const TextStyle(fontSize: 18),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: MainPage(userId: 1), // Pass a default userId for now
  ));
}