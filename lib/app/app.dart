import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/transitions_type.dart';
import 'package:grocer_ai/app/app_routes.dart';
import '../core/theme/themes.dart';

class App extends StatelessWidget {
  final ThemeData lightTheme, darkTheme;
  const App({super.key, required this.lightTheme, required this.darkTheme});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'GrocerAI',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.light,
      initialRoute: Routes.splash,
      getPages: AppPages.pages,
      defaultTransition: Transition.cupertino,
    );
  }
}
