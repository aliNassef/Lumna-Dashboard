import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../../core/constants/storage_paths.dart';
import '../../../../../core/di/di.dart';
import '../../../../../core/exceptions/failure.dart';
import '../../../data/models/product_model.dart';

part 'product_state.dart';

class ProductCubit extends Cubit<ProductState> {
  ProductCubit({
    required this.productsRepo,
    required this.imagePicker,
    required this.storage,
  }) : super(const ProductState());

  final ProductsRepo productsRepo;
  final ImagePickerService imagePicker;
  final StorageService storage;

  Future<void> getProducts() async {
    emit(
      state.copyWith(
        status: ProductStatus.loadingProducts,
        clearFailure: true,
      ),
    );

    final productsOrFailure = await productsRepo.getProducts();
    productsOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.failureProducts,
          failure: failure,
        ),
      ),
      (products) => emit(
        state.copyWith(
          status: ProductStatus.successProducts,
          allProducts: [...state.allProducts, ...products],
          filteredProducts: _filterProducts(
            products: [...state.allProducts, ...products],
            query: '',
          ),
          query: '',
          clearFailure: true,
        ),
      ),
    );
  }

  void searchProducts(String query) {
    emit(
      state.copyWith(
        filteredProducts: _filterProducts(
          products: state.allProducts,
          query: query,
        ),
        query: query,
      ),
    );
  }

  void initializeForEdit(ProductModel product) {
    emit(
      state.copyWith(
        pickedImages: const [],
        retainedImageUrls: List<String>.from(product.images),
        isActive: product.isActive,
        clearFailure: true,
      ),
    );
  }

  void resetFormState({bool isActive = true}) {
    emit(
      state.copyWith(
        pickedImages: const [],
        retainedImageUrls: const [],
        isActive: isActive,
        clearFailure: true,
      ),
    );
  }

  void setIsActive(bool value) {
    emit(state.copyWith(isActive: value, status: ProductStatus.initial));
  }

  Future<void> pickImages() async {
    final pickedImages = await imagePicker.pickMultiImage();
    if (pickedImages.isEmpty) return;

    emit(
      state.copyWith(
        pickedImages: [...state.pickedImages, ...pickedImages],
        status: ProductStatus.initial,
      ),
    );
  }

  void removeImage(int index) {
    if (index < 0 || index >= state.pickedImages.length) return;

    final updatedImages = List<XFile>.from(state.pickedImages)..removeAt(index);
    emit(state.copyWith(pickedImages: updatedImages));
  }

  void removeEditImage(int index) {
    if (index < 0) return;

    if (index < state.retainedImageUrls.length) {
      final updatedImageUrls = List<String>.from(state.retainedImageUrls)
        ..removeAt(index);
      emit(
        state.copyWith(
          retainedImageUrls: updatedImageUrls,
          status: ProductStatus.initial,
        ),
      );
      return;
    }

    final localImageIndex = index - state.retainedImageUrls.length;
    if (localImageIndex < 0 || localImageIndex >= state.pickedImages.length) {
      return;
    }

    final updatedImages = List<XFile>.from(state.pickedImages)
      ..removeAt(localImageIndex);
    emit(state.copyWith(pickedImages: updatedImages));
  }

  void addProduct(ProductModel product) async {
    if (state.pickedImages.isEmpty) {
      emit(
        state.copyWith(
          status: ProductStatus.addProductFailure,
          failure: const Failure(errMessage: 'No images selected'),
        ),
      );
      return;
    }

    final imagesUrls = await uploadProductImages();
    if (imagesUrls.isEmpty) {
      emit(
        state.copyWith(
          status: ProductStatus.addProductFailure,
          failure: const Failure(errMessage: 'failed to upload images'),
        ),
      );
      return;
    }

    final productWithImages = product.copyWith(images: imagesUrls);
    emit(
      state.copyWith(
        status: ProductStatus.addingProduct,
        clearFailure: true,
      ),
    );

    final addProductOrfailure = await productsRepo.addProduct(
      productWithImages,
    );

    addProductOrfailure.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.addProductFailure,
          failure: failure,
        ),
      ),
      (_) => emit(
        state.copyWith(
          status: ProductStatus.addProductSuccess,
          pickedImages: const [],
          allProducts: [productWithImages, ...state.allProducts],
          filteredProducts: [
            productWithImages,
            ...state.filteredProducts,
          ],
          retainedImageUrls: const [],
          clearFailure: true,
        ),
      ),
    );
  }

  Future<void> updateProduct(ProductModel product) async {
    final existingImages = List<String>.from(state.retainedImageUrls);
    if (state.pickedImages.isNotEmpty) {
      final imagesUrls = await uploadProductImages();
      if (imagesUrls.isNotEmpty) {
        product = product.copyWith(images: [...existingImages, ...imagesUrls]);
      } else {
        product = product.copyWith(images: existingImages);
      }
    } else {
      product = product.copyWith(images: existingImages);
    }

    emit(
      state.copyWith(
        status: ProductStatus.updatingProduct,
        clearFailure: true,
      ),
    );

    final updateProductOrFailure = await productsRepo.updateProduct(product);
    updateProductOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.updateProductFailure,
          failure: failure,
        ),
      ),
      (_) {
        final updatedProducts = state.allProducts
            .map(
              (currentProduct) =>
                  currentProduct.id == product.id ? product : currentProduct,
            )
            .toList();

        emit(
          state.copyWith(
            status: ProductStatus.updateProductSuccess,
            allProducts: updatedProducts,
            filteredProducts: _filterProducts(
              products: updatedProducts,
              query: state.query,
            ),
            pickedImages: const [],
            retainedImageUrls: product.images,
            isActive: product.isActive,
            clearFailure: true,
          ),
        );
      },
    );
  }

  Future<void> deleteProduct(String id) async {
    emit(
      state.copyWith(
        status: ProductStatus.deletingProduct,
        clearFailure: true,
      ),
    );

    final deleteProductOrFailure = await productsRepo.deleteProduct(id);
    deleteProductOrFailure.fold(
      (failure) => emit(
        state.copyWith(
          status: ProductStatus.deleteProductFailure,
          failure: failure,
        ),
      ),
      (_) {
        final updatedProducts = state.allProducts
            .where((product) => product.id != id)
            .toList();

        emit(
          state.copyWith(
            status: ProductStatus.deleteProductSuccess,
            allProducts: updatedProducts,
            filteredProducts: _filterProducts(
              products: updatedProducts,
              query: state.query,
            ),
            clearFailure: true,
          ),
        );
      },
    );
  }

  Future<List<String>> uploadProductImages() async {
    emit(
      state.copyWith(
        status: ProductStatus.uploadingImages,
        clearFailure: true,
      ),
    );

    final imagesUrls = <String>[];
    for (final image in state.pickedImages) {
      final imageUrl = await storage.uploadImage(
        bucket: StoragePaths.productImagesBucket,
        folder: StoragePaths.productImagesFolder,
        bytes: await image.readAsBytes(),
        fileName: image.name,
      );
      imagesUrls.add(imageUrl);
    }

    return imagesUrls;
  }

  List<ProductModel> _filterProducts({
    required List<ProductModel> products,
    required String query,
  }) {
    final normalizedQuery = query.trim().toLowerCase();
    if (normalizedQuery.isEmpty) return products;

    return products.where((product) {
      final name = product.name.toLowerCase();
      final description = product.description.toLowerCase();
      return name.contains(normalizedQuery) ||
          description.contains(normalizedQuery);
    }).toList();
  }
}
