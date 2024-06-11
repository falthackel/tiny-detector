import 'package:flutter/material.dart';
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

  void _submitProfile() async {
    if (_formKey.currentState!.validate() && selectedAge != -1) {
      setState(() {
        isLoading = true; // Set loading state to true
      });

      final userData = {
        'name': nameController.text,
        'domicile': domicileController.text,
        'gender': selectedGender == 'Laki-laki' ? 1 : 2, // 1 for male and 2 for female
        'age': selectedAge,
      };

      try {
        // Check if the user data already exists
        bool userExists = await ApiService.checkUserExists(userData);
        if (userExists) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('User data already exists. Please provide different details.')),
          );
        } else {
          // Send the userData to your server.js endpoint
          await ApiService.createUser(userData);
          // Navigate to the next screen after successful submission
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const TermsAndCondition()), // Navigate to terms and conditions
          );
        }
      } catch (e) {
        // Handle error, show a snackbar or dialog
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
    return Padding(
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
          ],
        ),
      ),
    );
  }
}