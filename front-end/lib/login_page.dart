import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_tiny_detector/dashboard_page.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'main_page.dart';
import 'footer.dart';
import 'sign_up_page.dart';
import 'api_service.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final storage = const FlutterSecureStorage();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final ValueNotifier<bool> _obscureText = ValueNotifier<bool>(true);

  Future<void> storeToken(String token) async {
    await storage.write(key: 'jwt_token', value: token);
  }

  bool isTokenExpired(String token) {
    return JwtDecoder.isExpired(token);
  }

  Future<void> login() async {
    String email = emailController.text;
    String password = passwordController.text;
    Map<String, dynamic> loginResponse = {};

    try {
      loginResponse = await ApiService.attemptLogIn(email, password);

      if (loginResponse == {} || !loginResponse.containsKey('token') || !loginResponse.containsKey('role')) {
        throw Exception('Invalid login response');
      }

      String token = loginResponse['token'];
      String role = loginResponse['role'];
      try {
        await storeToken(token);
      } catch (e) {
        throw Exception('Failed to store token AAAAA');
      }

      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      if (!decodedToken.containsKey('userId')) {
        throw Exception('User ID is missing in the token');
      }

      final userId = decodedToken['userId'];
    
      if (userId == null) {
        throw Exception('User ID or role is missing in the token');
      }

      if (isTokenExpired(token)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Token is expired. Please log in again.')),
        );
      } else {
        if (role == 'User') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainPage(userId: userId),
            ),
          );
        } else if (role == 'Admin') {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => DashboardPage(userId: userId),
            ),
          );
        } else {
          throw Exception('Unknown role');
        }
      }
    } catch (e, stackTrace) {
      print("Error: $e");
      print("Stack trace: $stackTrace");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Login failed: $e $loginResponse')),
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
                Image.asset(
                  'assets/tiny-detector-colored.png',
                  height: 200,
                  width: 200,
                ),
                const SizedBox(height: 20),
                const Text(
                  'Masuk',
                  style: TextStyle(
                    fontSize: 24,
                    color: Color(0xFFFFA132),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  'Selamat datang kembali.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Color(0xFF00BFA6),
                  ),
                ),
                const SizedBox(height: 30),
                _buildTextField(label: 'E-mail', placeholder:  'Masukkan email', controller:  emailController),
                const SizedBox(height: 20),
                _buildPasswordField(label: 'Kata sandi', placeholder: 'Masukkan kata sandi', controller: passwordController),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: login,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 255, 161, 50), // background color
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                  ),
                  child: const Text(
                    'Masuk',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SignUpPage(), // Navigate to SignUpPage
                      ),
                    );
                  },
                  child: const Text(
                    'Pengguna baru? Daftar di sini',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF00BFA6),
                    ),
                  ),
                ),
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