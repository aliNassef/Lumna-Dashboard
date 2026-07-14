import 'package:flutter_bloc/flutter_bloc.dart';

/// Holds the selected bottom-navbar tab index. Shared source of truth so both
/// the [LazyIndexedStack] and the navbar highlight stay in sync, and so tab
/// children (e.g. the home "View all" button) can switch tabs programmatically.
class LayoutCubit extends Cubit<int> {
  LayoutCubit() : super(0);

  void changeIndex(int index) => emit(index);
}
