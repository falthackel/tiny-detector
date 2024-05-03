import 'package:flutter/material.dart';

class AgeOptions extends StatefulWidget {
  const AgeOptions({super.key});

  @override
  State<AgeOptions> createState() => _AgeOptionsState();
}

class _AgeOptionsState extends State<AgeOptions> {
  List<int> ages = const [12, 24, 36, 48, 60];
  int selectedAge = -1; // -1 indicates no selection initially  
  
  void selectAge(int age) {
    setState(() {
      selectedAge = age;
    });
  } 

  @override
  Widget build(BuildContext context) {
    return Column(
      // padding: const EdgeInsets.all(8),
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Pilihlah rentang usia dibawah ini.',
            style: TextStyle(
              color:Color.fromARGB(255, 1, 204, 209),
              fontSize: 20,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        Wrap( // Wrap for horizontal arrangement
          spacing: 15,
          children: ages.map((age) => _buildAgeOption(age)).toList(),
        ),
      ],
    );
  }

  Widget _buildAgeOption(int age) {
    final isSelected = age == selectedAge;
    final backgroundColor = isSelected ? const Color.fromARGB(255, 255, 161, 50) : Colors.white;
    const borderColor = Color.fromARGB(255, 255, 161, 50); // Orange border color

    return InkWell(
      onTap: () => selectAge(age),
      child: Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: backgroundColor, // Set background color based on selection
          shape: BoxShape.circle, // Make the container circular
          border: Border.all( // Add a border
            color: borderColor,
            width: 2.0, // Adjust border width as needed
          ),
        ),
        child: Text(
          '$age',
          style: TextStyle(
            color: isSelected ? Colors.white : const Color.fromARGB(255, 1, 204, 209),
            fontSize: 18,
          ),
        ),
      ),
    );
  }
}