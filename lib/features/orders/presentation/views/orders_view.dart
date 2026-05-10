import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumna_admin/core/di/di.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../core/widgets/custom_app_bar.dart';

import '../../../../core/translation/locale_keys.g.dart';
import '../widgets/orders_view_body.dart';

class OrdersView extends StatelessWidget {
  const OrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: LocaleKeys.orders.tr(),
        showBackButton: false,
        actionPadding: 20,
      ),
      body: BlocProvider(
        create: (context) => injector<OrdersCubit>()..getOrders(),
        child: const SafeArea(
          child: OrdersViewBody(),
        ),
      ),
    );
  }
}
