import 'package:flutter/material.dart';
import 'package:hafiz_test/services/storage.services.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  bool autoPlay = true;
  bool isLoading = true;
  final storageServices = StorageServices();

  Future<void> init() async {
    autoPlay = await storageServices.checkAutoPlay();

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
      title: const Text(
        'Settings',
        style: TextStyle(
          color: Colors.blueGrey,
          fontSize: 15,
          fontWeight: FontWeight.bold,
        ),
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
                const Text(
                  'Autoplay verse',
                  style: TextStyle(fontSize: 12),
                ),
                Switch(
                  value: autoPlay,
                  onChanged: (_) {
                    setState(() => autoPlay = !autoPlay);
                  },
                  activeTrackColor: Colors.blueGrey,
                  activeColor: Colors.green,
                )
              ],
            )
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () {
            storageServices.setAutoPlay(autoPlay);
            Navigator.of(context).pop(true);
          },
          child: const Text('Save'),
        ),
      ],
    );
  }
}
