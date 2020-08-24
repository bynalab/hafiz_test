// import 'dart:convert';
// import 'package:http/http.dart' as http;
// import 'package:afeez/Api/requests.dart';
import 'dart:convert';

import 'package:afeez/Api/requests.dart';
import 'package:afeez/Intents/test_page.dart';
import 'package:flutter/material.dart';

class Juz extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Juz();
}

class _Juz extends State<Juz> {
  List juz = [
    "Alīf-Lām-Mīm",
    "Sayaqūlu",
    "Tilka ’r-Rusulu",
    "Kullu-TTa`āmi",
    "Wa’l-muḥṣanātu",
    "Lā yuḥibbu-’llāhu",
    "Wa ’Idha Samiʿū",
    "Wa-law annanā",
    "Qāla ’l-mala’u",
    "Wa-’aʿlamū",
    "Yaʿtazerūn",
    "Wa mā min dābbatin",
    "Wa mā ubarri’u",
    "Alīf-Lām-Rā’/ Rubamā",
    "Subḥāna ’lladhī",
    "Qāla ’alam",
    "Iqtaraba li’n-nāsi",
    "Qad ’aflaḥa",
    "Wa-qāla ’lladhīna",
    "’A’man Khalaqa",
    "Wa la tujādilū",
    "Wa-man yaqnut",
    "Wa-Mali",
    "Fa-man ’aẓlamu",
    "Ilayhi yuraddu",
    "Ḥā’ Mīm",
    "Qāla fa-mā khaṭbukum",
    "Qad samiʿa ’llāhu",
    "Tabāraka ’lladhī",
    "Amma"
  ];

  _getJuz(juz) async {
    print('Fetching...');
    var res = await RequestResources().getResources('juz/$juz/quran-uthmani');
    var body = json.decode(res.body);

    print(body['data']['ayahs'][0]['surah']['number']);
    print('Fetched');
  }

  @override
  void initState() {
    // _getJuz();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: juz.length,
        itemBuilder: (BuildContext context, int index) {
          var sn = index + 1;
          return InkWell(
            child: Card(
              child: Container(
                height: 50,
                padding: EdgeInsets.all(10.0),
                child: Text(
                  '$sn) ${juz[index]}',
                  style: TextStyle(color: Colors.blueGrey, fontSize: 20.0),
                ),
              ),
            ),
            onTap: () {
              print("Tapped $index");
              _getJuz(sn);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => TestPage(
                            verse: sn,
                            chapter: null,
                          )));
            },
          );
        });
  }
}
