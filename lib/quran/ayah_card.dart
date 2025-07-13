import 'package:intl/intl.dart' hide TextDirection;

import 'package:flutter/material.dart';
import 'package:hafiz_test/extension/quran_extension.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/services/audio_services.dart';
import 'package:just_audio/just_audio.dart';

class AyahCard extends StatefulWidget {
  final Ayah ayah;
  final int index;
  final bool isPlaying;
  final void Function(int)? onPlayPressed;

  const AyahCard({
    super.key,
    required this.ayah,
    required this.index,
    this.isPlaying = false,
    this.onPlayPressed,
  });

  @override
  State<AyahCard> createState() => _AyahCardState();
}

class _AyahCardState extends State<AyahCard> {
  final audioServices = AudioServices();

  bool isPlayingInternal = false;

  @override
  void initState() {
    super.initState();

    audioServices.audioPlayer.playerStateStream.listen((state) {
      setState(() {
        isPlayingInternal =
            state.playing && state.processingState != ProcessingState.completed;
      });
    });
  }

  Future<void> handlePlayPause() async {
    widget.onPlayPressed?.call(widget.index);
    if (isPlayingInternal && widget.isPlaying) {
      await audioServices.pause();
    } else {
      await audioServices.setAudioSource(widget.ayah.audioSource);
      await audioServices.play();
    }
  }

  String getDecoratedAyahNumber(int number) {
    final arabicNumber = NumberFormat('#', 'ar_EG').format(number);
    return String.fromCharCodes(Runes('\u{fd3f}$arabicNumber\u{fd3e}'));
  }

