import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:salinsalita/Admin/admin_login.dart';
import 'package:salinsalita/entry_point.dart';
import 'package:salinsalita/main.dart';
import 'package:salinsalita/pages/home.dart';
import 'package:salinsalita/screens/home/components/camera.dart';
import 'package:salinsalita/screens/home/components/speech_catch.dart';
import 'package:salinsalita/screens/onboding/onboding_screen.dart';
import 'firebase_options.dart';

List<CameraDescription> cameras = [];
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Salin Salita',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color(0xFFEEF1F8),
        primarySwatch: Colors.blue,
        fontFamily: "Intel",
        inputDecorationTheme: const InputDecorationTheme(
          filled: true,
          fillColor: Colors.white,
          errorStyle: TextStyle(height: 0),
          border: defaultInputBorder,
          enabledBorder: defaultInputBorder,
          focusedBorder: defaultInputBorder,
          errorBorder: defaultInputBorder,
        ),
      ),
      initialRoute: '/', // Set the initial route
      getPages: [
        GetPage(name: '/', page: () => OnboardingScreen()), // Define '/' route
        GetPage(
            name: '/ScoreScreen',
            page: () => const Home()), // Define '/ScoreScreen' route
        // Add other routes if needed
      ],
    );
  }
}

const defaultInputBorder = OutlineInputBorder(
  borderRadius: BorderRadius.all(Radius.circular(16)),
  borderSide: BorderSide(
    color: Color(0xFFDEE3F2),
    width: 1,
  ),
);
