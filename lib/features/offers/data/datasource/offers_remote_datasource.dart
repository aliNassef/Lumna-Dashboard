import '../../../../core/constants/endpoints.dart';
import '../../../../core/database/database.dart';
import '../models/offer_model.dart';

abstract interface class OffersRemoteDataSource {
  Future<List<OfferModel>> getOffers();
  Future<void> addOffer(OfferModel offer);
  Future<void> updateOffer(OfferModel offer);
  Future<void> deleteOffer(String id);
}

class OffersRemoteDataSourceImpl implements OffersRemoteDataSource {
  final Database _database;

  OffersRemoteDataSourceImpl(this._database);

  @override
  Future<List<OfferModel>> getOffers() async {
    final response = await _database.get(
      path: Endpoints.offers,
      orderBy: 'created_at',
      ascending: false,
    );

    return response.map(OfferModel.fromMap).toList();
  }

  @override
  Future<void> addOffer(OfferModel offer) {
    return _database.add(
      path: Endpoints.offers,
      data: offer.toMap(),
    );
  }

  @override
  Future<void> updateOffer(OfferModel offer) {
    return _database.update(
      path: Endpoints.offers,
      id: offer.id!,
      data: offer.toMap(),
    );
  }

  @override
  Future<void> deleteOffer(String id) {
    return _database.delete(
      path: Endpoints.offers,
      id: id,
    );
  }
}
