import 'package:flutter/material.dart';
import 'toddler_profile_widget.dart';

class ToddlerProfile extends StatelessWidget {
  const ToddlerProfile({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Profile Balita',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 161, 50),
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
      body: const SingleChildScrollView(
        child: Center(
          child: ToddlerProfileWidget(),
        ),
      ),
    );
  }
}
