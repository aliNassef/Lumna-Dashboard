import 'package:easy_localization/easy_localization.dart';
import '../../../../core/translation/locale_keys.g.dart';
import 'package:skeletonizer/skeletonizer.dart';
import '../../../../core/extensions/color_extensions.dart';
import '../../../../core/models/place_model.dart';
import '../../../../core/widgets/custom_failure_widget.dart';
import '../../../../core/widgets/custom_search_bar.dart';
import '../controller/address_cubit/address_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mapbox_maps_flutter/mapbox_maps_flutter.dart';

import '../../../../core/utils/app_assets.dart';
import 'confirm_address_info.dart';

class MapLocationViewBody extends StatelessWidget {
  const MapLocationViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const MapSearchScreen();
  }
}

class MapSearchScreen extends StatefulWidget {
  const MapSearchScreen({super.key});
  @override
  State createState() => _MapSearchScreenState();
}

class _MapSearchScreenState extends State<MapSearchScreen> {
  final double _zoom = 14;
  MapboxMap? _map;
  PointAnnotationManager? _mgr;
  Uint8List? _markerImage;
  _MarkerCoordinates? _pendingMarkerCoordinates;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocConsumer<AddressCubit, AddressState>(
          listener: (context, state) {
            if (state is GetCurrentUserPositionSuccess) {
              _selectMarkerCoordinates(
                lat: state.position.latitude,
                lng: state.position.longitude,
              );
              context.read<AddressCubit>().getMarkerAddress(
                lat: state.position.latitude,
                lng: state.position.longitude,
              );
            }
          },
          buildWhen: (previous, current) =>
              current is GetCurrentUserPositionSuccess ||
              current is GetCurrentUserPositionLoading ||
              current is GetCurrentUserPositionFailure,
          builder: (context, state) {
            return switch (state) {
              GetCurrentUserPositionLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
              GetCurrentUserPositionSuccess() => MapWidget(
                styleUri: MapboxStyles.MAPBOX_STREETS,
                viewport: CameraViewportState(
                  center: Point(
                    coordinates: Position(
                      state.position.longitude,
                      state.position.latitude,
                    ),
                  ),
                  zoom: _zoom,
                ),
                onMapCreated: _onMapCreated,
              ),
              GetCurrentUserPositionFailure() => CustomFailureWidget(
                failure: state.failure,
              ),
              _ => const SizedBox.shrink(),
            };
          },
        ),

        Positioned(
          top: 50,
          left: 16,
          right: 16,
          child: Column(
            children: [
              CustomSearchBar(
                onChanged: (query) {
                  if (query.isEmpty) {
                    return;
                  }
                  context.read<AddressCubit>().search(query);
                },
              ),
              BlocBuilder<AddressCubit, AddressState>(
                buildWhen: (previous, current) =>
                    current is SearchPlacesFailure ||
                    current is SearchPlacesSuccess ||
                    current is SearchPlacesLoading,
                builder: (context, state) {
                  return switch (state) {
                    SearchPlacesLoading() => Skeletonizer(
                      enabled: true,
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: 4,
                        itemBuilder: (_, i) => ListTile(
                          leading: const Icon(Icons.location_on),
                          title: Text(LocaleKeys.alexandria_egypt.tr()),
                          onTap: () {},
                        ),
                      ),
                    ),

                    SearchPlacesSuccess(:final places) => Container(
                      color: context.colors.onPrimary,
                      child: places.isEmpty
                          ? const SizedBox.shrink()
                          : ListView.builder(
                              shrinkWrap: true,
                              itemCount: places.length,
                              itemBuilder: (_, index) => ListTile(
                                leading: const Icon(Icons.location_on),
                                title: Text(places[index].street),
                                subtitle: Text(
                                  '${places[index].state}, ${places[index].city}',
                                ),
                                onTap: () {
                                  final place = places[index];
                                  _placeMarker(place);
                                  context.read<AddressCubit>().clearSearch();
                                  context
                                      .read<AddressCubit>()
                                      .selectMarkerAddress(place);
                                },
                              ),
                            ),
                    ),

                    SearchPlacesFailure(:final failure) => CustomFailureWidget(
                      failure: failure,
                    ),
                    _ => const SizedBox.shrink(),
                  };
                },
              ),
            ],
          ),
        ),

        const Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: ConfirmAddressInfo(),
        ),
      ],
    );
  }

  Future<void> _onMapCreated(MapboxMap map) async {
    _map = map;
    _mgr = await map.annotations.createPointAnnotationManager();
    map.addInteraction(TapInteraction.onMap(_onMapTap));

    if (!mounted) return;

    final markerCoordinates = _pendingMarkerCoordinates;
    if (markerCoordinates != null) {
      await _renderMarker(markerCoordinates.lat, markerCoordinates.lng);
    }
  }

  Future<Uint8List> _loadMarkerImage() async {
    final cachedImage = _markerImage;
    if (cachedImage != null) return cachedImage;

    final bytes = await rootBundle.load(AppAssets.markerIcon);
    final imageData = bytes.buffer.asUint8List();
    _markerImage = imageData;
    return imageData;
  }

  Future<void> _renderMarker(double lat, double lng) async {
    final manager = _mgr;
    if (manager == null) return;

    await manager.deleteAll();
    final imageData = await _loadMarkerImage();
    final options = PointAnnotationOptions(
      geometry: Point(
        coordinates: Position(lng, lat),
      ),
      iconSize: 3.0,
      image: imageData,
    );
    await manager.create(options);

    _map?.flyTo(
      CameraOptions(
        center: Point(coordinates: Position(lng, lat)),
        zoom: _zoom,
      ),
      MapAnimationOptions(),
    );
  }

  Future<void> _placeMarker(PlaceModel place) async {
    await _selectMarkerCoordinates(lat: place.lat, lng: place.lng);
  }

  Future<void> _selectMarkerCoordinates({
    required double lat,
    required double lng,
  }) async {
    _pendingMarkerCoordinates = _MarkerCoordinates(lat: lat, lng: lng);
    await _renderMarker(lat, lng);
  }

  void _onMapTap(MapContentGestureContext gestureContext) {
    final coordinates = gestureContext.point.coordinates;
    final lat = coordinates.lat.toDouble();
    final lng = coordinates.lng.toDouble();

    _selectMarkerCoordinates(lat: lat, lng: lng);
    context.read<AddressCubit>().getMarkerAddress(lat: lat, lng: lng);
  }
}

class _MarkerCoordinates {
  const _MarkerCoordinates({
    required this.lat,
    required this.lng,
  });

  final double lat;
  final double lng;
}
