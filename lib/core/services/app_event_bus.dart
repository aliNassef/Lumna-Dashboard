import 'dart:async';

/// A lightweight app-wide event bus for cross-feature communication.
class AppEventBus {
  final StreamController<Object> _controller = StreamController<Object>.broadcast();

  Stream<T> on<T>() => _controller.stream.where((event) => event is T).cast<T>();

  void fire(Object event) => _controller.add(event);

  Future<void> dispose() => _controller.close();
}

class UserLoggedOutEvent {
  const UserLoggedOutEvent({required this.userId});

  final String userId;
}
