import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../../products/data/models/product_model.dart';
import '../../../../products/data/repo/products_repo.dart';
import '../../../data/models/offer_model.dart';
import '../../../data/repo/offers_repo.dart';

part 'offer_state.dart';

class OfferCubit extends Cubit<OfferState> {
  OfferCubit({
    required this.offersRepo,
    required this.productsRepo,
  }) : super(const OfferState());

  final OffersRepo offersRepo;
  final ProductsRepo productsRepo;

  Future<void> getOffersData() async {
    emit(state.copyWith(status: OfferStatus.loading, clearFailure: true));

    final offersOrFailure = await offersRepo.getOffers();

    offersOrFailure.fold(
      (failure) => emit(
        state.copyWith(status: OfferStatus.failure, failure: failure),
      ),
      (offers) => emit(
        state.copyWith(
          status: OfferStatus.success,
          offers: offers,
        ),
      ),
    );
  }

  Future<void> saveOffer(OfferModel offer) async {
    emit(state.copyWith(status: OfferStatus.saving, clearFailure: true));
    final result = offer.id == null
        ? await offersRepo.addOffer(offer)
        : await offersRepo.updateOffer(offer);

    result.fold(
      (failure) => emit(
        state.copyWith(status: OfferStatus.saveFailure, failure: failure),
      ),
      (_) async {
        emit(state.copyWith(status: OfferStatus.saveSuccess));
        await getOffersData();
      },
    );
  }

  Future<void> deleteOffer(String id) async {
    emit(state.copyWith(status: OfferStatus.deleting, clearFailure: true));
    final result = await offersRepo.deleteOffer(id);

    result.fold(
      (failure) => emit(
        state.copyWith(status: OfferStatus.deleteFailure, failure: failure),
      ),
      (_) async {
        emit(state.copyWith(status: OfferStatus.deleteSuccess));
        await getOffersData();
      },
    );
  }
}
