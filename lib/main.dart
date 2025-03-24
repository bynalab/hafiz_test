import 'package:flutter/material.dart';
import 'package:hafiz_test/splash_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

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
