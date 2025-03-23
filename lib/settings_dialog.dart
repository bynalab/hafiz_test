import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/data/reciters.dart';
import 'package:hafiz_test/model/reciter.model.dart';
import 'package:hafiz_test/services/storage.services.dart';
import 'package:hafiz_test/widget/button.dart';
import 'package:collection/collection.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  bool autoPlay = true;
  bool isLoading = true;

  String? reciter;

  Future<void> init() async {
    autoPlay = await StorageServices.getInstance.checkAutoPlay();
    reciter = await StorageServices.getInstance.getReciter();

    isLoading = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      contentPadding: const EdgeInsets.all(16),
      titlePadding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Settings',
            style: GoogleFonts.montserrat(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF222222),
            ),
          ),
          GestureDetector(
            child: const Icon(
              Icons.close,
              size: 30,
              color: Color(0xFF626262),
            ),
            onTap: () => Navigator.pop(context),
          )
        ],
      ),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isLoading)
            const Center(child: CircularProgressIndicator.adaptive())
          else
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Autoplay verse',
                  style: GoogleFonts.montserrat(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF222222),
                  ),
                ),
                Switch(
                  value: autoPlay,
                  onChanged: (_) {
                    setState(() => autoPlay = !autoPlay);
                  },
                  activeTrackColor: const Color(0xFF004B40),
                  activeColor: Colors.white,
                )
              ],
            ),
          const SizedBox(height: 30),
          DropdownButton<Reciter>(
            value: reciters.firstWhereOrNull(
              (reciter) => reciter.identifier == this.reciter,
            ),
            hint: Text("Select an option"),
            items: reciters.map((reciter) {
              return DropdownMenuItem<Reciter>(
                value: reciter,
                child: Text(reciter.englishName),
              );
            }).toList(),
            onChanged: (reciter) {
              setState(() {
                this.reciter = reciter?.identifier;
              });
            },
          ),
          const SizedBox(height: 30),
          Button(
            height: 36,
            color: const Color(0xFF004B40),
            child: Text(
              'Save',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
            onPressed: () {
              StorageServices.getInstance.setAutoPlay(autoPlay);
              StorageServices.getInstance.setReciter(reciter ?? '');
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
