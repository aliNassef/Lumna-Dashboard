import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../core/constants/storage_paths.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/logging/logger.dart';
import '../../../../../core/exceptions/failure.dart';
import '../../../data/model/category_model.dart';
part 'category_state.dart';

class CategoryCubit extends Cubit<CategoryState> {
  CategoryCubit({
    required this.categoryRepo,
    required this.storage,
    required this.imagePicker,
  }) : super(CategoryInitial());

  final CategoryRepo categoryRepo;
  final StorageService storage;
  final ImagePickerService imagePicker;

  Future<void> getCategories() async {
    emit(GetCategoriesLoading());
    final categoriesOrFailure = await categoryRepo.getCategories();
    categoriesOrFailure.fold(
      (failure) => emit(GetCategoriesError(failure: failure)),
      (categories) => emit(GetCategoriesLoaded(categories: categories)),
    );
  }

  // ? need to refactor and handle state better for image upload and category creation
  Future<void> addCategory(CategoryModel category) async {
    if (state is! CategoryImagePicked) {
      emit(
        const GetCategoriesError(
          failure: Failure(errMessage: 'No image selected'),
        ),
      );
      return;
    }
    final imageFile = (state as CategoryImagePicked).imageFile;

    final uploadResult = await _uploadCategoryImage(imageFile, category.name);
    emit(AddCategoryLoading());
    final categoryWithImage = category.copyWith(imageUrl: uploadResult);
    if (uploadResult == null) {
      emit(
        const GetCategoriesError(
          failure: Failure(errMessage: 'Image upload failed'),
        ),
      );
      return;
    }
    final addCategoryOrfailure = await categoryRepo.addCategory(
      categoryWithImage,
    );
    addCategoryOrfailure.fold(
      (failure) => emit(AddCategoryFailure(failure: failure)),
      (_) async => getCategories(),
    );
  }

  Future<String?> _uploadCategoryImage(XFile imageFile, String fileName) async {
    final uploadResult = await storage.uploadImage(
      bucket: StoragePaths.categoryImagesBucket,
      folder: StoragePaths.categoryImagesFolder,
      bytes: await imageFile.readAsBytes(),
      fileName: fileName,
    );

    if (uploadResult.isEmpty) {
      emit(
        const GetCategoriesError(
          failure: Failure(errMessage: 'Image upload failed'),
        ),
      );
      return null;
    }

    return uploadResult;
  }

  Future<void> updateCategory(CategoryModel category) async {
    emit(GetCategoriesLoading());

    final result = await categoryRepo.updateCategory(category);
    await result.fold(
      (failure) async => emit(GetCategoriesError(failure: failure)),
      (_) async => getCategories(),
    );
  }

  Future<void> deleteCategory(String slug) async {
    emit(GetCategoriesLoading());

    final result = await categoryRepo.deleteCategory(slug);
    await result.fold(
      (failure) async => emit(GetCategoriesError(failure: failure)),
      (_) async => getCategories(),
    );
  }

  Future<void> pickImage() async {
    final imageFile = await imagePicker.pickImage(
      source: ImageSource.gallery,
    );

    if (imageFile == null) {
      emit(
        const GetCategoriesError(
          failure: Failure(errMessage: 'No image selected'),
        ),
      );
    } else {
      Logger.info('Image picked: ${imageFile.path}');
      emit(
        CategoryImagePicked(imageFile: imageFile),
      );
    }
  }
}
