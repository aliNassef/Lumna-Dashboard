import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_lazy_indexed_stack/flutter_lazy_indexed_stack.dart';
import 'package:lumna_admin/core/di/injection_container.dart';
import '../../../../core/translation/locale_keys.g.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/utils/spacer.dart';
import '../../../account/presentation/controller/account_cubit/account_cubit.dart';
import '../../../account/presentation/views/account_view.dart';
import '../../../home/presentation/views/home_view.dart';
import '../../../notification/presentation/controller/get_unreaded_count_cubit/get_un_readed_count_cubit.dart';
import '../../../notification/presentation/widgets/notification_bell_icon.dart';
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
  final bool _canPop = false;
  DateTime? _lastBackPress;
  final List<Widget> _screens = [
    const HomeView(),
    const ProductsView(),
    const OrdersView(),
    const AccountView(),
  ];

  @override
  void initState() {
    super.initState();
    context.read<AccountCubit>().getCurrentProfile();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _canPop,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        if (_lastBackPress != null &&
            DateTime.now().difference(_lastBackPress!) <
                const Duration(seconds: 2)) {
          SystemNavigator.pop();
        } else {
          _lastBackPress = DateTime.now();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(LocaleKeys.press_again_to_exit.tr()),
              behavior: SnackBarBehavior.floating,
              elevation: 0,
              backgroundColor: context.colors.error,
              duration: const Duration(seconds: 2),
            ),
          );
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Stack(
            children: [
              LazyIndexedStack(
                index: _currentIndex,
                children: _screens,
              ),
              Positioned(
                top: Spacing.large,
                right: Spacing.extraLarge,
                child: BlocProvider(
                  create: (context) => injector<GetUnReadedCountCubit>()..getUnReadedCount(),
                  child: const NotificationBellIcon(),
                ),
              ),
            ],
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
