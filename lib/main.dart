import 'package:flutter/material.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/splash_screen.dart';
import 'package:just_audio_background/just_audio_background.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await JustAudioBackground.init(
    androidNotificationChannelId: 'com.ryanheise.bg_demo.channel.audio',
    androidNotificationChannelName: 'Audio playback',
    androidNotificationOngoing: true,
  );

  await setupLocator();

  runApp(
    const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Hafiz(),
    ),
  );
}

class Hafiz extends StatefulWidget {
  const Hafiz({super.key});

  @override
  State<StatefulWidget> createState() => _Hafiz();
}

class _Hafiz extends State<Hafiz> {
  @override
  Widget build(BuildContext context) {
    return const SplashScreen();
  }
}
