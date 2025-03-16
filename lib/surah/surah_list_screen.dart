import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/data/surah_list.dart';
import 'package:hafiz_test/surah/test_by_surah.dart';

class SurahListScreen extends StatefulWidget {
  const SurahListScreen({super.key});

  @override
  State<SurahListScreen> createState() => _SurahListScreenState();
}

class _SurahListScreenState extends State<SurahListScreen> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: const Color(0xFF004B40),
        scrolledUnderElevation: 10,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Search Surah'),
                onChanged: (juzName) {
                  surahList = searchSurah(juzName);

                  setState(() {});
                },
              )
            : Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: SvgPicture.asset('assets/img/arrow_back.svg'),
                  ),
                  const SizedBox(width: 13),
                  Text(
                    'Surah List',
                    style: GoogleFonts.montserrat(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF222222),
                    ),
                  ),
                ],
              ),
        actions: [
          if (isSearching)
            IconButton(
              onPressed: () {
                setSurahList();
                setState(() => isSearching = false);
              },
              icon: const Icon(Icons.close),
            )
          else
            IconButton(
              onPressed: () {
                setState(() => isSearching = true);
              },
              icon: SvgPicture.asset('assets/img/search.svg'),
            )
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/img/surah_background.png"),
            fit: BoxFit.cover,
          ),
        ),
        child: ListView.separated(
          padding: const EdgeInsets.all(15),
          itemCount: surahList.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (_, index) {
            final surah = surahList[index];
            final surahNumber = surah.number;

            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF23364F).withValues(alpha: 0.1),
                      spreadRadius: 0,
                      blurRadius: 30,
                      offset: const Offset(4, 4),
                    ),
                  ],
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$surahNumber. ${surah.englishName}',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF222222),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 15,
                      color: Color(0xFF181817),
                    ),
                  ],
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) {
                      return TestBySurah(surahNumber: surahNumber);
                    },
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
