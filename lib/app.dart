import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ibl_test/views/chat/chat.dart';

import 'utils/colors.dart';
import 'routes/app_pages.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "IBL Test",
      home: const Scaffold(backgroundColor: Colors.white, body: App()),
      theme: _buildAppTheme(),
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages,
    );
  }
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: colorFFF,
      body: SafeArea(
        child: Chat(),
      ),
    );
  }
}

ThemeData _buildAppTheme() {
  final ThemeData base = ThemeData.light();
  return base.copyWith(
    primaryColor: colorPrimary,
    buttonTheme: base.buttonTheme.copyWith(
      buttonColor: colorPrimary,
      colorScheme: base.colorScheme.copyWith(
        secondary: colorPrimary,
      ),
    ),
    buttonBarTheme: base.buttonBarTheme.copyWith(
      buttonTextTheme: ButtonTextTheme.accent,
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
      textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
      foregroundColor: colorPrimary_100,
      shadowColor: Colors.black45,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
      minimumSize: const Size(350, 50),
    )),
    textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
      textStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: colorPrimary_100),
      foregroundColor: colorPrimary_100,
      shadowColor: Colors.transparent,
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
    )),
    scaffoldBackgroundColor: colorFFF,
    cardColor: colorPrimary,
    textTheme: _buildAppTextTheme(base.textTheme),
    primaryTextTheme: _buildAppTextTheme(base.primaryTextTheme),
    primaryIconTheme: base.iconTheme.copyWith(color: Colors.white),
    colorScheme: ColorScheme.fromSwatch().copyWith(primary: colorPrimary, error: colorDanger),
    inputDecorationTheme: const InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(width: 2, color: colorPrimary),
      ),
    ),
  );
}

TextTheme _buildAppTextTheme(TextTheme base) {
  return base
      .copyWith(
        displayLarge: base.displayLarge?.copyWith(
          fontWeight: FontWeight.w500,
        ),
        titleMedium: base.titleLarge?.copyWith(fontSize: 18.0),
        bodySmall: base.bodySmall?.copyWith(
          fontWeight: FontWeight.w400,
          fontSize: 13.0,
        ),
      )
      .apply(
        fontFamily: 'Montserrat',
        displayColor: colorContentPrimary,
        bodyColor: colorContentPrimary,
      );
}
