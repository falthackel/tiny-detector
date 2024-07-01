import 'package:flutter/material.dart';
import 'package:flutter_tiny_detector/footer.dart';

class FAQPage extends StatelessWidget {
  final List<Map<String, String>> faqItems = [
    {
      'question': 'Apa itu Tiny Detector?',
      'answer': 'Tiny Detector adalah aplikasi yang didesain untuk guru prasekolah untuk mendeteksi gejala autisme pada balita. Aplikasi ini menerapkan sistem kuesioner dengan mengisi 20 pertanyaan yang diambil mengikuti metode kuesioner M-CHAT-R/F (Modified Checklist for Autism in Toddlers, Revised with Follow-Up), (Robins, 2018).',
    },
    {
      'question': 'Siapa saja pengembang Tiny Detector?',
      'answer': 'Tiny Detector dikembangkan oleh Farrel Jonathan Vickeldo (18320008), mahasiswa S1 Teknik Biomedis dari Institut Teknologi Bandung dengan dibimbing oleh \n(1) Allya Paramita Koesoema, S.T., M.T., M.Sc., Ph.D. dari Teknik Biomedis Institut Teknologi Bandung, dan\n(2) dr. Marietta Shanti Prananta Sp KFR Ped (K) dari Departemen Ilmu Kedokteran Fisik dan Rehabilitasi Universitas Padjadjaran.',
    },
    {
      'question': 'Apa itu ASD?',
      'answer': 'ASD atau Autism Spectrum Disorder adalah gangguan perkembangan seumur hidup yang mempengaruhi keterampilan sosial dan komunikasi individu dan berdampak pada kehidupan anggota keluarganya (Schoen, dkk., 2019).',
    },
    {
      'question': 'Apa saja gejala-gejala ASD?',
      'answer': 'Gejala ASD yang biasanya muncul adalah: \n(1) Keterlambatan perkembangan bahasa, sering kali disertai dengan kurangnya minat sosial atau interaksi sosial yang tidak biasa, pola permainan yang aneh, dan pola komunikasi yang tidak biasa, dan \n(2) perilaku aneh dan berulang serta tidak adanya permainan yang jelas.',
    },
    {
      'question': 'Kapan gejala dan risiko ASD dapat muncul?',
      'answer': 'Gejala-gejala ASD dapat dikenali pada tahun kedua kehidupan, yaitu sekitar 12-24 bulan.',
    },
    {
      'question': 'Bagaimana cara mengenali risiko ASD dengan menggunakan Tiny Detector?',
      'answer': 'Silahkan Anda membuat penilaian baru melalui fitur \'Tes Penilaian\'. Setelah Anda mengisi profil balita yang ingin dinilai, Anda perlu menjawab sebanyak 20 pertanyaan dengan jawaban \'Ya\' atau \'Tidak\'. Setelah selesai, Anda akan mendapatkan hasilnya.',
    },
    {
      'question': 'Apa yang harus dilakukan jika hasil menunjukkan "Indikasi Ringan"?',
      'answer': 'jika anak lebih muda dari 24 bulan, lakukan skrining lagi setelah ulang tahun kedua. Tidak ada tindakan lanjutan yang diperlukan, kecuali balita mengindikasikan risiko ASD, (Robins, 2018).',
    },
    {
      'question': 'Apa yang harus dilakukan jika hasil menunjukkan "Indikasi Sedang"?',
      'answer': 'lakukan Follow-up (M-CHAT-R/F tahap kedua) untuk mendapat informasi tambahan tentang respons berisiko.\n\nSkrining positif jika skor M-CHAT-R/F 2 atau lebih. Tindakan yang diperlukan: adalah rujuk anak untuk evaluasi diagnostik dan evaluasi eligibilitas untuk intervensi awal.\n\nSkrining negatif jika skor M-CHATR/F 0-1. Tidak ada tindakan lanjutan yang diperlukan, kecuali surveilans untuk mengindikasikan risiko ASD. Anak harus diskrining ulang saat datang kembali, (Robins, 2018).',
    },
    {
      'question': 'Apa yang harus dilakukan jika hasil menunjukkan "Indikasi Tinggi"?',
      'answer': 'Follow-up dapat tidak dilakukan dan pasien dirujuk segera untuk evaluasi diagnostik dan evaluasi eligibilitas untuk intervensi awal, (Robins, 2018).',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 1, 204, 209),
        centerTitle: true,
        title: Image.asset(
          'assets/tiny-detector-white.png', // Your image asset
          height: 40,
          fit: BoxFit.contain,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
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
              ...faqItems.map((item) => _buildFAQItem(item['question']!, item['answer']!)).toList(),
              Footer(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFAQItem(String question, String answer) {
    return ExpansionTile(
      title: Text(
        question,
        style: const TextStyle(color: Colors.black),
      ),
      children: <Widget>[
        ListTile(
          title: Text(
            answer,
            style: const TextStyle(color: Colors.black),
          ),
        ),
      ],
    );
  }
}