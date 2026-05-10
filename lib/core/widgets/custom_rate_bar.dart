import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../extensions/color_extensions.dart';

class CustomRateBar extends StatefulWidget {
  const CustomRateBar({
    super.key,
    required this.rate,
    this.size = 24,
    this.padding,
    this.readOnly = true,
    this.onRatingUpdate,
  });
  final double rate;
  final double size;
  final double? padding;
  final bool readOnly;
  final ValueChanged<double>? onRatingUpdate;

  @override
  State<CustomRateBar> createState() => _CustomRateBarState();
}

class _CustomRateBarState extends State<CustomRateBar> {
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: widget.rate,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: false,
      itemCount: 5,
      itemSize: widget.size.sp,
      itemPadding: EdgeInsets.symmetric(horizontal: widget.padding ?? 4.0),
      itemBuilder: (context, _) => Icon(
        CupertinoIcons.star_fill,
        color: context.colors.secondary,
      ),
      unratedColor: context.colors.outline,
      onRatingUpdate: widget.readOnly
          ? (_) {}
          : (rate) {
              setState(() {});
              widget.onRatingUpdate?.call(rate);
            },
    );
  }
}
