import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:shop_app/data/app_state_manager.dart';
import 'package:shop_app/data/network/app_colors.dart';
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
    final ApplicationState appState = Get.find();
    completeSplash(appState);
    super.initState();
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
    return Scaffold(
      body: Center(
        child: Container(
          width: context.width,
          height: context.height,
          decoration: const BoxDecoration(
            color: AppColors.blackText,
          ),
          child: const Image(image: AssetImages.logo).paddingAll(134),
        ),
      ),
    );
  }

}
