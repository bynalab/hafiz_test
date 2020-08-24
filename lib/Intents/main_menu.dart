//System Imports
import 'dart:math';

import 'package:afeez/Intents/by_juz.dart';
import 'package:afeez/Intents/test_page.dart';
import 'package:flutter/material.dart';

//Custom Imports
import 'package:nice_button/nice_button.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'by_surah.dart';

class MainMenu extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _MainMenu();
}

class _MainMenu extends State<MainMenu> {
  bool text;
  bool isSwitched = false;
  bool splash = true;
  var random;
  getSettings() async {
    SharedPreferences settings = await SharedPreferences.getInstance();
    setState(() {
      isSwitched = settings.getBool('autoplay');
    });
  }

  setSettings(value) async {
    SharedPreferences settings = await SharedPreferences.getInstance();
    settings.setBool('autoplay', value);
  }

  _showDialog() {
    Alert(
      context: context,
      // type: AlertType.success,
      closeFunction: () {},
      title: "Settings",
      // desc: "Flutter is more awesome with RFlutter Alert.",
      content: StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
        return Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Text("Autoplay verse"),
                Switch(
                  value: isSwitched,
                  onChanged: (value) {
                    setState(() {
                      isSwitched = value;
                      setSettings(isSwitched);
                    });
                  },
                  activeTrackColor: Colors.blueGrey,
                  activeColor: Colors.green,
                )
              ],
            )
          ],
        );
      }),
      buttons: [
        DialogButton(
            child: Text(
              "Cancel",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            color: Colors.blueGrey)
      ],
    ).show();
  }

  _fullQuran() {
    random = new Random();
    var chapter = 1 + random.nextInt(114 - 1);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => TestPage(
                  verse: null,
                  chapter: chapter,
                )));
  }

  @override
  void initState() {
    this.getSettings();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: (AppBar(
        title: Text(
          "HAFIZ",
          style: TextStyle(fontSize: 30),
        ),
        backgroundColor: Colors.blueGrey,
      )),
      body: Container(
          margin: EdgeInsets.only(top: 100.0),
          child: Column(
            children: <Widget>[
              NiceButton(
                width: 500,
                elevation: 8.0,
                radius: 52.0,
                text: "Test by Surah",
                background: Colors.blueGrey,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => BySurah()));
                },
              ),
              // SizedBox(height: 20),
              // NiceButton(
              //   width: 500,
              //   elevation: 8.0,
              //   radius: 52.0,
              //   text: "Test by Juz",
              //   background: Colors.blueGrey,
              //   onPressed: () {
              //     Navigator.push(context,
              //         MaterialPageRoute(builder: (context) => ByJuz()));
              //   },
              // ),
              SizedBox(height: 20),
              NiceButton(
                width: 500,
                elevation: 8.0,
                radius: 52.0,
                text: "Test by full Quran",
                background: Colors.blueGrey,
                onPressed: () {
                  _fullQuran();
                },
              ),
              SizedBox(height: 60),
              NiceButton(
                mini: true,
                icon: Icons.settings,
                elevation: 8.0,
                radius: 52.0,
                text: "Settings",
                background: Colors.blueGrey,
                onPressed: () {
                  _showDialog();
                },
              ),
            ],
          )),
    );
  }
}
