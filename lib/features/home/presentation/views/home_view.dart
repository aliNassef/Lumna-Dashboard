import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';

import '../../../orders/presentation/controller/orders_cubit/orders_cubit.dart';
import '../controller/statistics_cubit/statistics_cubit.dart';
import '../widgets/home_view_body.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) =>
              injector<StatisticsCubit>()..getDashboardSummary(),
        ),
        BlocProvider(
          create: (context) => injector<OrdersCubit>()..getRecentOrders(),
        ),
      ],
      child: const Scaffold(
        body: SafeArea(
          child: HomeViewBody(),
        ),
      ),
    );
  }
}
