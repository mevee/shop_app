import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/data/preference.dart';
import 'package:shop_app/data/session_getstorage_impl.dart';
import 'package:shop_app/models/login_response.dart';
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
    completeSplashUser();
    super.initState();
  }

  void completeSplashUser() async{
     final SessionPref userManager = Get.find();
     await userManager.initPreferences();
     final loginData = userManager.getUserData();
    Future.delayed(const Duration(seconds: 2), (() {
      if (loginData!= null) {
        Get.offAllNamed(Routes.bottomNavigation);
      } else {
        Get.offAllNamed(Routes.login);
      }
    }));
  }

  void completeSplash(ApplicationState appState) {
    Future.delayed(const Duration(seconds: 2), (() {
      switch (appState.getCurrentState) {
        case 0:
          {
            Get.offAllNamed(Routes.bottomNavigation);
          }
        default:
          {
            Get.offAllNamed(Routes.login);
            break;
          }
      }
    }));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.blackText,
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
}
