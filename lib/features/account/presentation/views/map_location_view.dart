import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lumna_admin/core/di/injection_container.dart';
import 'package:lumna_admin/features/account/presentation/controller/address_cubit/address_cubit.dart';

import '../widgets/map_location_view_body.dart';

class MapLocationView extends StatelessWidget {
  const MapLocationView({super.key});
  static const String routeName = 'map_view';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: BlocProvider(
          create: (context) =>
              injector<AddressCubit>()..getCurrentUserPosition(),
          child: const MapLocationViewBody(),
        ),
      ),
    );
  }
}
