import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import '../../../data/models/location_model.dart';

import '../../../../../core/exceptions/failure.dart';
import '../../../../../core/models/place_model.dart';
import '../../../../../core/services/location/location_service.dart';
import '../../../../../core/services/location/map_service.dart';
import '../../../data/repo/location_repo.dart';

part 'address_state.dart';

class AddressCubit extends Cubit<AddressState> {
  AddressCubit({
    required LocationService locationService,
    required MapService mapService,
    required LocationRepo locationRepo,
  }) : _locationService = locationService,
       _mapService = mapService,
       _locationRepo = locationRepo,
       super(AddressInitial());
  final LocationService _locationService;
  final MapService _mapService;
  final LocationRepo _locationRepo;
  void getCurrentUserPosition() async {
    emit(GetCurrentUserPositionLoading());
    try {
      final userPositiom = await _locationService.getCurrentLocation();
      emit(
        GetCurrentUserPositionSuccess(
          position: userPositiom,
        ),
      );
    } catch (e) {
      emit(
        GetCurrentUserPositionFailure(
          failure: Failure(errMessage: e.toString()),
        ),
      );
    }
  }

  void search(String query) async {
    emit(SearchPlacesLoading());
    try {
      final places = await _mapService.searchPlaces(query);
      emit(
        SearchPlacesSuccess(
          places,
        ),
      );
    } catch (e) {
      emit(
        SearchPlacesFailure(
          Failure(errMessage: e.toString()),
        ),
      );
    }
  }

  void getMarkerAddress({
    required double lat,
    required double lng,
  }) async {
    emit(GetMarkerAddressLoading());
    try {
      final place = await _mapService.reverseGeocode(lat: lat, lng: lng);
      emit(GetMarkerAddressSuccess(place));
    } catch (e) {
      emit(
        GetMarkerAddressFailure(
          Failure(errMessage: e.toString()),
        ),
      );
    }
  }

  void selectMarkerAddress(PlaceModel place) {
    emit(GetMarkerAddressSuccess(place));
  }

  void clearSearch() {
    emit(
      const SearchPlacesSuccess(
        [],
      ),
    );
  }

  void addStoreLocation(LocationModel location) async {
    emit(AddStoreLocationLoading());
    final locationOrFailure = await _locationRepo.addStoreLocation(location);
    locationOrFailure.fold(
      (failure) => emit(AddStoreLocationFailure(failure: failure)),
      (void _) => emit(AddStoreLocationSuccess()),
    );
  }
}
