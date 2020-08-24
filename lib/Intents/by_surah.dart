//System Imports
import 'package:flutter/material.dart';

//Custom Imports
// import 'package:nice_button/nice_button.dart';
import 'package:afeez/Components/surahs.dart';


class BySurah extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BySurah();
}

class _BySurah extends State<BySurah> {
  
  @override
  Widget build(BuildContext context) {
    
  return MaterialApp(
    home: Scaffold(
      appBar: (
        AppBar(
          title: Text("Hafiz"),
          backgroundColor: Colors.blueGrey,
        )
      ),
      body: Surah()
    ),
  );
    
  }
  
}