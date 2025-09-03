import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/model/ayah.model.dart';
import 'package:hafiz_test/model/surah.model.dart';
import 'package:hafiz_test/services/storage/abstract_storage_service.dart';
import 'package:hafiz_test/surah/test_by_surah.dart';
import 'package:hafiz_test/widget/showcase.dart';

class LastReadCard extends StatelessWidget {
  final GlobalKey lastReadKey;
  const LastReadCard({super.key, required this.lastReadKey});

  @override
  Widget build(BuildContext context) {
    final lastRead = getIt<IStorageService>().getLastRead();

    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(23),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: 200,
            ),
            child: Image.asset('assets/img/banner.png'),
          ),
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
                    LastReadWidget(lastRead: lastRead),
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

              final (surah, ayah) = lastRead;

              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) {
                    return TestBySurah(
                      surahNumber: surah.number,
                      ayahNumber: ayah.numberInSurah,
                    );
                  },
                ),
              );
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
                mainAxisSize: MainAxisSize.min,
                children: [
                  Flexible(
                    child: Text(
                      'Continue',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF004B40),
                      ),
                    ),
                  ),
                  Image.asset(
                    'assets/img/arrow_right_circle.png',
                    width: 16,
                    height: 16,
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

class LastReadWidget extends StatelessWidget {
  final (Surah, Ayah)? lastRead;

  const LastReadWidget({super.key, this.lastRead});

  @override
  Widget build(BuildContext context) {
    if (lastRead == null) {
      return Text(
        'No last read',
        style: GoogleFonts.inter(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: const Color(0xFF222222),
        ),
      );
    }

    final (surah, ayah) = lastRead!;

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
  }
}
