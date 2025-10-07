import 'package:flutter/material.dart';
import 'package:hafiz_test/services/notification_service.dart';

class NotificationSettingsScreen extends StatefulWidget {
  const NotificationSettingsScreen({super.key});

  @override
  State<NotificationSettingsScreen> createState() =>
      _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState
    extends State<NotificationSettingsScreen> {
  bool _isLoading = true;
  bool _notificationsEnabled = true;
  TimeOfDay _notificationTime = const TimeOfDay(hour: 8, minute: 0);

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      final settings = await NotificationService.getNotificationSettings();
      setState(() {
        _notificationsEnabled = settings['enabled'] ?? true;
        _notificationTime = TimeOfDay(
          hour: settings['hour'] ?? 8,
          minute: settings['minute'] ?? 0,
        );
      });
    } catch (e) {
      // Handle error silently
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _notificationTime,
    );
    if (picked != null && picked != _notificationTime) {
      setState(() {
        _notificationTime = picked;
      });
      await _saveSettings();
    }
  }

  Future<void> _saveSettings() async {
    try {
      await NotificationService.rescheduleNotificationsWithNewTime(
        enabled: _notificationsEnabled,
        hour: _notificationTime.hour,
        minute: _notificationTime.minute,
      );
    } catch (e) {
      // Handle error silently
    }
  }

  Future<void> _toggleNotifications(bool value) async {
    setState(() {
      _notificationsEnabled = value;
    });
    await _saveSettings();
  }

  Future<void> _sendTestNotification() async {
    try {
      await NotificationService.sendTestNotification();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('Test notification sent! Check your notification panel.'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error sending test notification: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notification Settings'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Notification Toggle
                  Card(
                    child: SwitchListTile(
                      title: const Text('Enable Daily Notifications'),
                      subtitle:
                          const Text('Receive motivational messages daily'),
                      value: _notificationsEnabled,
                      onChanged: _toggleNotifications,
                      secondary: const Icon(Icons.notifications),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Time Selection
                  Card(
                    child: ListTile(
                      leading: const Icon(Icons.access_time),
                      title: const Text('Notification Time'),
                      subtitle: Text(_notificationsEnabled
                          ? _notificationTime.format(context)
                          : 'Enable notifications to set time'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: _notificationsEnabled ? _selectTime : null,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Information Card
                  Card(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.grey.shade800
                        : Colors.grey.shade100,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.info_outline,
                                color: Theme.of(context).brightness ==
                                        Brightness.dark
                                    ? Colors.blue.shade300
                                    : Colors.blue.shade700,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Daily Motivational Notifications',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Theme.of(context).brightness ==
                                          Brightness.dark
                                      ? Colors.grey.shade300
                                      : Colors.grey.shade700,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'You will receive daily motivational messages to encourage your Quran memorization journey. These notifications help maintain consistency and provide spiritual encouragement.',
                            style: TextStyle(
                              color: Theme.of(context).brightness ==
                                      Brightness.dark
                                  ? Colors.grey.shade300
                                  : Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Test Notification Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton.icon(
                      onPressed: _sendTestNotification,
                      icon: const Icon(Icons.notifications_active),
                      label: const Text('Send Test Notification'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24), // Extra bottom padding
                ],
              ),
            ),
    );
  }
}
