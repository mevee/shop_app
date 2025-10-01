import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/common/app_log_util.dart';
import 'package:shop_app/data/network/app_colors.dart';
import 'package:shop_app/di.dart';
import 'package:shop_app/navigation/go_routes.dart';

void main() async {
  aLog("main() called");
  WidgetsFlutterBinding.ensureInitialized();
  ServiceLocatorDi().setup();

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
    return MaterialApp.router(
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
      routerConfig: GoRoutes.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

//---old code---
//class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       title: 'Shop App',
//       locale: const Locale('en', 'GB'), // Force 24-hour format
//       theme: ThemeData(
//         colorScheme: ColorScheme.fromSeed(seedColor: AppColors.cherryRed),
//         useMaterial3: true,
//         textTheme: GoogleFonts.latoTextTheme(Theme.of(context).textTheme),
//         primaryTextTheme: GoogleFonts.latoTextTheme(
//           Theme.of(context).primaryTextTheme,
//         ),
//       ),
//       initialRoute: Routes.splash,
//       getPages: AppPages.routes,
//       initialBinding: InitialBinding(),
//       debugShowCheckedModeBanner: false,
//     );
//   }
// }
