import 'dart:math';
import 'package:flutter/material.dart';
import 'package:hafiz_test/main_menu.dart';
import 'package:hafiz_test/services/analytics_service.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _iconController;

  @override
  void initState() {
    super.initState();

    // Track splash screen view
    AnalyticsService.trackScreenView('Splash Screen');

    _iconController =
        AnimationController(vsync: this, duration: const Duration(seconds: 3))
          ..repeat(reverse: true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 900),
            pageBuilder: (_, __, ___) => const MainMenu(),
            transitionsBuilder: (_, animation, __, child) =>
                FadeTransition(opacity: animation, child: child),
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _iconController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Color(0xFF0D324D),
                  Color(0xFF093028),
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: StarPainter(),
              ),
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                AnimatedBuilder(
                  animation: _iconController,
                  builder: (context, child) {
                    double offset = sin(_iconController.value * 2 * pi) * 10;
                    return Transform.translate(
                      offset: Offset(0, offset),
                      child: child,
                    );
                  },
                  child: Column(
                    children: [
                      Icon(
                        Icons.nightlight_round,
                        size: 80,
                        color: Colors.amber.shade300,
                      ),
                      Image.asset(
                        'assets/img/quran_opened_star.png',
                        height: 200,
                      ),
                    ],
                  ),
                ),
                Shimmer.fromColors(
                  baseColor: Colors.amber.shade200,
                  highlightColor: Colors.greenAccent,
                  child: const Text(
                    "Quran Hafiz",
                    style: TextStyle(
                      fontSize: 52,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                      fontFamily: 'serif',
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Master the Quran, one Ayah at a time",
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 40),
                AnimatedOpacity(
                  opacity: 1.0,
                  duration: const Duration(seconds: 2),
                  child: Column(
                    children: [
                      Text(
                        "وَلَقَدْ يَسَّرْنَا الْقُرْآنَ لِلذِّكْرِ فَهَلْ مِن مُّدَّكِرٍ",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.tealAccent.shade100,
                          shadows: [
                            Shadow(
                              blurRadius: 15,
                              color: Colors.tealAccent.shade100,
                              offset: const Offset(0, 0),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: Text(
                          "\"And We have certainly made the Qur'an easy for remembrance, so is there any who will remember?\" (Q54:17)",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 16,
                            fontStyle: FontStyle.italic,
                            color: Colors.white70,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class StarPainter extends CustomPainter {
  final Random random = Random();

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = Colors.white.withValues(alpha: 0.8);
    for (int i = 0; i < 50; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final radius = random.nextDouble() * 1.5;
      canvas.drawCircle(Offset(dx, dy), radius, paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
