import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:lumna_admin/core/di/injection_container.dart';
import '../../../account/presentation/controller/account_cubit/account_cubit.dart';
import '../../../account/presentation/views/account_view.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../orders/presentation/views/orders_view.dart';
import '../../../products/presentation/views/products_view.dart';
import '../widgets/bottom_nav_bar_items.dart';

class LayoutView extends StatefulWidget {
  const LayoutView({super.key});
  static const String routeName = 'layout';

  @override
  State<LayoutView> createState() => _LayoutViewState();
}

class _LayoutViewState extends State<LayoutView> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const HomeView(),
    const ProductsView(),
    const OrdersView(),
    const AccountView(),
  ];
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<AccountCubit>()..getCurrentProfile(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: LazyIndexedStack(
            index: _currentIndex,
            children: _screens,
          ),
        ),
        floatingActionButton: BottomNavBarItems(
          onChanged: (index) => setState(() => _currentIndex = index),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      ),
    );
  }
}
