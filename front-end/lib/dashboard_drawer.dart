import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tiny_detector/dashboard_admin.dart';
import 'package:flutter_tiny_detector/dashboard_assessor_page.dart';
import 'package:flutter_tiny_detector/dashboard_page.dart';
import 'package:flutter_tiny_detector/login_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class DashboardDrawer extends StatefulWidget {
  final Function onLogout;

  const DashboardDrawer({super.key, required this.onLogout});

  @override
  _DashboardDrawerState createState() => _DashboardDrawerState();
}

class _DashboardDrawerState extends State<DashboardDrawer> {
  final storage = const FlutterSecureStorage();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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

  Future<void> _logout() async {
    await storage.delete(key: 'jwt_token');
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          DrawerHeader(
            child: Column(
              children: [
                Image.asset(
                  'assets/tiny-detector-colored.png', // Replace with your image URL
                  height: 100,
                  width: 100,
                ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Dashboard Balita'),
            onTap: () async {
              int? userId = await getUserId();
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardPage(userId: userId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User ID tidak ditemukan.')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Dashboard Penilai'),
            onTap: () async {
              int? userId = await getUserId();
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DashboardAssessorPage(userId: userId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User ID tidak ditemukan.')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.table_chart_outlined),
            title: const Text('Dashboard Admin'),
            onTap: () async {
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
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Keluar'),
            onTap: _logout,
          ),
          // Add more menu items...
        ],
      ),
    );
  }
}