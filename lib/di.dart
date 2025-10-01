import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:shop_app/data/data_source/drc_local.dart';
import 'package:shop_app/data/data_source/drs_auth_remote.dart';
import 'package:shop_app/data/pref/session_pref_impl.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/repository/auth_repository_impl.dart';

final getIt = GetIt.instance;

class ServiceLocatorDi {
  void setup() async {
    getIt.registerLazySingleton<SessionPref>(() => SPrefSessiomImpl());
    getIt.registerLazySingleton<LocalDataSource>(() => LocalDataSource(getIt()));
    getIt.registerLazySingleton<AuthRemoteDataSource>(() => AuthRemoteDataSourceImpl());
    getIt.registerLazySingleton<AuthRepoImpl>(() => getIt());

    // getIt.registerSingleton<AuthRepoImpl>(authRemote);
  }
}
