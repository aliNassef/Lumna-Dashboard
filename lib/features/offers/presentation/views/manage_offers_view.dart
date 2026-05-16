import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/injection_container.dart';
import '../controller/offer_cubit/offer_cubit.dart';
import '../widgets/manage_offers_view_body.dart';

class ManageOffersView extends StatelessWidget {
  const ManageOffersView({super.key});
  static const String routeName = 'manage-offers';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<OfferCubit>()..getOffersData(),

      child: const Scaffold(
        body: SafeArea(child: ManageOffersViewBody()),
      ),
    );
  }
}
