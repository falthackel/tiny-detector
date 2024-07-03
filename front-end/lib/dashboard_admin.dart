import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tiny_detector/dashboard_drawer.dart';
import 'package:flutter_tiny_detector/footer.dart';
import 'package:flutter_tiny_detector/login_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
// import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'api_service.dart';

class DashboardAdminPage extends StatefulWidget {
  final int userId;

  const DashboardAdminPage({super.key, required this.userId});

  @override
  State<DashboardAdminPage> createState() => _DashboardAdminPageState();
}

class _DashboardAdminPageState extends State<DashboardAdminPage> {
  List<Map<String, dynamic>> assessorList = [];
  bool showIncomplete = true;
  bool isLoading = true;
  int adminCount = 0;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController deleteAdminIdController = TextEditingController();
  final storage = const FlutterSecureStorage();
  int? userId;

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future<int?> getUserId() async {
    try {
      String? token = await storage.read(key: 'jwt_token');
      if (token != null && !isTokenExpired(token)) {
        return JwtDecoder.decode(token)['userId'] as int?;
      }
    } catch (e) {
      print('Gagal mendapatkan user ID: $e');
    }
    return null;
  }

  @override
  void initState() {
    super.initState();
    fetchAdminCount();
    fetchAdmins();
  }

  Future<void> fetchAdminCount() async {
    try {
      final count = await ApiService.fetchAdminCount();
      setState(() {
        adminCount = count;
        isLoading = false;
      });
    } catch (e) {
      print('Error fetching admin count: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchAdmins() async {
    setState(() {
      isLoading = true;
    });

    try {
      assessorList = await ApiService.fetchAdmin();
    } catch (e) {
      print('Error fetching assessors: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addAdmin() async {
    String name = nameController.text;
    int age = int.tryParse(ageController.text) ?? 0;
    String profession = professionController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try {
      final response = await ApiService.attemptSignUp(name, age, profession, email, password, 'Admin');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin added successfully: ${response['assessor_name']}')),
      );
      fetchAdminCount(); // Update admin count after adding a new admin
      int? userId = await getUserId();
      if (userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardAdminPage(userId: userId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID tidak ditemukan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to add admin: $e')),
      );
    }
  }

  Future<void> deleteAdmin() async {
    int adminId = int.tryParse(deleteAdminIdController.text) ?? 0;
    print(adminId);

    try {
      final response = await ApiService.fetchDeleteAdmin(adminId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Admin deleted successfully: $response')),
      );
      fetchAdminCount(); // Update admin count after deleting an admin
      int? userId = await getUserId();
      if (userId != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DashboardAdminPage(userId: userId),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User ID tidak ditemukan.')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete admin: $e')),
      );
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
              const Text('Dashboard Admin', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              const SizedBox(height: 20),
              _buildSummaryCards(),
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
        Expanded(
          child: Column(
            children: [
              _buildSummaryCard('Jumlah Admin', isLoading ? 'Loading...' : '$adminCount', Icons.people),
              const SizedBox(height: 20),
              _buildAddAdminCard(),
              const SizedBox(height: 20),
              _buildDeleteAdminCard(),
              const SizedBox(height: 20),
              _buildDatabaseDisplay(),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon) {
    return Card(
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
    );
  }

  Widget _buildAddAdminCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Add New Admin', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Name'),
            ),
            TextField(
              controller: ageController,
              decoration: const InputDecoration(labelText: 'Age'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: professionController,
              decoration: const InputDecoration(labelText: 'Profession'),
            ),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: passwordController,
              decoration: const InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: addAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 161, 50),
                foregroundColor: Colors.white,
              ),
              
              child: const Text('Add Admin'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteAdminCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Delete Admin', style: TextStyle(fontSize: 16)),
            const SizedBox(height: 8),
            TextField(
              controller: deleteAdminIdController,
              decoration: const InputDecoration(labelText: 'Admin ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: deleteAdmin,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 255, 161, 50),
                foregroundColor: Colors.white,
              ),
              child: const Text('Delete Admin'),
            ),
          ],
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
              'Daftar Admin', 
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