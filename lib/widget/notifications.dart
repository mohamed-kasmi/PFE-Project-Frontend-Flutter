import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../api/apinotification.dart';
import '../models/notification.dart';

class NotificationIcon extends StatefulWidget {
  final String userEmail;
  const NotificationIcon({super.key, required this.userEmail});

  @override
  State<NotificationIcon> createState() => _NotificationIconState();
}

class _NotificationIconState extends State<NotificationIcon> {
  bool hasNewNotifications = false;
  List<NotificationItem> notifications = [];
  final GlobalKey _menuKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  Timer? _pollingTimer;
  int lastSeenNotificationId = 0;

  @override
  void initState() {
    super.initState();
    _loadLastSeenId();
    loadNotifications();
    _pollingTimer = Timer.periodic(const Duration(seconds: 30), (_) {
      loadNotifications();
    });
  }

  Future<void> _loadLastSeenId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    lastSeenNotificationId = prefs.getInt('lastSeenNotificationId') ?? 0;
  }

  Future<void> _updateLastSeenId(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('lastSeenNotificationId', id);
    lastSeenNotificationId = id;
  }

  Future<void> loadNotifications() async {
    final fetchedNotifications = await ApiNotification.getnotifications(widget.userEmail);

    int maxFetchedId = 0;
    if (fetchedNotifications.isNotEmpty) {
      maxFetchedId = fetchedNotifications
          .map((n) => int.tryParse(n.id.toString()) ?? 0)
          .reduce((a, b) => a > b ? a : b);
    }

    setState(() {
      notifications = fetchedNotifications;
      hasNewNotifications = maxFetchedId > lastSeenNotificationId;
    });
  }

  String formatTimeDifference(DateTime timestamp) {
    final now = DateTime.now();
    final difference = now.difference(timestamp);

    if (difference.inMinutes < 1) return "Just now";
    if (difference.inMinutes < 60) return "${difference.inMinutes} min ago";
    if (difference.inHours < 24) return "${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago";
    return "${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago";
  }

  void _toggleOverlay(BuildContext context) {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
      return;
    }

    // Mark all as seen using max ID
    final maxSeenId = notifications
        .map((n) => int.tryParse(n.id.toString()) ?? 0)
        .fold(0, (a, b) => a > b ? a : b);
    _updateLastSeenId(maxSeenId);

    setState(() {
      hasNewNotifications = false;
    });

    final renderBox = _menuKey.currentContext!.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenHeight = MediaQuery.of(context).size.height;

    _overlayEntry = OverlayEntry(
      builder: (_) => GestureDetector(
        onTap: () {
          _overlayEntry?.remove();
          _overlayEntry = null;
        },
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned(
              top: offset.dy + 50,
              right: 16,
              width: 350,
              height: screenHeight * 0.6,
              child: Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Notifications',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              _overlayEntry?.remove();
                              _overlayEntry = null;
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      if (notifications.isNotEmpty)
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _clearAllNotifications,
                            child: const Text("Clear All"),
                          ),
                        ),
                      Expanded(
                        child: notifications.isEmpty
                            ? const Center(child: Text("No new notifications"))
                            : ListView.builder(
                          itemCount: notifications.length,
                          itemBuilder: (context, index) {
                            final notification = notifications[index];
                            return Card(
                              color: Colors.grey[200],
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(8.0),
                                title: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        notification.title,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red, size: 20),
                                      onPressed: () =>
                                          _deleteNotification(index),
                                    ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(notification.body),
                                    const SizedBox(height: 4),
                                    Text(
                                      formatTimeDifference(
                                          notification.timestamp),
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    Overlay.of(context).insert(_overlayEntry!);
  }

  void _deleteNotification(int index) async {
    final removedNotification = notifications[index];
    bool success = await ApiNotification
        .deletenotification(removedNotification.id.toString());

    if (success) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      await loadNotifications();
      _toggleOverlay(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete notification')),
      );
    }
  }

  void _clearAllNotifications() async {
    bool success = await ApiNotification.deleteAll(widget.userEmail);

    if (success) {
      _overlayEntry?.remove();
      _overlayEntry = null;
      await loadNotifications();
      _toggleOverlay(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to clear notifications')),
      );
    }
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      key: _menuKey,
      onTap: () => _toggleOverlay(context),
      child: Stack(
        alignment: Alignment.topRight,
        children: [
          const Icon(Icons.notifications, size: 28, color: Colors.white),
          if (hasNewNotifications)
            Positioned(
              right: 0,
              top: 2,
              child: Container(
                width: 10,
                height: 10,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
