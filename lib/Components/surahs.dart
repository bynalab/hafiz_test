// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:afeez/Api/requests.dart';
import 'package:afeez/Intents/test_page.dart';
import 'package:flutter/material.dart';

class Surah extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Surah();
}

class _Surah extends State<Surah> {
  List surahs = [
    "Al-Faatiha",
    "Al-Baqara",
    "Aal-i-Imraan",
    "An-Nisaa",
    "Al-Maaida",
    "Al-An'aam",
    "Al-A'raaf",
    "Al-Anfaal",
    "At-Tawba",
    "Yunus",
    "Hud",
    "Yusuf",
    "Ar-Ra'd",
    "Ibrahim",
    "Al-Hijr",
    "An-Nahl",
    "Al-Israa",
    "Al-Kahf",
    "Maryam",
    "Taa-Haa",
    "Al-Anbiyaa",
    "Al-Hajj",
    "Al-Muminoon",
    "An-Noor",
    "Al-Furqaan",
    "Ash-Shu'araa",
    "An-Naml",
    "Al-Qasas",
    "Al-Ankaboot",
    "Ar-Room",
    "Luqman",
    "As-Sajda",
    "Al-Ahzaab",
    "Saba",
    "Faatir",
    "Yaseen",
    "As-Saaffaat",
    "Saad",
    "Az-Zumar",
    "Ghafir",
    "Fussilat",
    "Ash-Shura",
    "Az-Zukhruf",
    "Ad-Dukhaan",
    "Al-Jaathiya",
    "Al-Ahqaf",
    "Muhammad",
    "Al-Fath",
    "Al-Hujuraat",
    "Qaaf",
    "Adh-Dhaariyat",
    "At-Tur",
    "An-Najm",
    "Al-Qamar",
    "Ar-Rahmaan",
    "Al-Waaqia",
    "Al-Hadid",
    "Al-Mujaadila",
    "Al-Hashr",
    "Al-Mumtahana",
    "As-Saff",
    "Al-Jumu'a",
    "Al-Munaafiqoon",
    "At-Taghaabun",
    "At-Talaaq",
    "At-Tahrim",
    "Al-Mulk",
    "Al-Qalam",
    "Al-Haaqqa",
    "Al-Ma'aarij",
    "Nooh",
    "Al-Jinn",
    "Al-Muzzammil",
    "Al-Muddaththir",
    "Al-Qiyaama",
    "Al-Insaan",
    "Al-Mursalaat",
    "An-Naba",
    "An-Naazi'aat",
    "Abasa",
    "At-Takwir",
    "Al-Infitaar",
    "Al-Mutaffifin",
    "Al-Inshiqaaq",
    "Al-Burooj",
    "At-Taariq",
    "Al-A'laa",
    "Al-Ghaashiya",
    "Al-Fajr",
    "Al-Balad",
    "Ash-Shams",
    "Al-Lail",
    "Ad-Dhuhaa",
    "Ash-Sharh",
    "At-Tin",
    "Al-Alaq",
    "Al-Qadr",
    "Al-Bayyina",
    "Az-Zalzala",
    "Al-Aadiyaat",
    "Al-Qaari'a",
    "At-Takaathur",
    "Al-Asr",
    "Al-Humaza",
    "Al-Fil",
    "Quraish",
    "Al-Maa'un",
    "Al-Kawthar",
    "Al-Kaafiroon",
    "An-Nasr",
    "Al-Masad",
    "Al-Ikhlaas",
    "Al-Falaq",
    "An-Naas"
  ];

  // _getSurah() async {
  //   print('Fetchng Surahs...');
  //   var res =
  //       await http.get('https://unpkg.com/quran-json@1.0.1/json/surahs.json');
  //   var body = json.decode(res.body);
  //   // print('Done Fetching Surahs');
  //   // for (var i = 0; i < body.length; i++) {
  //   //   print(body[i]['transliteration_en']);
  //   // }

  //   setState(() {
  //     surahs = body;
  //   });
  // }

  @override
  void initState() {
    // this._getSurah();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: surahs.length,
        itemBuilder: (BuildContext context, int index) {
          var sn = index + 1;
          return InkWell(
            child: Card(
              child: Container(
                height: 50,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  '$sn) ${surahs[index]}',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),
                ),
              ),
            ),
            onTap: () {
              // print("Tapped $index");
              Navigator.push(context,
               MaterialPageRoute(builder: (context) => TestPage(verse: null, chapter: index+1,))
              );
            },
          );
        });
  }
}
