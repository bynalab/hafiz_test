import 'package:flutter/material.dart';
import 'package:hafiz_test/services/rating_service.dart';

class RatingDebugDialog extends StatefulWidget {
  const RatingDebugDialog({super.key});

  @override
  State<RatingDebugDialog> createState() => _RatingDebugDialogState();
}

class _RatingDebugDialogState extends State<RatingDebugDialog> {
  Map<String, int> stats = {};

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final currentStats = await RatingService.getEngagementStats();
    setState(() {
      stats = currentStats;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Rating System Debug'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Test Sessions: ${stats['testSessions'] ?? 0}'),
          Text('Surahs Listened: ${stats['surahsListened'] ?? 0}'),
          Text('Days Since Launch: ${stats['daysSinceLaunch'] ?? 0}'),
          Text('Rating Requests: ${stats['ratingRequests'] ?? 0}'),
          Text('Has Rated: ${stats['hasRated'] == 1 ? 'Yes' : 'No'}'),
          const SizedBox(height: 16),
          const Text('Actions:', style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () async {
            await RatingService.trackTestSessionCompleted();
            await _loadStats();
          },
          child: const Text('+1 Test Session'),
        ),
        TextButton(
          onPressed: () async {
            await RatingService.trackSurahListened();
            await _loadStats();
          },
          child: const Text('+1 Surah Listened'),
        ),
        TextButton(
          onPressed: () async {
            if (await RatingService.shouldShowRatingDialog()) {
              await RatingService.showRatingDialog(context);
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                    content: Text('Rating dialog conditions not met')),
              );
            }
          },
          child: const Text('Test Rating Dialog'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    );
  }
}
