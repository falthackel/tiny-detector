import 'package:flutter/material.dart';

class TermsAndCondition extends StatefulWidget {
  const TermsAndCondition({super.key});

  @override
  State<TermsAndCondition> createState() => _TermsAndConditionState();
}

class _TermsAndConditionState extends State<TermsAndCondition> {
  bool isRead = false;
  void toggleRead() => setState(() => isRead = !isRead);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // toolbarHeight: 119,
        backgroundColor: Colors.white,
        title: const Text(
          'Ketentuan dan Syarat',
          style: TextStyle(
            color: Color.fromARGB(255, 255, 161, 50),
            fontSize: 25,
            fontWeight: FontWeight.normal,
          ),
          textAlign: TextAlign.justify,
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(30),
          color: const Color.fromARGB(255, 255, 161, 50),
          child: Container(
            padding: const EdgeInsets.all(30),
            color: Colors.white,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start, // Align text to start
                children: [
                  const Text(
                    'Penilaian yang akan dilakukan adalah penilaian untuk screening ASD pada balita. Hasil penilaian tidak menggantikan penilaian diagnosis formal. Oleh karena itu, sangat disarankan untuk melanjutkan penilaian diagnosis formal untuk mendapatkan penilaian sebenarnya.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25), // Add spacing between paragraphs
                  const Text(
                    'Terdapat 20 pertanyaan yang perlu dijawab dengan respons "ya" atau "tidak". Setiap respons wajib dipilih berdasarkan kriteria tertentu yang akan disajikan dalam video.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25), // Add spacing between paragraphs
                  const Text(
                    'Jika Anda baru pertama kali atau masih awam dengan pertanyaan-pertanyaan yang ada, silahkan menonton video untuk membantu memberikan penilaian.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25), // Add spacing between paragraphs
                  const Text(
                    'Ketika penilaian berlangsung, diharapkan asesor dapat mempraktikkan secara langsung peristiwa yang terdapat di video agar penilaian dapat dilakukan seakurat mungkin.',
                    style: TextStyle(fontSize: 16),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 25), // Add spacing between paragraphs
                  const Text(
                    'Apakah anda telah membaca dan menyetujui ketentuan dan syarat diatas?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromARGB(255, 255, 161, 50),),
                    textAlign: TextAlign.justify,
                  ),
                  const SizedBox(height: 10), // Add spacing between paragraphs
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(10.0), // Adjust corner radius as needed
                    ),
                    child: CheckboxListTile(
                      controlAffinity: ListTileControlAffinity.leading, // Set checkbox to the left
                      value: isRead,
                      onChanged: (bool? value) {
                        setState(() {
                          isRead = value!;
                        });
                      },
                      // title: const Text('Headline'),
                      subtitle: const Text(
                          "Ya, saya telah membaca dan menelaah maksud dari ketentuan dan syarat diatas dan menyetujui secara penuh proses penilaian tersebut."),
                      isThreeLine: true,
                    ),
                  //   Row(
                  //     children: [
                  //       IconButton(
                  //           // Use the MdiIcons class for the IconData
                  //           icon: Icon(
                  //             MdiIcons.circleOutline, 
                  //             size: 20,
                  //             color: Colors.black,
                  //           ),
                  //           color: const Color.fromARGB(255, 255, 161, 50),
                  //           disabledColor: Colors.white,
                  //           onPressed: () { 
                  //             // setState(() {
                  //             //   isRead = not(isRead);
                  //             // });
                  //           }
                  //         ),
                  //       SizedBox(
                  //         width: MediaQuery.of(context).size.width * 0.5,
                  //         child: const Text(
                  //           'Ya, saya telah membaca dan menelaah maksud dari ketentuan dan syarat diatas dan menyetujui secara penuh proses penilaian tersebut.',
                  //           style: TextStyle(fontSize: 12),
                  //           textAlign: TextAlign.justify,
                  //           maxLines: 4,
                  //         ),
                  //       ),
                  //     ],
                  //   ),  
                  ),
                  const SizedBox(height: 35), // Add spacing between paragraphs
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextButton( // Replace Container with TextButton
                        onPressed: () { },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(
                          const Color.fromARGB(255, 116, 91, 248)
                          ), // Set button background color
                          padding: MaterialStateProperty.all<EdgeInsets>(
                            const EdgeInsets.fromLTRB(10, 0, 10, 0)
                          ), // Maintain padding
                        ),
                        child: const Text(
                          'Lanjutkan',
                          style: TextStyle(
                            color: Colors.white
                            ), // Adjust text color for better contrast
                        ),
                      ),
                    ),
                  ),
                ],
            ),
          ),
        ),
      ),
    );
  }
}