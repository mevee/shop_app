import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/app_bindings/initial_binding.dart';
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/data/session_pref_impl.dart';
// import 'package:shop_app/data/session_pref_impl.dart';
import 'package:shop_app/navigation/app_pages.dart';

void main() async {
  aLog("main() called");
  WidgetsFlutterBinding.ensureInitialized();
  await SPrefSessiomImpl().initPreferences();
  SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: AppColors.cherryRed,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: AppColors.cherryRed,
    ),
  );
  // Start background service

  // await FlutterBgService().initializeService();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shop App',
      locale: const Locale('en', 'GB'), // Force 24-hour format
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppColors.cherryRed),
        useMaterial3: true,
        textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
        primaryTextTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      initialRoute: Routes.splash,

      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      debugShowCheckedModeBanner: false,
    );
  }
}
