import 'package:flutter_clean_architecture_boilerplate/config/app_config.dart';
import 'package:flutter_clean_architecture_boilerplate/core/network/auth_interceptor.dart';
import 'package:flutter_clean_architecture_boilerplate/core/network/network_info.dart';
import 'package:flutter_clean_architecture_boilerplate/core/network/network_info_impl.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/datasources/auth_local_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/datasources/auth_remote_data_source_impl.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/usecases/login.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/domain/usecases/logout.dart';
import 'package:flutter_clean_architecture_boilerplate/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/repositories/posts_repository.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/domain/usecases/get_posts.dart';
import 'package:flutter_clean_architecture_boilerplate/features/posts/presentation/bloc/posts_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Config
  sl.registerLazySingleton<AppConfig>(() => appConfig);

  // Features - Auth
  // BLoC
  sl.registerFactory(() => AuthBloc(
        loginUseCase: sl(),
        logoutUseCase: sl(),
        getCachedUserUseCase: sl(),
      ));

  // Use cases
  sl.registerLazySingleton(() => LoginUseCase(sl()));
  sl.registerLazySingleton(() => LogoutUseCase(sl()));
  sl.registerLazySingleton(() => GetCachedUserUseCase(sl()));

  // Repository
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Features - Posts
  // BLoC
  sl.registerFactory(() => PostsBloc(getPostsUseCase: sl()));

  // Use cases
  sl.registerLazySingleton(() => GetPostsUseCase(sl()));

  // Repository
  sl.registerLazySingleton<PostsRepository>(
    () => PostsRepositoryImpl(
      remoteDataSource: sl(),
      localDataSource: sl(),
      networkInfo: sl(),
    ),
  );

  // Data sources
  sl.registerLazySingleton<PostsRemoteDataSource>(
    () => PostsRemoteDataSourceImpl(client: sl()),
  );
  sl.registerLazySingleton<PostsLocalDataSource>(
    () => PostsLocalDataSourceImpl(sharedPreferences: sl()),
  );

  // Core
  sl.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(sl()));

  // External
  final sharedPreferences = await SharedPreferences.getInstance();
  sl.registerLazySingleton(() => sharedPreferences);

  // Dio with interceptors
  final dio = Dio(BaseOptions(
    baseUrl: sl<AppConfig>().baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 10),
  ));

  // Add interceptors
  dio.interceptors.addAll([
    LogInterceptor(
      request: true,
      requestHeader: true,
      requestBody: true,
      responseHeader: true,
      responseBody: true,
      error: true,
    ),
    AuthInterceptor(sharedPreferences: sl()),
  ]);

  sl.registerLazySingleton(() => dio);
  sl.registerLazySingleton(() => InternetConnectionChecker());
}