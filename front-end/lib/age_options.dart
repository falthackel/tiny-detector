import 'package:flutter/material.dart';

class AgeOptions extends StatefulWidget {
  final Function(int) onSelectAge;

  const AgeOptions({required this.onSelectAge, super.key});

  @override
  State<AgeOptions> createState() => _AgeOptionsState();
}

class _AgeOptionsState extends State<AgeOptions> {
  double selectedAge = 12; // Initial age

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Pilihlah rentang usia dibawah ini (dalam bulan).',
            style: TextStyle(
              color: Color.fromARGB(255, 1, 204, 209),
              fontSize: 20,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        Slider(
          value: selectedAge,
          min: 12,
          max: 60,
          divisions: 48, // 48 divisions to cover each month from 12 to 60
          label: '${selectedAge.round()}',
          activeColor: const Color.fromARGB(255, 255, 161, 50),
          inactiveColor: const Color.fromARGB(255, 255, 161, 50).withOpacity(0.3),
          onChanged: (double value) {
            setState(() {
              selectedAge = value;
            });
            widget.onSelectAge(value.round()); // Notify parent about the selected age
          },
        ),
        Text(
          'Usia yang dipilih: ${selectedAge.round()} bulan',
          style: const TextStyle(
            fontSize: 18,
            color: Color.fromARGB(255, 1, 204, 209),
          ),
        ),
      ],
    );
  }
}