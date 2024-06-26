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
                SizedBox(height: 20),
                Text(
                  'Buat akun',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFFFA132),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Mulailah perjalanan sehat bersama kami.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF00BFA6),
                  ),
                ),
                SizedBox(height: 30),
                _buildTextField('Nama', 'Farrel Jonathan Vickeldo'),
                SizedBox(height: 20),
                _buildDropdownField('Umur', '21 Tahun'),
                SizedBox(height: 20),
                _buildTextField('Profesi', 'Guru'),
                SizedBox(height: 20),
                _buildTextField('E-mail', 'farrel.jonathan.fj@gmail.com'),
                SizedBox(height: 20),
                _buildPasswordField('Kata sandi', '***********'),
                SizedBox(height: 30),
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
                  child: Text(
                    'Daftar',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  'Atau',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: () {},
                  icon: Icon(Icons.login, color: Colors.white),
                  label: Text(
                    'Daftar melalui Google',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFFFFA132), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
    );
  }

  Widget _buildDropdownField(String label, String placeholder) {
    return InputDecorator(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: placeholder,
          onChanged: (String? newValue) {},
          items: <String>['21 Tahun', '22 Tahun', '23 Tahun']
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
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
        contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
        suffixIcon: Icon(Icons.visibility),
      ),
    );
  }
}