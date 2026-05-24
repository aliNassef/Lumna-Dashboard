import 'package:dio/dio.dart';
import 'package:lumna_admin/core/services/location/location_service_impl.dart';
import 'package:lumna_admin/core/services/location/map_service.dart';
import 'package:lumna_admin/features/account/presentation/controller/address_cubit/address_cubit.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../features/account/data/datasource/location_remote_datasource.dart';
import '../../features/account/data/repo/location_repo.dart';
import '../services/location/location_service.dart';
import '../services/location/map_service_impl.dart';
import 'di.dart';

final GetIt injector = GetIt.instance;

Future<void> setupLocator() async {
  await _setupExternal();
  await _setupAccountFeature();
  await _setupAuthFeature();
  await _setupCategoryFeature();
  await _setupHomeFeature();
  await _setupNotificationFeature();
  await _setupOffersFeature();
  await _setupProductsFeature();
  await _setupOrdersFeature();
}

Future<void> _setupAccountFeature() async {
  injector.registerFactory<AccountCubit>(
    () => AccountCubit(
      accountRepo: injector<AccountRepo>(),
      authRepo: injector<AuthRepo>(),
      imagePicker: injector<ImagePickerService>(),
      storage: injector<StorageService>(),
    ),
  );

  injector.registerFactory<AddressCubit>(
    () => AddressCubit(
      locationRepo: injector<LocationRepo>(),
      locationService: injector<LocationService>(),
      mapService: injector<MapService>(),
    ),
  );
  injector.registerLazySingleton<AccountRepo>(
    () => AccountRepoImpl(
      injector<AccountRemoteDataSource>(),
    ),
  );

  injector.registerLazySingleton<AccountRemoteDataSource>(
    () => AccountRemoteDataSourceImpl(
      database: injector<Database>(),
      authService: injector<AuthService>(),
    ),
  );

  injector.registerLazySingleton<LocationRepo>(
    () => LocationRepoImpl(
      injector<LocationRemoteDataSource>(),
    ),
  );

  injector.registerLazySingleton<LocationRemoteDataSource>(
    () => LocationRemoteDataSourceImpl(
      injector<Database>(),
    ),
  );
}

Future<void> _setupAuthFeature() async {
  injector.registerFactory(
    () => AuthCubit(
      authRepo: injector<AuthRepo>(),
    ),
  );

  injector.registerLazySingleton<AuthRepo>(
    () => AuthRepoImpl(
      injector<AuthRemoteDataSource>(),
    ),
  );
  injector.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(
      authService: injector<AuthService>(),
    ),
  );
}

Future<void> _setupHomeFeature() async {
  injector.registerFactory(
    () => StatisticsCubit(
      homeRepo: injector<StatisticsRepo>(),
    ),
  );

  injector.registerLazySingleton<StatisticsRepo>(
    () => StatisticsRepoImpl(
      injector<StatisticsRemoteDataSource>(),
    ),
  );

  injector.registerLazySingleton<StatisticsRemoteDataSource>(
    () => StatisticsRemoteDataSourceImpl(
      injector<Database>(),
    ),
  );
}

Future<void> _setupCategoryFeature() async {
  injector.registerFactory(
    () => CategoryCubit(
      categoryRepo: injector<CategoryRepo>(),
      imagePicker: injector<ImagePickerService>(),
      storage: injector<StorageService>(),
    ),
  );

  injector.registerLazySingleton<CategoryRepo>(
    () => CategoryRepoImpl(
      injector<CategoryRemoteDataSource>(),
    ),
  );

  injector.registerLazySingleton<CategoryRemoteDataSource>(
    () => CategoryRemoteDataSourceImpl(
      injector<Database>(),
    ),
  );
}

Future<void> _setupProductsFeature() async {
  injector.registerFactory<ProductCubit>(
    () => ProductCubit(
      productsRepo: injector<ProductsRepo>(),
      imagePicker: injector<ImagePickerService>(),
      storage: injector<StorageService>(),
    ),
  );
  injector.registerLazySingleton<ProductsRepo>(
    () => ProductsRepoImpl(
      injector<ProductsRemoteDataSource>(),
    ),
  );

  injector.registerLazySingleton<ProductsRemoteDataSource>(
    () => ProductsRemoteDataSourceImpl(
      injector<Database>(),
    ),
  );
}

Future<void> _setupNotificationFeature() async {
  injector.registerFactory(
    () => NotificationCubit(
      notificationRepo: injector<NotificationRepo>(),
      imagePickerService: injector<ImagePickerService>(),
      storageService: injector<StorageService>(),
    ),
  );

  injector.registerLazySingleton<NotificationRepo>(
    () => NotificationRepoImpl(
      injector<NotificationRemoteDataSource>(),
    ),
  );

  injector.registerLazySingleton<NotificationRemoteDataSource>(
    () => NotificationRemoteDataSourceImpl(
      supabaseClient: injector<SupabaseClient>(),
    ),
  );
}

Future<void> _setupOffersFeature() async {
  injector.registerFactory(
    () => OfferCubit(
      offersRepo: injector<OffersRepo>(),
      productsRepo: injector<ProductsRepo>(),
    ),
  );

  injector.registerLazySingleton<OffersRepo>(
    () => OffersRepoImpl(
      injector<OffersRemoteDataSource>(),
    ),
  );

  injector.registerLazySingleton<OffersRemoteDataSource>(
    () => OffersRemoteDataSourceImpl(
      injector<Database>(),
    ),
  );
}

Future<void> _setupOrdersFeature() async {
  injector.registerFactory(
    () => OrdersCubit(
      ordersRepo: injector<OrdersRepo>(),
    ),
  );

  injector.registerLazySingleton<OrdersRepo>(
    () => OrdersRepoImpl(
      injector<OrdersRemoteDataSource>(),
    ),
  );

  injector.registerLazySingleton<OrdersRemoteDataSource>(
    () => OrdersRemoteDataSourceImpl(
      injector<Database>(),
    ),
  );
}

Future<void> _setupExternal() async {
  injector.registerLazySingleton<AuthService>(
    () => SupabaseAuthImpl(
      supabase: injector<SupabaseClient>(),
    ),
  );
  injector.registerLazySingleton<ImagePickerService>(
    ImagePickerServiceImpl.new,
  );
  injector.registerLazySingleton<NotificationService>(
    LocalNotificationServiceImpl.new,
  );
  injector.registerLazySingleton<RemoteNotificationService>(
    () => RemoteNotificationService.instance,
  );
  injector.registerLazySingleton<StorageService>(
    () => SupabaseStorageService(
      supabaseClient: injector<SupabaseClient>(),
    ),
  );
  injector.registerLazySingleton<LocationService>(() => LocationServiceImpl());
  injector.registerLazySingleton<MapService>(() => MapServiceImpl(Dio()));
  injector.registerLazySingleton<SupabaseClient>(
    () => Supabase.instance.client,
  );
  injector.registerLazySingleton<Database>(
    () => SupabaseDpImpl(client: injector<SupabaseClient>()),
  );
}
