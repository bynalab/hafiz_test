import 'package:flutter/material.dart';
import 'package:hafiz_test/data/juz_list.dart';
import 'package:hafiz_test/juz/test_by_juz.dart';

class JuzListScreen extends StatelessWidget {
  const JuzListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hafiz - Juz List'),
        backgroundColor: Colors.blueGrey,
      ),
      body: ListView.builder(
        itemCount: juz.length,
        itemBuilder: (context, index) {
          final juzNumber = index + 1;

          return InkWell(
            child: Card(
              child: Container(
                height: 50,
                padding: const EdgeInsets.all(10.0),
                child: Text(
                  '$juzNumber) ${juz[index]}',
                  style: const TextStyle(
                    color: Colors.blueGrey,
                    fontSize: 20.0,
                  ),
                ),
              ),
            ),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(
                builder: (context) {
                  return TestByJuz(juzNumber: juzNumber);
                },
              ));
            },
          );
        },
      ),
    );
  }
}
