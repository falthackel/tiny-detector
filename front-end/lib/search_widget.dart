import 'package:flutter/material.dart';

class SearchWidget extends StatefulWidget {
  const SearchWidget({super.key});

  @override
  State<SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<SearchWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      color: const Color.fromARGB(255, 1, 204, 209),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20,10,20,10),
        child: Align(
          alignment: Alignment.center,
          child: SizedBox(
            height: 60,
            child: TextField(
              textAlignVertical: TextAlignVertical.center,
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
        ),
      ),
    );
  }
}