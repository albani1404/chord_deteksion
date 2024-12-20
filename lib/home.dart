import 'package:flutter/material.dart';

import 'package:uas_mobile_chord/tutorial.dart';
import 'package:uas_mobile_chord/detection.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  void navigateToDetectionPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const DetectionPage()),
    );
  }

  void navigateToTutorialPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const TutorialPage()),
    );
  }

  // loadModel() async {
  //   await Tflite.loadModel(
  //       model: "assets/zemodel.tflite", labels: "assets/labels.txt");
  // }

  @override
  void initState() {
    super.initState();

    // loadModel();
  }

  // @override
  // void dispose() async {
  //   await Tflite.close();
  // }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/bg-gitar.jpg'),
                fit: BoxFit.fill,
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Button pertama
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      navigateToDetectionPage();
                    },
                    child: const Text("Mulai Deteksi"),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),

                // Button kedua
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      navigateToTutorialPage();
                    },
                    child: const Text("Tutorial Chord"),
                  ),
                ),
              ], //children_2
            ),
          ),
        ),
      ),
    );
  }
}
