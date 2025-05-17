class FCMToken {
  final int? id;
  final String token;
  final String userEmail;
  final int? userId;

  FCMToken({
    this.id,
    required this.token,
    required this.userEmail,
    this.userId,
  });

  factory FCMToken.fromJson(Map<String, dynamic> json) {
    return FCMToken(
      id: json['id'],
      token: json['token'],
      userEmail: json['user_email'],
      userId: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'token': token,
      'user_email': userEmail,
      'user': userId,
    };
  }
}

class NotificationItem {
  final int? id;
  final String title;
  final String body;
  final DateTime timestamp;
  final int? userId;

  NotificationItem({
    this.id,
    required this.title,
    required this.body,
    required this.timestamp,
    this.userId,
  });

  factory NotificationItem.fromJson(Map<String, dynamic> json) {
    return NotificationItem(
      id: json['id'],
      title: json['title'],
      body: json['body'],
      timestamp: DateTime.parse(json['timestamp']),
      userId: json['user'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'body': body,
      'timestamp': timestamp.toIso8601String(),
      'user': userId,
    };
  }
}
