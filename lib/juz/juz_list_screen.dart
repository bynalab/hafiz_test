import 'package:flutter/material.dart';
import 'package:hafiz_test/data/juz_list.dart';
import 'package:hafiz_test/juz/test_by_juz.dart';

class Juz extends StatefulWidget {
  const Juz({super.key});

  @override
  State<StatefulWidget> createState() => _Juz();
}

class _Juz extends State<Juz> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hafiz'),
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
