import 'package:flutter/material.dart';
import 'package:hafiz_test/splash_screen.dart';

void main() {
  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Afeez(),
    ),
  );
}

class Afeez extends StatefulWidget {
  const Afeez({super.key});

  @override
  State<StatefulWidget> createState() => _Afeez();
}

class _Afeez extends State<Afeez> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: SplashScreen());
  }
}
