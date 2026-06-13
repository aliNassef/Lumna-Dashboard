import 'package:equatable/equatable.dart';

class NotificationModel extends Equatable {
  final String id;
  final String title;
  final String body;
  final String? imageUrl;
  final DateTime createdAt;
  final bool isRead;
  final bool isOrderType;

  const NotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.imageUrl,
    required this.createdAt,
    required this.isRead,
    required this.isOrderType,
  });

  @override
  List<Object?> get props {
    return [
      id,
      title,
      body,
      imageUrl,
      createdAt,
      isRead,
      isOrderType,
    ];
  }


  NotificationModel copyWith({
    String? id,
    String? title,
    String? body,
    String? imageUrl,
    DateTime? createdAt,
    bool? isRead,
    bool? isOrderType,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      imageUrl: imageUrl ?? this.imageUrl,
      createdAt: createdAt ?? this.createdAt,
      isRead: isRead ?? this.isRead,
      isOrderType: isOrderType ?? this.isOrderType,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'body': body,
      'image_url': imageUrl,
      'create_at': createdAt.millisecondsSinceEpoch,
      'is_read': isRead,
      'type': isOrderType,
    };
  }

  factory NotificationModel.fromMap(Map<String, dynamic> map) {
    return NotificationModel(
      id: map['id'] as String,
      title: map['title'] as String,
      body: map['body'] as String,
      imageUrl: map['image_url'] != null ? map['image_url'] as String : null,
      createdAt: DateTime.parse(map['created_at'] as String),
      isRead: map['is_read'] as bool,
      isOrderType: map['type'] == 'order',
    );
  }
}


final dummyNotifications = [
                NotificationModel(
                  id: '1',
                  title: 'title',
                  body: 'body',
                  createdAt: DateTime.now(),
                  isRead: false,
                  isOrderType: false,
                ),
                NotificationModel(
                  id: '1',
                  title: 'title',
                  body: 'body',
                  createdAt: DateTime.now(),
                  isRead: false,
                  isOrderType: false,
                ),
                NotificationModel(
                  id: '1',
                  title: 'title',
                  body: 'body',
                  createdAt: DateTime.now(),
                  isRead: false,
                  isOrderType: false,
                ),
              ];