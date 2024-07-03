import 'package:flutter/material.dart';
import 'package:flutter_tiny_detector/dashboard_drawer.dart';
import 'package:flutter_tiny_detector/footer.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tiny_detector/login_page.dart';
import 'api_service.dart';

class DashboardAssessorPage extends StatefulWidget {
  final int userId;

  const DashboardAssessorPage({super.key, required this.userId});

  @override
  State<DashboardAssessorPage> createState() => _DashboardAssessorPageState();
}

class _DashboardAssessorPageState extends State<DashboardAssessorPage> {
  List<Map<String, dynamic>> assessorList = [];
  bool showIncomplete = true;
  int assessorCount = 0;
  bool isLoading = true;
  final storage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    fetchData();
    fetchAssessors();
  }

  Future<void> fetchData() async {
    try {
      int count = await ApiService.fetchAssessorCount();
      setState(() {
        assessorCount = count;
        isLoading = false;
      });
    } catch (e) {
      print('Failed to fetch data: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAssessors() async {
    setState(() {
      isLoading = true;
    });

    try {
      assessorList = await ApiService.fetchUser();
    } catch (e) {
      print('Error fetching assessors: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  List<Map<String, dynamic>> get filteredAssessors {
    return assessorList.where((assessor) {
      bool hasCompletedAssessment = assessor['has_completed_assessment'] ?? false;
      return showIncomplete ? !hasCompletedAssessment : hasCompletedAssessment;
    }).toList();
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
              const Text('Dashboard Penilai', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
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
        _buildSummaryCard('Jumlah Penilai', isLoading ? 'Loading...' : '$assessorCount', Icons.people),
        // _buildSummaryCard('Jumlah Kasus ASD', isLoading ? 'Loading...' : '$asdCasesCount', Icons.people),
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
              'Daftar Penilai', 
              style: TextStyle(
                fontSize: 18, 
                fontWeight: FontWeight.bold
              )
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
                        DataColumn(label: Text('Usia')),
                        DataColumn(label: Text('Profesi')),
                        DataColumn(label: Text('Email'))
                      ],
                      rows: filteredAssessors
                          .map((assessor) => DataRow(cells: [
                                DataCell(Text(assessor['assessor_id'].toString())),
                                DataCell(Text(assessor['assessor_name']?.toString() ?? '')),
                                DataCell(Text(assessor['assessor_age']?.toString() ?? '')),
                                DataCell(Text(assessor['assessor_profession'].toString())),
                                DataCell(Text(assessor['assessor_email'].toString()))                                
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