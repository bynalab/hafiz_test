import 'package:afeez/Intents/splash_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Afeez(),
  )
      );
}

class Afeez extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Afeez();
}

class _Afeez extends State<Afeez> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: SplashScreen());
  }
}