  @override
  Widget build(BuildContext context) {
    final isActive = isPlayingInternal && widget.isPlaying;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 24),
            decoration: BoxDecoration(
              gradient: RadialGradient(
                center: Alignment.topLeft,
                radius: 2,
                colors: isActive
                    ? [Colors.green.shade50, Colors.green.shade100]
                    : [Colors.white, Colors.grey.shade100],
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                if (isActive)
                  BoxShadow(
                    color: Colors.green.shade200.withValues(alpha: 0.3),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
              ],
              border: Border.all(
                color: Colors.green.shade100,
                width: 0.5,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Text.rich(
                    textDirection: TextDirection.rtl,
                    textAlign: TextAlign.center,
                    TextSpan(
                      children: [
                        TextSpan(
                          text: widget.ayah.text,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: 'Quran',
                            height: 2,
                            color: Colors.black87,
                          ),
                        ),
                        TextSpan(
                          text:
                              "    ${getDecoratedAyahNumber(widget.ayah.numberInSurah)}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontFamily: 'Quran',
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // if (widget.ayah.translation != null)
                //   Padding(
                //     padding: const EdgeInsets.only(top: 12),
                //     child: Text(
                //       widget.ayah.translation!,
                //       textAlign: TextAlign.center,
                //       style: const TextStyle(
                //         fontStyle: FontStyle.italic,
                //         color: Colors.grey,
                //         fontSize: 14,
                //       ),
                //     ),
                //   ),
              ],
            ),
          ),

          /// Play Button
          Positioned(
            bottom: 5,
            right: 5,
            child: GestureDetector(
              onTap: handlePlayPause,
              child: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: isActive
                      ? Colors.red.shade600.withValues(alpha: 0.5)
                      : Colors.green.shade500.withValues(alpha: 0.5),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(2, 2),
                    ),
                  ],
                ),
                child: Icon(
                  isActive ? Icons.stop : Icons.play_arrow,
                  color: Colors.white,
                  size: 15,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

// class AyahCard extends StatefulWidget {
//   final Ayah ayah;
//   final int index;
//   final bool isPlaying;
//   final void Function(int)? onPlayPressed;

//   const AyahCard({
//     super.key,
//     required this.ayah,
//     required this.index,
//     this.isPlaying = false,
//     this.onPlayPressed,
//   });

//   @override
//   State<AyahCard> createState() => _AyahCardState();
// }

// class _AyahCardState extends State<AyahCard>
//     with SingleTickerProviderStateMixin {
//   final audioServices = AudioServices();

//   bool isPlayingInternal = false;
//   Duration currentPosition = Duration.zero;
//   Duration totalDuration = Duration.zero;
//   bool showTranslation = false;

//   @override
//   void initState() {
//     super.initState();

//     audioServices.audioPlayer.playerStateStream.listen((state) {
//       final playing =
//           state.playing && state.processingState != ProcessingState.completed;
//       if (mounted) setState(() => isPlayingInternal = playing);
//     });

//     audioServices.audioPlayer.durationStream.listen((duration) {
//       if (duration != null) {
//         setState(() => totalDuration = duration);
//       }
//     });

//     audioServices.audioPlayer.positionStream.listen((position) {
//       if (mounted) {
//         setState(() => currentPosition = position);
//       }
//     });
//   }

//   @override
//   void dispose() {
//     audioServices.audioPlayer.stop();
//     super.dispose();
//   }

//   Future<void> handlePlayPause() async {
//     widget.onPlayPressed?.call(widget.index);
//     if (isPlayingInternal && widget.isPlaying) {
//       await audioServices.pause();
//     } else {
//       await audioServices.setAudioSource(widget.ayah.audioSource);
//       await audioServices.play();
//     }
//   }

//   String getDecoratedAyahNumber(int number) {
//     final arabicNumber = NumberFormat('#', 'ar_EG').format(number);
//     return String.fromCharCodes(Runes('\u{fd3f}$arabicNumber\u{fd3e}'));
//   }

//   @override
//   Widget build(BuildContext context) {
//     final isActive = isPlayingInternal && widget.isPlaying;
//     final progress = totalDuration.inMilliseconds == 0
//         ? 0.0
//         : currentPosition.inMilliseconds / totalDuration.inMilliseconds;

//     return Stack(
//       children: [
//         Container(
//           margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
//           padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
//           decoration: BoxDecoration(
//             gradient: LinearGradient(
//               colors: [
//                 const Color(0xfffdf6e3),
//                 const Color(0xfffefae0),
//               ],
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//             ),
//             borderRadius: BorderRadius.circular(14),
//             border: Border.all(color: Colors.brown.shade200, width: 0.3),
//             boxShadow: isActive
//                 ? [
//                     BoxShadow(
//                       color: Colors.green.withOpacity(0.2),
//                       blurRadius: 12,
//                       spreadRadius: 1,
//                       offset: const Offset(0, 2),
//                     ),
//                   ]
//                 : [],
//           ),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             children: [
//               // Arabic Text + Number
//               Text.rich(
//                 textDirection: TextDirection.rtl,
//                 textAlign: TextAlign.center,
//                 TextSpan(
//                   children: [
//                     TextSpan(
//                       text: widget.ayah.text,
//                       style: const TextStyle(
//                         fontSize: 20,
//                         fontFamily: 'Quran',
//                         color: Color(0xFF2F2F2F),
//                         height: 1.6,
//                       ),
//                     ),
//                     TextSpan(
//                       text:
//                           "  ${getDecoratedAyahNumber(widget.ayah.numberInSurah)}",
//                       style: const TextStyle(
//                         fontSize: 16,
//                         fontFamily: 'Quran',
//                         fontWeight: FontWeight.bold,
//                         color: Colors.brown,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 8),
//               // Translation Toggle
//               // if (showTranslation && widget.ayah.translation != null)
//               //   Padding(
//               //     padding: const EdgeInsets.only(top: 6.0),
//               //     child: Text(
//               //       widget.ayah.translation!,
//               //       textAlign: TextAlign.right,
//               //       style: const TextStyle(
//               //         fontSize: 15,
//               //         fontStyle: FontStyle.italic,
//               //         color: Colors.black87,
//               //       ),
//               //     ),
//               //   ),
//               const SizedBox(height: 10),
//               // Progress Bar
//               if (isActive)
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(20),
//                   child: LinearProgressIndicator(
//                     value: progress.clamp(0.0, 1.0),
//                     minHeight: 4,
//                     backgroundColor: Colors.brown.shade100,
//                     valueColor:
//                         AlwaysStoppedAnimation<Color>(Colors.green.shade700),
//                   ),
//                 ),
//             ],
//           ),
//         ),
//         // Play/Stop Floating Button
//         Positioned(
//           top: 8,
//           right: 18,
//           child: GestureDetector(
//             onTap: handlePlayPause,
//             child: Container(
//               decoration: BoxDecoration(
//                 shape: BoxShape.circle,
//                 color: isActive ? Colors.green.shade600 : Colors.brown.shade300,
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.08),
//                     blurRadius: 4,
//                     offset: const Offset(2, 2),
//                   ),
//                 ],
//               ),
//               padding: const EdgeInsets.all(8),
//               child: Icon(
//                 isActive ? Icons.stop : Icons.play_arrow,
//                 color: Colors.white,
//                 size: 20,
//               ),
//             ),
//           ),
//         ),
//         // Translation toggle button (bottom left)
//         Positioned(
//           bottom: 8,
//           left: 18,
//           child: GestureDetector(
//             onTap: () => setState(() => showTranslation = !showTranslation),
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(20),
//                 color: Colors.brown.shade100.withOpacity(0.3),
//               ),
//               child: Text(
//                 showTranslation ? 'Hide Translation' : 'Show Translation',
//                 style: const TextStyle(fontSize: 12, color: Colors.brown),
//               ),
//             ),
//           ),
//         ),
//       ],
//     );
//   }
// }
