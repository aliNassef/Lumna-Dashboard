import 'nav_animation_enum.dart';

class NavArgs {
  final Object? data;
  final NavAnimation animation;
  final Duration duration;

  const NavArgs({
    this.data,
    this.animation = NavAnimation.none,
    this.duration = const Duration(milliseconds: 300),
  });
}
