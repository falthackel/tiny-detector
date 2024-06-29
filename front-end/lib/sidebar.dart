import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tiny_detector/assessment_history.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_tiny_detector/main_page.dart';

class Sidebar extends StatefulWidget {
  final String? name;
  final String? email;
  final Function onLogout;

  const Sidebar({super.key, required this.name, required this.email, required this.onLogout});

  @override
  _SidebarState createState() => _SidebarState();
}

class _SidebarState extends State<Sidebar> {
  final storage = const FlutterSecureStorage();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  Future<void> storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

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
      print('Error retrieving user ID: $e');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          UserAccountsDrawerHeader(
            accountName: Text(widget.name ?? 'Nama tidak ditemukan'),
            accountEmail: Text(widget.email ?? 'Email tidak ditemukan'),
            currentAccountPicture: const CircleAvatar(
              backgroundColor: Colors.white,
              child: Icon(Icons.person, size: 50, color: Colors.orange),
            ),
            decoration: const BoxDecoration(
              color: Colors.orange,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.home),
            title: const Text('Beranda'),
            onTap: () async {
              int? userId = await getUserId();
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(userId: userId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User ID not found.')),
                );
              }
            },
          ),
          ListTile(
            leading: const Icon(Icons.history),
            title: const Text('Riwayat Penilaian'),
            onTap: () async {
              int? userId = await getUserId();
              if (userId != null) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AssessmentHistory(userId: userId),
                  ),
                );
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('User ID not found.')),
                );
              }
            },
          ),
          // ... other ListTile items
          const Divider(),
          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text('Pengaturan'),
            onTap: () {
              Navigator.pop(context);
              // Navigate to Pengaturan
            },
          ),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text('Keluar'),
            onTap: () => widget.onLogout(),
          ),
        ],
      ),
    );
  }
}