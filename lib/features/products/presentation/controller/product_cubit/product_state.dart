part of 'product_cubit.dart';

enum ProductStatus {
  initial,
  loadingProducts,
  successProducts,
  failureProducts,
  addingProduct,
  addProductSuccess,
  addProductFailure,
  updatingProduct,
  updateProductSuccess,
  updateProductFailure,
  deletingProduct,
  deleteProductSuccess,
  deleteProductFailure,
  uploadingImages,
}

extension ProductStatusX on ProductStatus {
  bool get isInitial => this == ProductStatus.initial;
  bool get isLoadingProducts => this == ProductStatus.loadingProducts;
  bool get isSuccessProducts => this == ProductStatus.successProducts;
  bool get isFailureProducts => this == ProductStatus.failureProducts;
  bool get isAddingProduct => this == ProductStatus.addingProduct;
  bool get isAddProductSuccess => this == ProductStatus.addProductSuccess;
  bool get isAddProductFailure => this == ProductStatus.addProductFailure;
  bool get isUpdatingProduct => this == ProductStatus.updatingProduct;
  bool get isUpdateProductSuccess => this == ProductStatus.updateProductSuccess;
  bool get isUpdateProductFailure => this == ProductStatus.updateProductFailure;
  bool get isDeletingProduct => this == ProductStatus.deletingProduct;
  bool get isDeleteProductSuccess => this == ProductStatus.deleteProductSuccess;
  bool get isDeleteProductFailure => this == ProductStatus.deleteProductFailure;
  bool get isUploadingImages => this == ProductStatus.uploadingImages;
}

class ProductState extends Equatable {
  final ProductStatus status;
  final List<ProductModel> allProducts;
  final List<ProductModel> filteredProducts;
  final List<XFile> pickedImages;
  final List<String> retainedImageUrls;
  final bool isActive;
  final String query;
  final Failure? failure;

  const ProductState({
    this.status = ProductStatus.initial,
    this.allProducts = const [],
    this.filteredProducts = const [],
    this.pickedImages = const [],
    this.retainedImageUrls = const [],
    this.isActive = true,
    this.query = '',
    this.failure,
  });

  ProductState copyWith({
    ProductStatus? status,
    List<ProductModel>? allProducts,
    List<ProductModel>? filteredProducts,
    List<XFile>? pickedImages,
    List<String>? retainedImageUrls,
    bool? isActive,
    String? query,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return ProductState(
      status: status ?? this.status,
      allProducts: allProducts ?? this.allProducts,
      filteredProducts: filteredProducts ?? this.filteredProducts,
      pickedImages: pickedImages ?? this.pickedImages,
      retainedImageUrls: retainedImageUrls ?? this.retainedImageUrls,
      isActive: isActive ?? this.isActive,
      query: query ?? this.query,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [
    status,
    allProducts,
    filteredProducts,
    pickedImages,
    retainedImageUrls,
    isActive,
    query,
    failure,
  ];
}
