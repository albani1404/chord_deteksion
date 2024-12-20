import 'package:uas_mobile_chord/splashscreen.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'UAS Mobile - Chord',
      home: SplashScreens(),
      debugShowCheckedModeBanner: false,
    );
  }
}
