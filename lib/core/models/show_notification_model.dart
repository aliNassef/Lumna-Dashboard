import 'package:equatable/equatable.dart';

class ShowNotificationModel extends Equatable {
  const ShowNotificationModel({
    required this.id,
    required this.title,
    required this.body,
    this.payload,
  });

  final int id;

  final String title;

  final String body;

  final String? payload;

  ShowNotificationModel copyWith({
    int? id,
    String? title,
    String? body,
    String? payload,
  }) {
    return ShowNotificationModel(
      id: id ?? this.id,
      title: title ?? this.title,
      body: body ?? this.body,
      payload: payload ?? this.payload,
    );
  }

  @override
  List<Object?> get props => [id, title, body, payload];
}
