import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../core/extensions/app_dialog_extension.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/navigation/app_navigation.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../controller/offer_cubit/offer_cubit.dart';

abstract class OfferFormSideEffects {
  static void listen(BuildContext context, OfferState state) {
    if (state.status.isSaveSuccess) {
      context.pop();
      context.showToast(
        text: LocaleKeys.offer_saved.tr(),
        backgroundColor: Colors.green,
      );
    }
    if (state.status.isSaveFailure && state.failure != null) {
      context.showToast(
        text: state.failure!.errMessage,
        backgroundColor: context.colors.error,
      );
    }
  }
}
