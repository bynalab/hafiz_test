import 'package:afeez/Intents/main_menu.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _SplashScreen();
  }
}

class _SplashScreen extends State<SplashScreen> {
  Future<bool> _splash() async {
    await Future.delayed(Duration(milliseconds: 5000), () {});
    return true;
  }

  @override
  void initState() {
    super.initState();
    _splash().then((status) {
      if (status) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => MainMenu()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
            decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/6.png"),
            fit: BoxFit.cover,
          ),
        )),
        Shimmer.fromColors(
          baseColor: Colors.blueGrey,
          highlightColor: Colors.greenAccent,
          child: Container(
            margin: EdgeInsets.only(top: 220),
            child: Column(
              children: <Widget>[
                Text(
                  'HAFIZ',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    // fontFamily: 'Bebas Neue Regular',
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
      ]),
    );
  }
}
