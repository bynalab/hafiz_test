import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/surah/test_by_surah.dart';
import 'package:hafiz_test/widget/showcase.dart';

class LastReadCard extends StatelessWidget {
  final GlobalKey lastReadKey;
  const LastReadCard({super.key, required this.lastReadKey});

  @override
  Widget build(BuildContext context) {
    (Surah, Ayah)? lastRead;

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: Image.asset('assets/img/banner.png'),
        ),
        Padding(
          padding: const EdgeInsets.all(23),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ShowCase(
                widgetKey: lastReadKey,
                title: 'Last Read',
                description: 'This shows your last read Surah and Ayah.',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Last Read',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    const SizedBox(height: 15),
                    FutureBuilder(
                      future: StorageServices.getInstance.getLastRead(),
                      builder: (_, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Color(0xFF004B40),
                            ),
                          );
                        }

                        if (!snapshot.hasData) {
                          return Text(
                            'No last read',
                            style: GoogleFonts.inter(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF222222),
                            ),
                          );
                        }

                        final (surah, ayah) = lastRead = snapshot.data!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              surah.name.replaceAll('سُورَةُ ', ''),
                              style: const TextStyle(
                                fontFamily: 'Kitab',
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF222222),
                              ),
                            ),
                            Text(
                              'Ayah no. ${ayah.numberInSurah}',
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                color: const Color(0xFF222222),
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ],
                ),
              ),
              Image.asset(
                'assets/img/quran_opened_star.png',
                height: 120,
              ),
            ],
          ),
        ),
        Positioned(
          bottom: 15,
          left: 23,
          child: GestureDetector(
            onTap: () async {
              if (lastRead == null) return;

              final (surah, ayah) = lastRead!;

              await Navigator.push(context, MaterialPageRoute(
                builder: (_) {
                  return TestBySurah(
                    surahNumber: surah.number,
                    ayahNumber: ayah.numberInSurah,
                  );
                },
              ));
            },
            child: Container(
              width: 115,
              padding: const EdgeInsets.symmetric(
                horizontal: 11,
                vertical: 8,
              ),
              decoration: BoxDecoration(
                color: const Color(0xFFFAF6EB),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Continue',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF004B40),
                    ),
                  ),
                  Image.asset(
                    'assets/img/arrow_right_circle.png',
                  )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
