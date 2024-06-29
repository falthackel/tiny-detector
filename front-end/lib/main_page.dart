import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tiny_detector/api_service.dart';
import 'package:flutter_tiny_detector/custom_appbar.dart';
import 'package:flutter_tiny_detector/sidebar.dart';
import 'footer.dart';
import 'features_options.dart';
import 'saved_assessment.dart';
import 'search_widget.dart';
import 'login_page.dart';

class MainPage extends StatefulWidget {
  final int userId;

  const MainPage({super.key, required this.userId});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final storage = const FlutterSecureStorage();
  String? name;
  String? email;

  Future<void> _logout() async {
    await storage.delete(key: 'jwt_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  Future<void> fetchAssessor() async {
    try {
      String? storedEmail = await storage.read(key: 'email');

      if (storedEmail != null) {
        Map<String, dynamic> assessor = await ApiService.fetchAssessor(storedEmail);
        print(assessor);

        setState(() {
          name = assessor['assessor_name'] as String?;
          email = assessor['assessor_email'] as String?;
        });
      } else {
        print('No email found in storage');
      }
    } catch (e) {
      print('Failed to fetch assessor: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchAssessor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Tiny Detector', // Replace with your desired title
        backgroundColor: Color.fromARGB(255, 1, 204, 209),
      ),
      drawer: Sidebar(
        name: name,
        email: email,
        onLogout: _logout,
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