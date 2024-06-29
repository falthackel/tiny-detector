import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tiny_detector/api_service.dart';
import 'package:flutter_tiny_detector/custom_appbar.dart';
import 'package:flutter_tiny_detector/login_page.dart';
import 'package:flutter_tiny_detector/sidebar.dart';
import 'package:flutter_tiny_detector/main_page.dart';

class MedResult extends StatefulWidget {
  final int userId;

  const MedResult({super.key, required this.userId});

  @override
  State<MedResult> createState() => _MedResultState();
}

class _MedResultState extends State<MedResult> {
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
      // Retrieve the saved email from storage
      String? storedEmail = await storage.read(key: 'email');

      if (storedEmail != null) {
        Map<String, dynamic> assessor = await ApiService.fetchAssessor(storedEmail);
        print(assessor);

        // Access assessor_name and assessor_email from the response
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
    // Example call to fetch assessor data
    fetchAssessor(); // Replace with actual values
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
        onLogout: _logout
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 254, 193, 69),
          borderRadius: BorderRadius.circular(30.0),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Hasil:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Indikasi Sedang',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Berdasarkan jawaban Anda, indikasi autisme pada anak tergolong rendah.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Anda akan menerima email rincian hasil yang berisi jawaban Anda untuk setiap pertanyaan penilaian.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Perlu diingat, autisme adalah kondisi perkembangan yang gejalanya bisa muncul seiring pertumbuhan anak. Disarankan untuk terus melakukan penilaian sesuai kelompok umur balita.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Hasil ini tidak dapat menggantikan penilaian perkembangan secara formal. Jika Anda masih memiliki kekhawatiran tentang perkembangan anak Anda, situs web Tiny Detector menyediakan daftar sumber daya tambahan yang dapat diakses melalui tombol SUMBER di bawah ini.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 30.0),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Handle button press (e.g., navigate to resources page)
                  },
                  child: const Text('Sumber'),
                ),
                const SizedBox(height: 10.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => MainPage(userId: widget.userId)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF04A0A4),
                  ),
                  child: const Text(
                    'Kembali ke Beranda',
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}