import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shop_app/app_bindings/initial_binding.dart';
import 'package:shop_app/navigation/app_pages.dart';
import 'utils/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Shop App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: AppConstants.primaryColor),
        useMaterial3: true,
          textTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).textTheme,
        ),
        primaryTextTheme: GoogleFonts.latoTextTheme(
          Theme.of(context).primaryTextTheme,
        ),
      ),
      initialRoute: Routes.splash,
      getPages: AppPages.routes,
      initialBinding: InitialBinding(),
      //  localizationsDelegates: const [
      //       AppLocalizations.delegate
      //       // GlobalMaterialLocalizations.delegate,
      //       // GlobalWidgetsLocalizations.delegate,
      //       // GlobalCupertinoLocalizations.delegate,
      //     ],
      debugShowCheckedModeBanner: false,
    );
  }
}
