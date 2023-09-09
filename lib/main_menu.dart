import 'package:flutter/material.dart';

import 'package:hafiz_test/juz/juz_list_screen.dart';
import 'package:hafiz_test/settings_dialog.dart';
import 'package:hafiz_test/surah/surah_list_screen.dart';
import 'package:hafiz_test/surah/test_by_surah.dart';

class MainMenu extends StatefulWidget {
  const MainMenu({super.key});

  @override
  State<StatefulWidget> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you sure?'),
            content: const Text('Do you want to exit'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text('Yes'),
              ),
            ],
          ),
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'HAFIZ',
            style: TextStyle(fontSize: 30),
          ),
          backgroundColor: Colors.blueGrey,
          actions: [
            IconButton(
              onPressed: () {
                showDialog(
                  barrierDismissible: false,
                  context: context,
                  builder: (_) {
                    return const SettingDialog();
                  },
                );
              },
              icon: const Icon(Icons.settings),
            ),
          ],
        ),
        body: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.blueGrey,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const SurahListScreen();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.group_work,
                color: Colors.white,
              ),
              label: const Text(
                'Test by Surah',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.blueGrey,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const Juz();
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.book,
                color: Colors.white,
              ),
              label: const Text(
                'Test by Juz',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(
                  Colors.blueGrey,
                ),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return const TestBySurah(surahNumber: 0);
                    },
                  ),
                );
              },
              icon: const Icon(
                Icons.book,
                color: Colors.white,
              ),
              label: const Text(
                'Test by full Quran',
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        )),
      ),
    );
  }
}
