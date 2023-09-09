import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:hafiz_test/model/surah.model.dart';

class SurahScreen extends StatefulWidget {
  final Surah surah;

  const SurahScreen({Key? key, required this.surah}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Surah();
}

class _Surah extends State<SurahScreen> {
  bool isLoading = false;

  Surah surah = Surah();

  void getSurah() {
    setState(() => isLoading = true);

    surah = widget.surah;

    setState(() => isLoading = false);
  }

  final audioPlayer = AudioPlayer();

  Future<void> playAudio(String url) async {
    await audioPlayer.play(UrlSource(url));
  }

  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();

    getSurah();
  }

  @override
  void dispose() {
    audioPlayer.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hafiz'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Center(
        child: isLoading
            ? const CircularProgressIndicator(
                strokeWidth: 5,
                backgroundColor: Colors.blueGrey,
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              )
            : SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Text(
                        surah.name,
                        style: const TextStyle(
                          fontSize: 40,
                          color: Colors.blueGrey,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: surah.ayahs.length,
                      itemBuilder: (context, index) {
                        final ayah = surah.ayahs[index];

                        return InkWell(
                          child: Card(
                            color: selectedIndex == index
                                ? Colors.blueGrey
                                : Colors.white,
                            child: Container(
                              padding: const EdgeInsets.all(10.0),
                              alignment: Alignment.topRight,
                              child: Text(
                                ayah.text,
                                textDirection: TextDirection.rtl,
                                style: TextStyle(
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Colors.blueGrey,
                                  fontSize: 30.0,
                                ),
                              ),
                            ),
                          ),
                          onLongPress: () async {
                            setState(() => selectedIndex = index);
                            await playAudio(ayah.audio);
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
