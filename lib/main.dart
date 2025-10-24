import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:grocer_ai/app/app_bindings.dart';
import 'package:grocer_ai/app/app_routes.dart';
import 'package:grocer_ai/core/theme/themes.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await GetStorage.init();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  runApp(const GrocerAiApp());
}

class GrocerAiApp extends StatelessWidget {
  const GrocerAiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialBinding: AppBindings(),
      title: 'GrocerAI',
      debugShowCheckedModeBanner: false,
      theme: lightTheme,
      //      darkTheme: darkTheme,
      initialRoute: Routes.splash,
      getPages: AppPages.pages, // <-- single source of truth
    );
  }
}
