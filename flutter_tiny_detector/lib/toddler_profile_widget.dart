import 'package:flutter/material.dart';
import 'package:flutter_tiny_detector/footer.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'api_service.dart';
import 'terms_and_conditions.dart';
import 'age_options.dart'; // Correct import for AgeOptions

class ToddlerProfileWidget extends StatefulWidget {
  const ToddlerProfileWidget({super.key});

  @override
  State<ToddlerProfileWidget> createState() => _ToddlerProfileWidgetState();
}

class _ToddlerProfileWidgetState extends State<ToddlerProfileWidget> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController domicileController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String selectedGender = 'Laki-laki'; // Default value
  bool isLoading = false; // Loading state
  int selectedAge = -1; // Selected age
  late bool userExists;
  int? assessorId; // Assessor ID


  @override
  void initState() {
    super.initState();
  }

  void _submitProfile() async {
    if (_formKey.currentState!.validate() && selectedAge != -1) {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      try {
        String? token = await ApiService.getToken();

        if (token == null) {
          throw Exception('Token is null');
        }

        Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
        int assessorId = decodedToken['userId'];

        final userData = {
          'toddler_name': nameController.text,
          'toddler_domicile': domicileController.text,
          'toddler_gender': selectedGender == 'Laki-laki' ? 1 : 2,
          'toddler_age': selectedAge,
          'assessor_id': assessorId,
        };

        userExists = await ApiService.checkUserExists(userData);
        if (userExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data already exists. Please provide different details.')),
          );
        } else {
          final response = await ApiService.createUser(userData);
          if (response.containsKey('toddler_id')) {
            int userId = response['toddler_id']; // Extract userId from response
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => TermsAndCondition(userId: userId, responseId: userId), // Navigate to terms and conditions
              ),
            );
          } else {
            throw Exception("Failed to get toddler ID");
          }
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit profile: $e')),
        );
      } finally {
        setState(() {
          isLoading = false; // Set loading state to false
        });
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields and select an age')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profil Balita',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 161, 50),
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 50),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              AgeOptions(onSelectAge: (age) {
                setState(() {
                  selectedAge = age;
                });
              }),
              const SizedBox(height: 25),
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Nama'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Nama tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: domicileController,
                decoration: const InputDecoration(labelText: 'Domisili'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Domisili tidak boleh kosong';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),
              const Text('Jenis Kelamin'),
              DropdownButtonFormField<String>(
                value: selectedGender,
                items: const [
                  DropdownMenuItem(value: 'Laki-laki', child: Text('Laki-laki')),
                  DropdownMenuItem(value: 'Perempuan', child: Text('Perempuan')),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedGender = value!;
                  });
                },
                validator: (value) {
                  if (value == null) {
                    return 'Pilih jenis kelamin';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: isLoading ? null : _submitProfile,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 255, 161, 50),
                  foregroundColor: Colors.white,
                ),
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text('Submit'),
              ),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }
}