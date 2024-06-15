import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/data/juz_list.dart';
import 'package:hafiz_test/juz/test_by_juz.dart';

class JuzListScreen extends StatefulWidget {
  const JuzListScreen({super.key});

  @override
  State<JuzListScreen> createState() => _JuzListScreenState();
}

class _JuzListScreenState extends State<JuzListScreen> {
  bool isSearching = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: false,
        automaticallyImplyLeading: false,
        title: isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(hintText: 'Search Juz'),
                onChanged: (juzName) {
                  juzList = searchJuz(juzName);

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
                    'Juz List',
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
                setJuz();
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
          itemCount: juzList.length,
          separatorBuilder: (context, index) {
            return const SizedBox(height: 10);
          },
          itemBuilder: (_, index) {
            final juzNumber = index + 1;

            return GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF23364F).withOpacity(0.1),
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
                      '$juzNumber. ${juzList[index]}',
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
                      return TestByJuz(juzNumber: juzNumber);
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
