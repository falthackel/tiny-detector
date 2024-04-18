import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 150,
        title: const Text('Tiny Detector'),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 1, 204, 209),
      ),
      body: const Text("Hello World!")
    );
  }
}