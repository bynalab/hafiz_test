import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:afeez/Api/requests.dart';
import 'package:afeez/Intents/surah.dart';
import 'package:audioplayer/audioplayer.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class TestPage extends StatefulWidget {
  final int chapter, verse;
  TestPage({Key key, @required this.chapter, @required this.verse})
      : super(key: key);

  @override
  State<StatefulWidget> createState() => _TestPage();
}

class _TestPage extends State<TestPage> with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Random random;
  AudioPlayer audioPlayer = AudioPlayer();

  var isPlaying = false;
  var randomVerse = 'Random Verse';
  int currentVerse = 0;
  var audioVerse;
  bool isLoading = false;
  bool isResume = false;
  bool isJuz = false;
  bool isFirst = true;

  List randomVerses;
  var chapter;
  var verse;

  playAudio(url) async {
    await audioPlayer.play(url);
  }

  @override
  void initState() {
    _animationController =
        new AnimationController(vsync: this, duration: Duration(seconds: 1));
    _animationController.repeat();
    super.initState();
    this._randomVerse();
    this.getSettings();
  }

  @override
  dispose() {
    _animationController.dispose();
    audioPlayer.stop();
    super.dispose();
  }

  bool autoplay = true;
  getSettings() async {
    SharedPreferences settings = await SharedPreferences.getInstance();
    setState(() {
      autoplay = settings.getBool('autoplay') ?? true;
    });
  }

  _randomVerse() async {
    setState(() {
      isLoading = true;
    });

    //For Juz Start
    if (widget.verse != null) {
      setState(() {
        isJuz = true;
      });
      verse = widget.verse;
      var res = await RequestResources().getResources('ayah/$verse/ar.alafasy');
      var body = json.decode(res.body);
      setState(() {
        randomVerse = body['data']['text'];
        audioVerse = body['data']['audioSecondary'][0];
        chapter = body['data']['surah']['number'];
      });
      //For Juz End
    } else {
      chapter = widget.chapter;
      var res =
          await RequestResources().getResources('surah/$chapter/ar.alafasy');
      var body = json.decode(res.body);
      setState(() {
        randomVerses = body['data']['ayahs'];
      });

      int min = 0;
      int max = randomVerses.length;
      random = new Random();
      var range = min + random.nextInt(max - min);
      audioVerse = randomVerses[range]['audioSecondary'][0];

      setState(() {
        randomVerse = randomVerses[range]['text'];
        currentVerse = randomVerses[range]['numberInSurah'];
      });
    }

    if (autoplay) {
      await this.playAudio(audioVerse);
      setState(() {
        isPlaying = true;
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  _nextVerse(ctx) async {
    if (isFirst) {
      currentVerse -= 1;
      isFirst = false;
    }
    if (currentVerse < randomVerses.length) {
      setState(() {
        currentVerse += 1;
        randomVerse = randomVerses[currentVerse]['text'];
        audioVerse = randomVerses[currentVerse]['audioSecondary'][0];
      });

      if (autoplay) {
        await this.playAudio(audioVerse);
        setState(() {
          isPlaying = true;
        });
      } else {
        audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
      }
    } else {
      final snackBar = SnackBar(
        content: Text('End of Surah'),
        action: SnackBarAction(
          label: 'Toh',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      Scaffold.of(ctx).showSnackBar(snackBar);
    }
  }

  _previousVerse(ctx) {
    if (currentVerse != 0) {
      setState(() {
        currentVerse -= 1;
        randomVerse = randomVerses[currentVerse]['text'];
        audioVerse = randomVerses[currentVerse]['audioSecondary'][0];
      });
      if (autoplay) {
        this.playAudio(audioVerse);
        setState(() {
          isPlaying = true;
        });
      } else {
        audioPlayer.pause();
        setState(() {
          isPlaying = false;
        });
      }
    } else {
      final snackBar = SnackBar(
        content: Text('Beginning of Surah'),
        action: SnackBarAction(
          label: 'Toh',
          onPressed: () {
            // Some code to undo the change.
          },
        ),
      );
      Scaffold.of(ctx).showSnackBar(snackBar);
    }
  }

  Future<void> _refreshVerse() async {
    setState(() {
      _randomVerse();
      isFirst = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Hafiz"),
          backgroundColor: Colors.blueGrey,
        ),
        body: Builder(
            builder: (ctx) => isLoading
                ? Center(
                    child: CircularProgressIndicator(
                      strokeWidth: 5,
                      backgroundColor: Colors.blueGrey,
                      valueColor:
                          new AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : SingleChildScrollView(
                    child: Center(
                      child: Container(
                          margin: EdgeInsets.only(top: 50),
                          padding: EdgeInsets.all(20.0),
                          child: Column(
                            children: <Widget>[
                              FadeTransition(
                                opacity: _animationController,
                                child: Text(
                                  "WHAT'S NEXT?",
                                  style: TextStyle(
                                      color: Colors.blueGrey, fontSize: 30),
                                ),
                              ),
                              SizedBox(height: 30),
                              Text(
                                randomVerse,
                                style: TextStyle(
                                    fontSize: 30, color: Colors.blueGrey),
                              ),
                              SizedBox(height: 100),
                              InkWell(
                                  child: isPlaying
                                      ? Icon(
                                          Icons.pause_circle_outline,
                                          size: 80.0,
                                          color: Colors.blueGrey,
                                        )
                                      : Icon(
                                          Icons.play_circle_outline,
                                          size: 80.0,
                                          color: Colors.blueGrey,
                                        ),
                                  onTap: () {
                                    setState(() {
                                      isPlaying
                                          ? audioPlayer.pause()
                                          : playAudio(audioVerse);
                                      isPlaying = !isPlaying;
                                    });
                                  }),
                              SizedBox(height: 50),
                              Wrap(
                                spacing: 50,
                                children: <Widget>[
                                  FlatButton.icon(
                                    color: Colors.blueGrey,
                                    onPressed: () {
                                      _previousVerse(ctx);
                                    },
                                    icon: Icon(Icons.navigate_before,
                                        color: Colors.white),
                                    label: Text(
                                      'Previous',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                  FlatButton.icon(
                                    color: Colors.blueGrey,
                                    onPressed: () {
                                      _nextVerse(ctx);
                                    },
                                    icon: Text('      Next',
                                        style: TextStyle(color: Colors.white)),
                                    label: Icon(Icons.navigate_next,
                                        color: Colors.white),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(18.0),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 30),
                              ButtonTheme(
                                minWidth: 300,
                                height: 40,
                                child: FlatButton.icon(
                                  color: Colors.blueGrey,
                                  onPressed: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                Surah(surahNumber: chapter)));
                                  },
                                  icon: Icon(Icons.remove_red_eye,
                                      color: Colors.white),
                                  label: Text(
                                    'View All',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                              ButtonTheme(
                                minWidth: 300,
                                height: 40,
                                child: FlatButton.icon(
                                  color: Colors.blueGrey,
                                  onPressed: () {
                                    _refreshVerse();
                                  },
                                  icon:
                                      Icon(Icons.refresh, color: Colors.white),
                                  label: Text(
                                    'Refresh',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(18.0),
                                  ),
                                ),
                              ),
                            ],
                          )),
                    ),
                  )),
      ),
    );
  }
}
