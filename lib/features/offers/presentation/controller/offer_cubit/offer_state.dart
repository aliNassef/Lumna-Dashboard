part of 'offer_cubit.dart';

enum OfferStatus {
  initial,
  loading,
  success,
  failure,
  saving,
  saveSuccess,
  saveFailure,
  deleting,
  deleteSuccess,
  deleteFailure,
}

extension OfferStatusX on OfferStatus {
  bool get isLoading => this == OfferStatus.loading;
  bool get isSaving => this == OfferStatus.saving;
  bool get isSaveSuccess => this == OfferStatus.saveSuccess;
  bool get isSaveFailure => this == OfferStatus.saveFailure;
  bool get isDeleting => this == OfferStatus.deleting;
  bool get isDeleteSuccess => this == OfferStatus.deleteSuccess;
  bool get isDeleteFailure => this == OfferStatus.deleteFailure;
}

class OfferState extends Equatable {
  final OfferStatus status;
  final List<OfferModel> offers;
  final List<ProductModel> products;
  final Failure? failure;

  const OfferState({
    this.status = OfferStatus.initial,
    this.offers = const [],
    this.products = const [],
    this.failure,
  });

  OfferState copyWith({
    OfferStatus? status,
    List<OfferModel>? offers,
    List<ProductModel>? products,
    Failure? failure,
    bool clearFailure = false,
  }) {
    return OfferState(
      status: status ?? this.status,
      offers: offers ?? this.offers,
      products: products ?? this.products,
      failure: clearFailure ? null : failure ?? this.failure,
    );
  }

  @override
  List<Object?> get props => [status, offers, products, failure];
}
