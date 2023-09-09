import 'package:flutter/material.dart';
import 'package:hafiz_test/main_menu.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  Future<bool> _splash() async {
    await Future.delayed(const Duration(milliseconds: 1000), () {});
    return true;
  }

  @override
  void initState() {
    super.initState();
    _splash().then((status) {
      if (status) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) {
            return const MainMenu();
          }),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/img/6.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Shimmer.fromColors(
            baseColor: Colors.blueGrey,
            highlightColor: Colors.greenAccent,
            child: Container(
              margin: const EdgeInsets.only(top: 220),
              child: const Column(
                children: [
                  Text(
                    'HAFIZ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 80.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '(Test your quran skill)',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.0,
                      fontStyle: FontStyle.italic,
                      fontFamily: 'pacifico',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
