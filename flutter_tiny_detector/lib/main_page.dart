import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

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
        toolbarHeight: 119,
        backgroundColor: const Color.fromARGB(255, 1, 204, 209),
        title: const SizedBox(
          height: 60,
          child: Image(
            image: AssetImage(
              'assets/tiny-detector-white.jpeg'), // Replace with your image path
              fit: BoxFit.contain, // Adjust image fitting if needed
          ),
        ),
        // Leading for sidebar menu
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.white,), // Sidebar menu icon
          onPressed: () {
            // Handle sidebar menu button press
          },
        ),
        // Row for search bar and profile icon
        actions: [
          Row(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width * 0.8, // 80% of screen width
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'Cari menu, servis, berita..',
                    hintStyle: const TextStyle(
                      color: Color.fromARGB(255, 1, 204, 209),
                    ),
                    prefixIcon: const Icon(Icons.search, color:Color.fromARGB(255, 1, 204, 209),),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    fillColor: Colors.white,
                    filled: true,
                  ),
                ),
              ),
              const SizedBox(width: 10.0), // Add spacing between search bar and profile icon
              Container(
                margin: const EdgeInsets.all(5), // Adjust margin for aesthetics
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(Icons.person), // Profile icon
                  onPressed: () {
                    // Handle profile button press (navigate to profile page, etc.)
                  },
                ),
              ),
            ],
          ),
        ],
      ),
      body: const Text("Hello World!"), // Replace with your content
    );
  }
}
