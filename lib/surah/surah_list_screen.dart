import 'package:flutter/material.dart';
import 'package:hafiz_test/data/surah_list.dart';
import 'package:hafiz_test/surah/test_by_surah.dart';

class SurahListScreen extends StatelessWidget {
  const SurahListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hafiz'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (_, index) {
          final surahNumber = index + 1;

          return InkWell(
            child: Card(
              child: ListTile(
                title: Text(
                  '$surahNumber) ${surahs[index]}',
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                trailing: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return TestBySurah(surahNumber: surahNumber);
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
