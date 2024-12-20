import 'package:flutter/material.dart';
import 'package:easy_splash_screen/easy_splash_screen.dart';
import './home.dart';

class SplashScreens extends StatefulWidget {
  const SplashScreens({Key? key}) : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreensState createState() => _SplashScreensState();
}

class _SplashScreensState extends State<SplashScreens> {
  @override
  void initState() {
    super.initState();
    // Display the first splash screen for 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      // Move to the second splash screen
      Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => const Home(),
      ));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Background
        EasySplashScreen(
          title: const Text(
            "Chord Detection",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF212121),
            ),
          ),
          logo: Image.asset('assets/user.png'),
          navigator: null,
          backgroundColor: const Color(0xFFF6F6F6),
          showLoader: true,
          loadingText: const Text("Loading..."),
        ),
        // Images and Texts
        Positioned(
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/user.png', width: 50, height: 50),
                      const SizedBox(height: 10),
                      const Text(
                        "Nama - Nim",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/user.png', width: 50, height: 50),
                      const SizedBox(height: 10),
                      const Text(
                        "Nama - Nim",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Image.asset('assets/user.png', width: 50, height: 50),
                      const SizedBox(height: 10),
                      const Text(
                        "Nama - Nim",
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
