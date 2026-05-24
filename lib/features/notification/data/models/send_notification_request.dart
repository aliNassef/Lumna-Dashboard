import 'package:equatable/equatable.dart';

class SendNotificationRequest extends Equatable {
  const SendNotificationRequest({
    required this.title,
    required this.body,
    required this.type,
    this.imageUrl,
  });

  final String title;
  final String body;
  final String type;
  final String? imageUrl;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      'type': type,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'image_url': imageUrl,
    };
  }

  @override
  List<Object?> get props => [title, body, type, imageUrl];
}
