import 'package:flutter/material.dart';

class AgeOptions extends StatefulWidget {
  final Function(int) onSelectAge;

  const AgeOptions({required this.onSelectAge, super.key});

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
    widget.onSelectAge(age); // Notify parent about the selected age
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.all(20),
          child: Text(
            'Pilihlah rentang usia dibawah ini.',
            style: TextStyle(
              color: Color.fromARGB(255, 1, 204, 209),
              fontSize: 20,
            ),
            textAlign: TextAlign.justify,
          ),
        ),
        Wrap(
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
          color: backgroundColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: borderColor,
            width: 2.0,
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