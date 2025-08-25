import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shop_app/common/app_toast.dart';
import 'package:shop_app/common/battery_util.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/location_service/permission_helper.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'package:shop_app/utils/app_images.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void initState() {
    // permissionHandler();

    completeSplashUser();
    super.initState();
  }

  void completeSplashUser() async {
    final p1 = await PermissionUtil.notificationPermissionCheck();
    final loc = await PermissionUtil.locationPermissionCheck();
    final locService = await PermissionUtil.checkLocationServiceEnabled();
    // final batterySaveMode =
    //     await BatteryOptimizationUtil.isBatteryOptimizationEnabled();
    // if (batterySaveMode) {
    //   await BatteryOptimizationUtil.requestIgnoreBatteryOptimization();
    // }

    if (p1 && loc && locService) {
      final SessionPref userManager = Get.put(SPrefSessiomImpl());
      await userManager.initPreferences();
      final loginData = userManager.getUserData();
      final savedCred = userManager.getSavedCred();
      print("completeSplashUser::${loginData?.toJson()}");
      print("completeSplashUser::${savedCred?.toJson()}");
      Future.delayed(const Duration(seconds: 2), (() {
        if (loginData != null) {
          Get.offAllNamed(Routes.bottomNavigation);
        } else {
          Get.offAllNamed(Routes.login);
        }
      }));
    } else {
      AppToast.showToast(
        message:
            "Please allow notification and location permission to use this app.",
      );
    }
    // }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Image(
            image: AssetImages.logo,
          ).paddingSymmetric(horizontal: 100, vertical: 50),
          SizedBox(
            width: 50,
            height: 50,
            child: const CircularProgressIndicator(color: AppColors.darkWhite),
          ),
        ],
      ),
    );
  }

  void permissionHandler() async {
    PermissionUtil.checkEssentialPermissions(
      onResult: (reselt) {
        if (reselt) {
          completeSplashUser();
        } else {
          PermissionUtil.checkEssentialPermissions(
            onResult: (mN) {
              if (mN) {
                completeSplashUser();
              } else {
                AppToast.showToast(
                  message: "Please allow location permission to use this app.",
                );
              }
            },
          );
        }
      },
    );
  }
}
