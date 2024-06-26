List<String> juzList = _juzList;

void setJuz() => juzList = _juzList;

final _juzList = [
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

List<String> searchJuz(String juzName) {
  if (juzName.trim().isEmpty) {
    return _juzList;
  }

  return _juzList
      .where((juz) => juz.toLowerCase().contains(juzName.toLowerCase()))
      .toList();
}
