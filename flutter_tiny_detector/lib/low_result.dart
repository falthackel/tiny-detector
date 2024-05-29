import 'package:flutter/material.dart';

class LowResult extends StatelessWidget {
  const LowResult({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 204, 209),
        title: const SizedBox(
          height: 40,
          child: Center(
            child: Image(
              image: AssetImage('assets/tiny-detector-white.png'), // Replace with your image path
              fit: BoxFit.contain, // Adjust image fitting if needed
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.menu, size: 35, color: Colors.white),
          onPressed: () {
            // Handle sidebar menu button press
          },
        ),
        actions: [
          Container(
            margin: const EdgeInsets.all(5),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Handle profile button press (navigate to profile page, etc.)
              },
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(15),
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 1, 204, 209),
          borderRadius: BorderRadius.circular(30.0), // Set corner radius to 30
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const Text(
              'Hasil:',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Indikasi Rendah',
              style: TextStyle(color: Colors.white, fontSize: 32),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Berdasarkan jawaban Anda, indikasi autisme pada anak tergolong rendah.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Anda akan menerima email rincian hasil yang berisi jawaban Anda untuk setiap pertanyaan penilaian.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Perlu diingat, autisme adalah kondisi perkembangan yang gejalanya bisa muncul seiring pertumbuhan anak. Disarankan untuk terus melakukan penilaian sesuai kelompok umur balita.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            const Text(
              'Hasil ini tidak dapat menggantikan penilaian perkembangan secara formal. Jika Anda masih memiliki kekhawatiran tentang perkembangan anak Anda, situs web Tiny Detector menyediakan daftar sumber daya tambahan yang dapat diakses melalui tombol SUMBER di bawah ini.',
              style: TextStyle(color: Colors.white),
            ),
            const SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                // Handle button press (e.g., navigate to resources page)
              },
              child: const Text('SUMBER'),
            ),
          ],
        ),
      ),
    );
  }
}
