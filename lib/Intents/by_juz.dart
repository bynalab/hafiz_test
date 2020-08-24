//System Imports
import 'package:flutter/material.dart';

//Custom Imports
import 'package:afeez/Components/juz.dart';


class ByJuz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ByJuz();
}

class _ByJuz extends State<ByJuz> {
  
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
      body: Juz()
    ),
  );
    
  }
  
}