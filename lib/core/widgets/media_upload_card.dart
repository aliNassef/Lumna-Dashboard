import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';
import 'package:skeletonizer/skeletonizer.dart';

import '../extensions/color_extensions.dart';
import '../extensions/mediaquery_size.dart';
import '../extensions/typography_extension.dart';
import '../translation/locale_keys.g.dart';
import '../utils/shape.dart';

class MediaUploadCard extends StatelessWidget {
  const MediaUploadCard({
    super.key,
    this.isLoading = false,
    this.imageUrl,
  });
  final bool? isLoading;
  final XFile? imageUrl;

  @override
  Widget build(BuildContext context) {
    return DottedBorder(
      options: RectDottedBorderOptions(
        color: context.colors.primary.withValues(alpha: 0.5),
        strokeCap: StrokeCap.round,
        strokeWidth: 2,
        dashPattern: const [6, 6],
      ),
      child: Skeletonizer(
        enabled: isLoading ?? false,
        child: imageUrl != null
            ? Image.file(
                height: 200,
                width: context.width,
                File(imageUrl!.path),
                fit: BoxFit.cover,
              )
            : Container(
                width: context.width,
                padding: const EdgeInsets.symmetric(vertical: 40),
                decoration: BoxDecoration(
                  color: context.colors.onPrimary,
                  borderRadius: BorderRadius.circular(Shape.large),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.add_photo_alternate_outlined,
                      size: 48,
                      color: context.colors.primary.withValues(alpha: 0.5),
                    ),
                    const Gap(16),
                    RichText(
                      text: TextSpan(
                        style: context.typography.regular16.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                        children: [
                          TextSpan(
                            text: LocaleKeys.upload_file.tr(),
                            style: context.typography.bold16.copyWith(
                              color: context.colors.primary,
                            ),
                          ),
                          TextSpan(text: LocaleKeys.or_drag_and_drop.tr()),
                        ],
                      ),
                    ),
                    const Gap(8),
                    Text(
                      LocaleKeys.file_format_info.tr(),
                      style: context.typography.regular14.copyWith(
                        color: context.colors.onSurfaceVariant.withValues(
                          alpha: 0.6,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
