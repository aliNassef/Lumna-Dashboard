part of 'category_cubit.dart';

sealed class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

final class CategoryInitial extends CategoryState {}

final class GetCategoriesLoading extends CategoryState {}

final class GetCategoriesLoaded extends CategoryState {
  final List<CategoryModel> categories;

  const GetCategoriesLoaded({required this.categories});

  @override
  List<Object?> get props => [categories];
}

final class GetCategoriesError extends CategoryState {
  final Failure failure;

  const GetCategoriesError({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class AddCategoryLoading extends CategoryState {}

final class AddCategoryLoaded extends CategoryState {
  const AddCategoryLoaded();
}

final class AddCategoryFailure extends CategoryState {
  final Failure failure;

  const AddCategoryFailure({required this.failure});

  @override
  List<Object?> get props => [failure];
}

final class CategoryImagePicked extends CategoryState {
  final XFile imageFile;

  const CategoryImagePicked({required this.imageFile});

  @override
  List<Object?> get props => [imageFile];
}
