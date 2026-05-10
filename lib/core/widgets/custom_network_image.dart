import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:skeletonizer/skeletonizer.dart';

class CustomNetworkImage extends StatelessWidget {
  const CustomNetworkImage({
    super.key,
    required this.img,
    this.width,
    this.height,
    this.radius = 0,
    this.topStartRadius = 0,
    this.topEndRadius = 0,
    this.bottomStartRadius = 0,
    this.bottomEndRadius = 0,
    this.fit = BoxFit.fill,
  });
  final String img;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double topStartRadius;
  final double topEndRadius;
  final double bottomStartRadius;
  final double bottomEndRadius;
  final double radius;
  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: radius != 0
          ? BorderRadius.circular(radius)
          : BorderRadiusGeometry.directional(
              topStart: Radius.circular(topStartRadius),
              topEnd: Radius.circular(topEndRadius),
              bottomStart: Radius.circular(bottomStartRadius),
              bottomEnd: Radius.circular(bottomEndRadius),
            ),
      child: CachedNetworkImage(
        width: width,
        height: height,
        imageUrl: img,
        fit: fit,
        errorWidget: (_, _, _) => const Icon(Icons.error),
        placeholder: (_, _) => Skeletonizer(
          enabled: true,
          child: Container(
            width: width,
            height: height,
            color: Colors.grey[300],
          ),
        ),
      ),
    );
  }
}
