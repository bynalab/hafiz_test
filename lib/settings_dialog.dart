import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hafiz_test/data/reciters.dart';
import 'package:hafiz_test/extension/collection.dart';
import 'package:hafiz_test/locator.dart';
import 'package:hafiz_test/model/reciter.model.dart';
import 'package:hafiz_test/services/storage/abstract_storage_service.dart';
import 'package:hafiz_test/services/analytics_service.dart';
import 'package:hafiz_test/widget/button.dart';
import 'package:hafiz_test/util/theme_controller.dart';
import 'package:hafiz_test/util/rating_debug.dart';
import 'package:hafiz_test/notification_settings_screen.dart';

class SettingDialog extends StatefulWidget {
  const SettingDialog({super.key});

  @override
  State<SettingDialog> createState() => _SettingDialogState();
}

class _SettingDialogState extends State<SettingDialog> {
  final storageServices = getIt<IStorageService>();
  final themeController = getIt<ThemeController>();

  bool autoPlay = true;
  bool isLoading = true;

  String? reciter;
  late ThemeMode themeMode;

  void init() {
    try {
      autoPlay = storageServices.checkAutoPlay();
      reciter = storageServices.getReciter();
      themeMode = ThemeMode.values.byName(themeController.mode);
    } catch (e) {
      debugPrint('Error $e');
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  void initState() {
    super.initState();

    // Track settings dialog opened
    AnalyticsService.trackScreenView('Settings Dialog');

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
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          GestureDetector(
            child: Icon(
              Icons.close,
              size: 30,
              color: Theme.of(context)
                  .colorScheme
                  .onSurface
                  .withValues(alpha: 0.7),
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
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Autoplay verse',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    Switch(
                      value: autoPlay,
                      onChanged: (_) {
                        final oldValue = autoPlay;
                        setState(() => autoPlay = !autoPlay);
                        AnalyticsService.trackSettingsChanged(
                            'autoplay', oldValue, !oldValue);
                      },
                      activeTrackColor: Theme.of(context).colorScheme.primary,
                      activeColor: Colors.white,
                    )
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Theme',
                      style: GoogleFonts.montserrat(
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                    ),
                    DropdownButton<ThemeMode>(
                      value: themeMode,
                      items: const [
                        DropdownMenuItem(
                          value: ThemeMode.system,
                          child: Text('System'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.light,
                          child: Text('Light'),
                        ),
                        DropdownMenuItem(
                          value: ThemeMode.dark,
                          child: Text('Dark'),
                        ),
                      ],
                      onChanged: (mode) {
                        if (mode == null) return;
                        final oldValue = themeMode;
                        setState(() => themeMode = mode);
                        AnalyticsService.trackSettingsChanged(
                            'theme', oldValue.name, mode.name);
                      },
                    )
                  ],
                ),
              ],
            ),
          const SizedBox(height: 30),
          Text(
            'Select your favorite reciter',
            style: GoogleFonts.montserrat(
              fontWeight: FontWeight.w500,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
          DropdownButton<Reciter>(
            value: reciters.firstWhereOrNull(
              (reciter) => reciter.identifier == this.reciter,
            ),
            hint: Text('Select your favorite reciter'),
            items: reciters.map((reciter) {
              return DropdownMenuItem<Reciter>(
                value: reciter,
                child: Text(reciter.englishName),
              );
            }).toList(),
            onChanged: (reciter) {
              final oldValue = this.reciter;
              setState(() {
                this.reciter = reciter?.identifier;
              });
              AnalyticsService.trackSettingsChanged(
                  'reciter', oldValue, reciter?.identifier);
            },
          ),
          const SizedBox(height: 20),
          Button(
            height: 36,
            color: Colors.blue.shade600,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.notifications_active,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 8),
                Text(
                  'Notification Settings',
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
            onPressed: () {
              AnalyticsService.trackEvent('Notification Settings Opened');
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const NotificationSettingsScreen(),
                ),
              );
            },
          ),
          const SizedBox(height: 20),
          // Button(
          //   height: 36,
          //   color: Colors.green.shade600,
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     children: [
          //       const Icon(
          //         Icons.notifications_active,
          //         color: Colors.white,
          //         size: 20,
          //       ),
          //       const SizedBox(width: 8),
          //       Text(
          //         'Test Notification',
          //         style: GoogleFonts.montserrat(
          //           fontSize: 16,
          //           fontWeight: FontWeight.w600,
          //           color: Colors.white,
          //         ),
          //       ),
          //     ],
          //   ),
          //   onPressed: () async {
          //     AnalyticsService.trackEvent('Test Notification Sent');
          //     try {
          //       await NotificationService.sendTestNotification();

          //       if (!context.mounted) return;
          //       if (mounted) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           const SnackBar(
          //             content: Text(
          //                 'Test notification sent! Check your notification panel.'),
          //             backgroundColor: Colors.green,
          //           ),
          //         );
          //       }
          //     } catch (e) {
          //       if (mounted) {
          //         ScaffoldMessenger.of(context).showSnackBar(
          //           SnackBar(
          //             content: Text('Error sending test notification: $e'),
          //             backgroundColor: Colors.red,
          //           ),
          //         );
          //       }
          //     }
          //   },
          // ),
          const SizedBox(height: 20),
          if (kDebugMode) ...[
            // Debug button for rating system (remove in production)
            Button(
              height: 32,
              color: Colors.orange,
              child: Text(
                'Debug Rating System',
                style: GoogleFonts.montserrat(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
                showDialog(
                  context: context,
                  builder: (_) => const RatingDebugDialog(),
                );
              },
            ),
            const SizedBox(height: 10),
          ],
          Button(
            height: 36,
            color: Theme.of(context).colorScheme.primary,
            child: Text(
              'Save',
              style: GoogleFonts.montserrat(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
            onPressed: () {
              AnalyticsService.trackEvent('Settings Saved', properties: {
                'autoplay': autoPlay,
                'theme': themeMode.name,
                'reciter': reciter ?? 'none',
              });
              storageServices.setAutoPlay(autoPlay);
              storageServices.setReciter(reciter ?? '');
              themeController.setMode(themeMode.name);
              Navigator.pop(context);
            },
          )
        ],
      ),
    );
  }
}
