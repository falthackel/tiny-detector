import 'package:flutter/material.dart';
import 'package:flutter_tiny_detector/api_service.dart';
import 'package:flutter_tiny_detector/login_page.dart';
import 'footer.dart';

class SignUpPage extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController professionController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);

  Future<void> signUp(BuildContext context) async {
    String name = nameController.text;
    int age = int.tryParse(ageController.text) ?? 0;
    String profession = professionController.text;
    String email = emailController.text;
    String password = passwordController.text;

    try {
      Map<String, dynamic> response = await ApiService.attemptSignUp(name, age, profession, email, password);
      print(response);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Daftar pengguna berhasil: $response')),
      );
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginPage()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Daftar pengguna gagal: $e')),
      );
    }
  }

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
                const SizedBox(height: 20),
                _buildTextField(label: 'Name', placeholder: 'Enter your name', controller: nameController),
                const SizedBox(height: 10),
                _buildTextField(label: 'Age', placeholder: 'Enter your age', controller: ageController, keyboardType: TextInputType.number),
                const SizedBox(height: 10),
                _buildTextField(label: 'Profession', placeholder: 'Enter your profession',controller: professionController),
                const SizedBox(height: 10),
                _buildTextField(label: 'Email', placeholder: 'Enter your email', controller: emailController, keyboardType: TextInputType.emailAddress),
                const SizedBox(height: 10),
                _buildPasswordField(label: 'Password', placeholder: 'Enter your password', controller: passwordController),
                const SizedBox(height: 20),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () => signUp(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00BFA6), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Daftar Pengguna',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Footer(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label, 
    required String placeholder, 
    required TextEditingController controller, 
    TextInputType keyboardType = TextInputType.text}) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        labelText: label,
        hintText: placeholder,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
      ),
      keyboardType: keyboardType,
    );
  }

  Widget _buildPasswordField({
    required String label, 
    required String placeholder,
    required TextEditingController controller}) {
    return ValueListenableBuilder<bool>(
      valueListenable: _obscureText,
      builder: (context, value, child) {
        return TextField(
          controller: controller,
          obscureText: value,
          decoration: InputDecoration(
            labelText: label,
            hintText: placeholder,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            suffixIcon: IconButton(
              icon: Icon(value ? Icons.visibility : Icons.visibility_off),
              onPressed: () => _obscureText.value = !value,
            ),
          ),
        );
      }
    );
  }
}