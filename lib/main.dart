// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:supabase_example/app/controllers/auth_controller.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  setup();
  await dotenv.load();

  String supaUri = dotenv.get('SUPABASE_URL');
  String supaAnon = dotenv.get('SUPABASE_ANONKEY');

  Supabase supaProvider = await Supabase.initialize(
    url: supaUri,
    anonKey: supaAnon,
  );

  final authC = Get.put(AuthController(), permanent: true);
  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: supaProvider.client.auth.currentUser == null
          ? Routes.LOGIN
          : Routes.HOME,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
    ),
  );
}

void setup() async {
  await Future.delayed(const Duration(seconds: 2));
  FlutterNativeSplash.remove();
}
