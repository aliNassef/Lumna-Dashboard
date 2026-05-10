import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/di/injection_container.dart';

import '../controller/category_cubit/category_cubit.dart';
import '../widgets/manage_category_view_body.dart';

class ManageCategoryView extends StatelessWidget {
  const ManageCategoryView({super.key});
  static const String routeName = 'manage-category';
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => injector<CategoryCubit>()..getCategories(),
      child: const Scaffold(
        body: SafeArea(child: ManageCategoryViewBody()),
      ),
    );
  }
}
