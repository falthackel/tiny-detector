import 'package:flutter/material.dart';
import 'main_page.dart';

class SignUpPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset('assets/tiny-detector-colored.jpeg', height: 100),
                const SizedBox(height: 20),
                const Text(
                  'Buat akun',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFFFA132),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Cegah kasus ASD pada balita lebih dahulu.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF00BFA6),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField('Nama', 'Masukkan nama lengkap'),
                const SizedBox(height: 20),
                _buildTextField('Umur', 'Masukkan umur dalam tahun'),
                const SizedBox(height: 20),
                _buildTextField('Profesi', 'Masukkan profesi'),
                const SizedBox(height: 20),
                _buildTextField('E-mail', 'Masukkan email'),
                const SizedBox(height: 20),
                _buildPasswordField('Kata sandi', 'Masukkan password'),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MainPage(userId: 1), // Provide a default userId for testing
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00BFA6), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Atau',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.login, color: Colors.white),
                  label: const Text(
                    'Daftar melalui Google',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFFA132), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, String placeholder) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildPasswordField(String label, String placeholder) {
    return TextField(
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        suffixIcon: const Icon(Icons.visibility),
      ),
    );
  }
}