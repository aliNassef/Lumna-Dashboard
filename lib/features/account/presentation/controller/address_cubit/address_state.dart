part of 'address_cubit.dart';

sealed class AddressState extends Equatable {
  const AddressState();

  @override
  List<Object> get props => [];
}

final class AddressInitial extends AddressState {}

final class GetCurrentUserPositionLoading extends AddressState {}

final class GetCurrentUserPositionSuccess extends AddressState {
  final Position position;

  const GetCurrentUserPositionSuccess({required this.position});
  @override
  List<Object> get props => [position];
}

final class GetCurrentUserPositionFailure extends AddressState {
  final Failure failure;
  const GetCurrentUserPositionFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}

final class SearchPlacesLoading extends AddressState {}

final class SearchPlacesSuccess extends AddressState {
  final List<PlaceModel> places;

  const SearchPlacesSuccess(this.places);
  @override
  List<Object> get props => [places];
}

final class SearchPlacesFailure extends AddressState {
  final Failure failure;

  const SearchPlacesFailure(this.failure);
  @override
  List<Object> get props => [failure];
}

final class GetMarkerAddressLoading extends AddressState {}

final class GetMarkerAddressSuccess extends AddressState {
  final PlaceModel place;

  const GetMarkerAddressSuccess(this.place);

  @override
  List<Object> get props => [place];
}

final class GetMarkerAddressFailure extends AddressState {
  final Failure failure;

  const GetMarkerAddressFailure(this.failure);

  @override
  List<Object> get props => [failure];
}

final class AddStoreLocationLoading extends AddressState {}

final class AddStoreLocationSuccess extends AddressState {}

final class AddStoreLocationFailure extends AddressState {
  final Failure failure;
  const AddStoreLocationFailure({required this.failure});

  @override
  List<Object> get props => [failure];
}