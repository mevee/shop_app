import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/data/user_manager.dart';
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
    // final ApplicationState appState = Get.find();
    // final UserManager userManager = Get.find();
    completeSplashUser();
    super.initState();
  }

  void completeSplashUser({UserManager? userManager}) {
    Future.delayed(const Duration(seconds: 2), (() {
      // if (userManager.getUserData()?.login != null) {
        // Get.offAllNamed(Routes.bottomNavigation);
      // } else {
        Get.offAllNamed(Routes.login);
      // }
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
