import 'package:dartz/dartz.dart';

import '../../../../core/exceptions/error_mapper.dart';
import '../../../../core/exceptions/failure.dart';
import '../datasource/offers_remote_datasource.dart';
import '../models/offer_model.dart';

abstract interface class OffersRepo {
  Future<Either<Failure, List<OfferModel>>> getOffers();
  Future<Either<Failure, Unit>> addOffer(OfferModel offer);
  Future<Either<Failure, Unit>> updateOffer(OfferModel offer);
  Future<Either<Failure, Unit>> deleteOffer(String id);
}

class OffersRepoImpl implements OffersRepo {
  final OffersRemoteDataSource _remoteDataSource;

  OffersRepoImpl(this._remoteDataSource);

  @override
  Future<Either<Failure, List<OfferModel>>> getOffers() async {
    try {
      final offers = await _remoteDataSource.getOffers();
      return Right(offers);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> addOffer(OfferModel offer) async {
    try {
      await _remoteDataSource.addOffer(offer);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> updateOffer(OfferModel offer) async {
    try {
      await _remoteDataSource.updateOffer(offer);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }

  @override
  Future<Either<Failure, Unit>> deleteOffer(String id) async {
    try {
      await _remoteDataSource.deleteOffer(id);
      return const Right(unit);
    } catch (e) {
      return Left(Failure(errMessage: e.toMessage()));
    }
  }
}
