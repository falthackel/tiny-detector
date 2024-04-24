import 'package:flutter/material.dart';

class ToddlerProfileWidget extends StatefulWidget {
  const ToddlerProfileWidget({Key? key}) : super(key: key);

  @override
  State<ToddlerProfileWidget> createState() => _ToddlerProfileWidgetState();
}

class _ToddlerProfileWidgetState extends State<ToddlerProfileWidget> {
  TextEditingController nameController = TextEditingController(text: '');
  TextEditingController domicileController = TextEditingController(text: '');
  String selectedGender = 'Laki-laki'; // Set default value

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(50),
      child: Column(
        children: [
          TextField(
            controller: nameController,
            style: const TextStyle(fontWeight: FontWeight.normal),
            cursorColor: Colors.black,
            decoration: _buildTextFieldDecoration('Nama'), // Use the function
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 10), // Add spacing between TextFields
          TextField(
            controller: domicileController,
            style: const TextStyle(fontWeight: FontWeight.normal),
            cursorColor: Colors.black,
            decoration: _buildTextFieldDecoration('Domisili'), // Use the function
            onChanged: (value) => setState(() {}),
          ),
          const SizedBox(height: 20), // Add spacing between TextFields

          DropdownButtonFormField<String>(
            value: selectedGender,
            items: const [
              DropdownMenuItem(
                value: 'Laki-laki',
                child: Text('Laki-laki'),
              ),
              DropdownMenuItem(
                value: 'Perempuan',
                child: Text('Perempuan'),
              ),
            ],
            hint: const Text('Pilih jenis kelamin'),
            onChanged: (String? newValue) {
              setState(() {
                selectedGender = newValue!;
              });
            },
            decoration: _buildTextFieldDecoration('Jenis Kelamin'), // Use the function
            validator: (String? value) {
              if (value == null || value.isEmpty) {
                return 'Pilih jenis kelamin';
              }
            },
          ),
        ],
      ),
    );
  }

  InputDecoration _buildTextFieldDecoration(String hintText) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(
        color: Colors.black54,
        fontWeight: FontWeight.normal,
      ),
      hintMaxLines: 2,
      floatingLabelBehavior: FloatingLabelBehavior.auto,
      label: Container(
        padding: const EdgeInsets.all(3),
        child: Text(hintText.replaceAll('Masukkan ', ''),
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.normal,
            )),
      ),
      helperText: hintText.contains('Nama')
          ? 'Isi dengan nama depan saja'
          : hintText.contains('Domisili')
          ? 'Isi dengan nama provinsi saja'
          : '',
      helperStyle: const TextStyle(
        color: Colors.grey,
        fontWeight: FontWeight.normal,
      ),
      helperMaxLines: 2,
      fillColor: Colors.white,
      filled: true,
      enabledBorder: OutlineInputBorder(
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 1, 204, 209),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      focusedBorder: OutlineInputBorder(
        gapPadding: 20,
        borderSide: const BorderSide(
          color: Color.fromARGB(255, 255, 161, 50),
          width: 2,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}
