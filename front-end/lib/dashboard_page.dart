import 'package:flutter/material.dart';
import 'package:flutter_tiny_detector/dashboard_drawer.dart';
import 'package:flutter_tiny_detector/footer.dart';
import 'package:flutter_tiny_detector/login_page.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'api_service.dart';

class DashboardPage extends StatefulWidget {
  final int userId;

  const DashboardPage({super.key, required this.userId});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Map<String, dynamic>> unsubmittedAssessments = [];
  List<Map<String, dynamic>> submittedAssessments = [];
  bool showUnsubmitted = true;
  int assessmentCount = 0;
  int asdCasesCount = 0;
  bool isLoading = true;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchAssessments();
  }

  Future<void> fetchData() async {
    try {
      int assessmentCount = await ApiService.fetchAssessmentCount();
      int asdCasesCount = await ApiService.fetchAsdCasesCount();
      setState(() {
        this.assessmentCount = assessmentCount;
        this.asdCasesCount = asdCasesCount;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAssessments() async {
    setState(() {
      isLoading = true;
    });

    try {
      unsubmittedAssessments = await ApiService.fetchUnsubmittedAssessments();
      submittedAssessments = await ApiService.fetchSubmittedAssessments();
    } catch (e) {
      print('Error fetching assessments: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _logout() async {
    await storage.delete(key: 'jwt_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tiny Detector'),
      ),
      drawer: DashboardDrawer(onLogout: _logout),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text('Dashboard Balita', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildSummaryCards(),
              const SizedBox(height: 20),
              _buildDatabaseDisplay(),
              const SizedBox(height: 20),
              Footer()
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCards() {
    return Row(
      children: [
        _buildSummaryCard('Jumlah Penilaian', isLoading ? 'Loading...' : '$assessmentCount', MdiIcons.textBoxCheckOutline),
        _buildSummaryCard('Jumlah Kasus ASD', isLoading ? 'Loading...' : '$asdCasesCount', Icons.people),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 8),
              Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
              Icon(icon),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDatabaseDisplay() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Penilaian Balita', 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showUnsubmitted = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: showUnsubmitted ? const Color.fromARGB(255, 255, 161, 50) : Colors.grey[300],
                    foregroundColor: showUnsubmitted ? Colors.white : Colors.black,
                  ),
                  child: const Text('Incomplete Assessments'),
                ),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showUnsubmitted = false;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: !showUnsubmitted ? const Color.fromARGB(255, 255, 161, 50) : Colors.grey[300],
                    foregroundColor: !showUnsubmitted ? Colors.white : Colors.black,
                  ),
                  child: const Text('Complete Assessments'),
                ),
              ],
            ),
            const SizedBox(height: 20),
            isLoading
                ? const Center(child: CircularProgressIndicator())
                : SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  columns: const [
                    DataColumn(label: Text('ID')),
                    DataColumn(label: Text('Nama')),
                    DataColumn(label: Text('Domisili')),
                    DataColumn(label: Text('Gender')),
                    DataColumn(label: Text('Usia')),
                    DataColumn(label: Text('Waktu Dibuat')),
                    DataColumn(label: Text('Waktu Diupdate')),
                    DataColumn(label: Text('Hasil')),
                  ],
                  rows: (showUnsubmitted ? unsubmittedAssessments : submittedAssessments)
                      .map((assessment) => DataRow(cells: [
                            DataCell(Text(assessment['toddler_id'].toString())),
                            DataCell(Text(assessment['toddler_name']?.toString() ?? '')),
                            DataCell(Text(assessment['toddler_domicile']?.toString() ?? '')),
                            DataCell(Text(assessment['toddler_gender'].toString())),
                            DataCell(Text(assessment['toddler_age'].toString())),
                            DataCell(Text(assessment['created_at']?.toString() ?? '')),
                            DataCell(Text(assessment['updated_at']?.toString() ?? '')),
                            DataCell(Text(assessment['result']?.toString() ?? '')),
                          ]))
                      .toList(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}