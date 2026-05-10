import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/mediaquery_size.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/shape.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_network_image.dart';

class ProductMediaPickerCard extends StatelessWidget {
  const ProductMediaPickerCard({
    super.key,
    required this.images,
    this.initialImageUrls = const [],
    required this.onAddImages,
    required this.onRemoveImage,
  });

  final List<XFile> images;
  final List<String> initialImageUrls;
  final VoidCallback onAddImages;
  final ValueChanged<int> onRemoveImage;

  @override
  Widget build(BuildContext context) {
    final hasImages = images.isNotEmpty || initialImageUrls.isNotEmpty;

    return InkWell(
      onTap: hasImages ? null : onAddImages,
      borderRadius: BorderRadius.circular(Shape.large),
      child: DottedBorder(
        options: RectDottedBorderOptions(
          color: context.colors.primary.withValues(alpha: 0.5),
          strokeCap: StrokeCap.round,
          strokeWidth: 2,
          dashPattern: const [6, 6],
        ),
        child: Container(
          width: context.width,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: context.colors.onPrimary,
            borderRadius: BorderRadius.circular(Shape.large),
          ),
          child: !hasImages
              ? _EmptyState(onAddImages: onAddImages)
              : _ImagesGrid(
                  images: images,
                  initialImageUrls: initialImageUrls,
                  onAddImages: onAddImages,
                  onRemoveImage: onRemoveImage,
                ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onAddImages});

  final VoidCallback onAddImages;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
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
            'Select multiple PNG, JPG, GIF images',
            style: context.typography.regular14.copyWith(
              color: context.colors.onSurfaceVariant.withValues(alpha: 0.6),
            ),
          ),
          const Gap(20),
          FilledButton.icon(
            onPressed: onAddImages,
            icon: const Icon(Icons.add_box_rounded),
            label: const Text('Add images'),
          ),
        ],
      ),
    );
  }
}

class _ImagesGrid extends StatelessWidget {
  const _ImagesGrid({
    required this.images,
    required this.initialImageUrls,
    required this.onAddImages,
    required this.onRemoveImage,
  });

  final List<XFile> images;
  final List<String> initialImageUrls;
  final VoidCallback onAddImages;
  final ValueChanged<int> onRemoveImage;

  @override
  Widget build(BuildContext context) {
    final totalImages = initialImageUrls.length + images.length;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              '$totalImages image${totalImages == 1 ? '' : 's'} selected',
              style: context.typography.bold16.copyWith(
                color: context.colors.onSurface,
              ),
            ),
            const Spacer(),
            IconButton.filledTonal(
              onPressed: onAddImages,
              icon: Icon(
                Icons.add_box_rounded,
                color: context.colors.onPrimary,
              ),
              color: context.colors.onPrimary,
            ),
          ],
        ),
        const Gap(Spacing.extraLarge),
        GridView.builder(
          itemCount: totalImages,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
          ),
          itemBuilder: (context, index) {
            return ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  if (index < initialImageUrls.length)
                    CustomNetworkImage(
                      img: initialImageUrls[index],
                      fit: BoxFit.cover,
                    )
                  else
                    Image.file(
                      File(images[index - initialImageUrls.length].path),
                      fit: BoxFit.cover,
                    ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: InkWell(
                      onTap: () => onRemoveImage(index),
                      borderRadius: BorderRadius.circular(999),
                      child: Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: context.colors.onSurface.withValues(
                            alpha: 0.5,
                          ),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.close,
                          color: context.colors.surface,
                          size: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
