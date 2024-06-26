import 'package:flutter/material.dart';

class FAQPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 204, 209),
        title: const Text(
          'Tiny Detector',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.person, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const SizedBox(height: 20),
              const Text(
                'Apakah anda memiliki pertanyaan seputar Tiny Detector?',
                style: TextStyle(
                  fontSize: 24,
                  color: Color(0xFFFFA132),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Berikut adalah berbagai pertanyaan yang paling sering ditanyakan menurut tenaga medis profesional.',
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 20),
              Center(
                child: Image.asset('assets/faq.png', height: 100),
              ),
              const SizedBox(height: 20),
              const Text(
                'Tentang Kami',
                style: TextStyle(
                  fontSize: 20,
                  color: Color(0xFF00BFA6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              _buildFAQItem('Apa itu Tiny Detector?'),
              _buildFAQItem('Siapa saja pengembang Tiny Detector?'),
              _buildFAQItem('Apa itu ASD?'),
              _buildFAQItem('Apa saja gejala-gejala ASD?'),
              _buildFAQItem('Kapan gejala dan risiko ASD dapat muncul?'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(color: Colors.black),
      ),
      children: const <Widget>[
        ListTile(
          title: Text(
            'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua.',
            style: TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}