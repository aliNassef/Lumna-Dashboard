import 'package:equatable/equatable.dart';

class SendNotificationRequest extends Equatable {
  const SendNotificationRequest({
    required this.title,
    required this.body,
    this.imageUrl,
    this.targetType = 'broadcast',
    this.targetValue,
  });

  final String title;
  final String body;
  final String? imageUrl;
  final String targetType;
  final String? targetValue;

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'body': body,
      if (imageUrl != null && imageUrl!.isNotEmpty) 'imageUrl': imageUrl,
      if (targetType.isNotEmpty) 'targetType': targetType,
      if (targetValue != null && targetValue!.isNotEmpty)
        'targetValue': targetValue,
    };
  }

  @override
  List<Object?> get props => [title, body, imageUrl, targetType, targetValue];
}
