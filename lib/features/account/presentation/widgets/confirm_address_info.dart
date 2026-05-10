import 'package:easy_localization/easy_localization.dart';
import 'package:lumna_admin/core/extensions/app_dialog_extension.dart';
import 'package:lumna_admin/core/translation/locale_keys.g.dart';
import 'package:lumna_admin/features/account/data/models/location_model.dart';

import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';

import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/extensions/typography_extension.dart';
import '../../../../core/utils/spacer.dart';
import '../controller/address_cubit/address_cubit.dart';

class ConfirmAddressInfo extends StatelessWidget {
  const ConfirmAddressInfo({super.key});



  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AddressCubit, AddressState>(
      buildWhen: (previous, current) =>
          current is GetMarkerAddressLoading ||
          current is GetMarkerAddressSuccess ||
          current is GetMarkerAddressFailure,
      builder: (context, state) {
        if (state is GetMarkerAddressLoading) {
          return _CardShell(
            child: Row(
              children: [
                SizedBox.square(
                  dimension: 18,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: context.colors.primary,
                  ),
                ),
                const SizedBox(width: Spacing.large),
                Text(
                  LocaleKeys.loading_address.tr(),
                  style: context.typography.medium14.copyWith(
                    color: context.colors.onSurface,
                  ),
                ),
              ],
            ),
          );
        }

        if (state is GetMarkerAddressFailure) {
          return _CardShell(
            child: Text(
              state.failure.errMessage,
              style: context.typography.medium14.copyWith(
                color: context.colors.error,
              ),
            ),
          );
        }

        if (state is! GetMarkerAddressSuccess) {
          return const SizedBox.shrink();
        }

        final place = state.place;
        return _CardShell(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _valueOrFallback(place.street),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: context.typography.bold16.copyWith(
                  color: context.colors.onSurface,
                ),
              ),
              const SizedBox(height: Spacing.medium),
              Wrap(
                spacing: Spacing.large,
                runSpacing: Spacing.medium,
                children: [
                  _AddressInfoItem(label: LocaleKeys.address_city.tr(), value: place.city),
                  _AddressInfoItem(label: LocaleKeys.address_country.tr(), value: place.country),
                  _AddressInfoItem(label: LocaleKeys.address_zip_code.tr(), value: place.zip),
                ],
              ),
              const Gap(Spacing.medium),
              BlocListener<AddressCubit, AddressState>(
                listener: (context, state) {
                  if (state is AddStoreLocationSuccess) {
                    context.showToast(
                      text: LocaleKeys.add_store_location_msg.tr(),
                      backgroundColor: context.colors.primary,
                    );
                    context.pop();
                  }
                  if (state is AddStoreLocationFailure) {
                    context.showToast(
                      text: state.failure.errMessage,
                      backgroundColor: context.colors.error,
                    );
                    context.pop();
                  }
                  if (state is AddStoreLocationLoading) {
                    context.showLoadingBox();
                  }
                },
                child: CustomButton(
                  text: LocaleKeys.confirm.tr(),
                  onPressed: () {
                    context.read<AddressCubit>().addStoreLocation(
                      LocationModel(storeLng: place.lng, storeLat: place.lat),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  static String _valueOrFallback(String? value) {
    final trimmed = value?.trim();
    return trimmed == null || trimmed.isEmpty ? LocaleKeys.not_available.tr() : trimmed;
  }
}

class _CardShell extends StatelessWidget {
  const _CardShell({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.all(Spacing.extraLarge),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(Spacing.extraLarge),
        decoration: BoxDecoration(
          color: context.colors.onPrimary,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: context.colors.outline),
          boxShadow: [
            BoxShadow(
              color: context.colors.shadow.withValues(alpha: 0.12),
              blurRadius: 18,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

class _AddressInfoItem extends StatelessWidget {
  const _AddressInfoItem({
    required this.label,
    required this.value,
  });

  final String label;
  final String? value;

  @override
  Widget build(BuildContext context) {
    final displayValue = ConfirmAddressInfo._valueOrFallback(value);
    return ConstrainedBox(
      constraints: const BoxConstraints(minWidth: 96),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: context.typography.regular12.copyWith(
              color: context.colors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: Spacing.small),
          Text(
            displayValue,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: context.typography.semiBold12.copyWith(
              color: context.colors.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
