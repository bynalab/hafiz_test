import 'dart:convert';
import 'package:afeez/Api/requests.dart';
import 'package:flutter/material.dart';
import 'package:audioplayer/audioplayer.dart';

class Surah extends StatefulWidget {
  final int surahNumber;
  Surah({Key key, @required this.surahNumber}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Surah();
}

class _Surah extends State<Surah> {
  bool isLoading = false;
  bool isPlaying = false;
  List verses;
  var chapterTitleEn;
  var chapterTitleAr;
  var color;

  var chapter;
  getSurah() async {
    setState(() {
      isLoading = true;
    });
    chapter = widget.surahNumber;
    var res =
        await RequestResources().getResources('surah/$chapter/ar.alafasy');
    var body = json.decode(res.body);
    setState(() {
      verses = body['data']['ayahs'];
      chapterTitleAr = body['data']['name'];
      chapterTitleEn = body['data']['englishName'];
      isLoading = false;
    });
  }

  AudioPlayer audioPlayer = AudioPlayer();
  playAudio(url) async {
    await audioPlayer.play(url);
  }

  int _selectedIndex;
  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    this.getSurah();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hafiz"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Center(
          child: isLoading
              ? CircularProgressIndicator(
                  strokeWidth: 5,
                  backgroundColor: Colors.blueGrey,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                )
              : Column(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        chapterTitleAr,
                        style: TextStyle(
                            fontSize: 40,
                            color: Colors.blueGrey,
                            decoration: TextDecoration.underline),
                      ),
                    ),
                    Expanded(
                      child: ListView.builder(
                          itemCount: verses != null ? verses.length : 0,
                          itemBuilder: (BuildContext context, int index) {
                            return InkWell(
                              child: Card(
                                color: _selectedIndex == index
                                    ? Colors.blueGrey
                                    : Colors.white,
                                child: Container(
                                  padding: EdgeInsets.all(10.0),
                                  alignment: Alignment.topRight,
                                  child: Text(
                                    '${verses[index]['text']}',
                                    textDirection: TextDirection.rtl,
                                    style: TextStyle(
                                        color: _selectedIndex == index
                                            ? Colors.white
                                            : Colors.blueGrey,
                                        fontSize: 30.0),
                                  ),
                                ),
                              ),
                              onLongPress: () async {
                                _onSelected(index);
                                playAudio(verses[index]['audioSecondary'][0]);

                                audioPlayer.onAudioPositionChanged
                                    .listen((event) {
                                  setState(() {
                                    _selectedIndex = null;
                                  });
                                });
                              },
                            );
                          }),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
