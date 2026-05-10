import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import '../../../../core/di/di.dart';
import '../../data/model/category_model.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/utils/spacer.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_form_field.dart';
import '../../../../core/widgets/media_upload_card.dart';

class AddCategoryDialog extends StatefulWidget {
  const AddCategoryDialog({super.key});

  @override
  State<AddCategoryDialog> createState() => _AddCategoryDialogState();
}

class _AddCategoryDialogState extends State<AddCategoryDialog> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: context.colors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(24.0),
      ),
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(Spacing.extraLarge),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Text(
                LocaleKeys.add_category.tr(),
                style: context.typography.bold24.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              const Gap(24),

              // Category Name Field
              _buildLabel(context, LocaleKeys.category_name.tr()),
              const Gap(12),
              CustomTextFormField(
                controller: _nameController,
                hintText: LocaleKeys.category_name_hint.tr(),
              ),
              const Gap(24),

              // Image Upload Section
              _buildLabel(context, LocaleKeys.category_image.tr()),
              const Gap(12),
              GestureDetector(
                onTap: () => context.read<CategoryCubit>().pickImage(),
                child: BlocConsumer<CategoryCubit, CategoryState>(
                  listener: (context, state) {
                    if (state is GetCategoriesLoading) {
                      context.pop();
                    }
                  },
                  buildWhen: (previous, current) =>
                      current is AddCategoryLoading ||
                      current is AddCategoryFailure ||
                      current is CategoryImagePicked,
                  builder: (context, state) {
                    return switch (state) {
                      AddCategoryLoading() => const MediaUploadCard(
                        isLoading: true,
                      ),
                      AddCategoryFailure() => const MediaUploadCard(
                        isLoading: false,
                      ),
                      AddCategoryLoaded() => const MediaUploadCard(
                        isLoading: false,
                      ),
                      CategoryImagePicked(:final imageFile) => MediaUploadCard(
                        isLoading: false,
                        imageUrl: imageFile,
                      ),
                      _ => const MediaUploadCard(isLoading: false),
                    };
                  },
                ),
              ),
              const Gap(32),

              // Action Buttons
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => context.pop(),
                      child: Text(
                        LocaleKeys.cancel.tr(),
                        style: context.typography.bold16.copyWith(
                          color: context.colors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const Gap(16),
                  Expanded(
                    flex: 2,
                    child: CustomButton(
                      text: LocaleKeys.create.tr(),
                      onPressed: () {
                        final category = CategoryModel(
                          name: _nameController.text.trim(),
                          imageUrl: '',
                          productCount: 0,
                        );
                        context.read<CategoryCubit>().addCategory(category);
                      },
                      backgroundColor: context.colors.primary,
                      textColor: context.colors.onPrimary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(BuildContext context, String text) {
    return Text(
      text,
      style: context.typography.bold16.copyWith(
        color: context.colors.onSurface.withValues(alpha: 0.8),
      ),
    );
  }
}
