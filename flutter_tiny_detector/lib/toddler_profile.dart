import 'package:flutter/material.dart';

import 'package:flutter_tiny_detector/age_options.dart';
import 'package:flutter_tiny_detector/toddler_profile_widget.dart';

class ToddlerProfile extends StatefulWidget {
  const ToddlerProfile({super.key});

  @override
  State<ToddlerProfile> createState() => _ToddlerProfileState();
}

class _ToddlerProfileState extends State<ToddlerProfile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 119,
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
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const AgeOptions(),
            const ToddlerProfileWidget(),
            SizedBox(
              width: MediaQuery.of(context).size.width*0.5,
              height: 50,
              child: TextButton( // Replace Container with TextButton
                onPressed: () {
                      // Handle button press action here (e.g., navigate to another screen)
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all<Color>(
                  const Color.fromARGB(255, 255, 161, 50)
                  ), // Set button background color
                  padding: MaterialStateProperty.all<EdgeInsets>(
                    const EdgeInsets.fromLTRB(10, 0, 10, 0)
                  ), // Maintain padding
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                    color: Colors.white
                  ), // Adjust text color for better contrast
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
