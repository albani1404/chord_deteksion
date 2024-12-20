import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:tflite_v2/tflite_v2.dart';

class DetectionPage extends StatefulWidget {
  const DetectionPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _DetectionPageState createState() => _DetectionPageState();
}

class _DetectionPageState extends State<DetectionPage> {
  String? selectedAudioFileName;
  DateTime? recordingStartTime;
  bool isRecording = false;
  final record = AudioRecorder();
  late Timer timer;
  Duration recordingDuration = const Duration(seconds: 0);
  String? detectionResult;

  @override
  void initState() {
    super.initState();
    loadModel();
  }

  loadModel() async {
    await Tflite.loadModel(
        model: "assets/soundclassifier_with_metadata.tflite",
        labels: "assets/labels.txt");
  }

  Future<void> detectAudio(String audioFilePath) async {
    try {
      // Load audio file as bytes
      // Uint8List audioBytes = await File(audioFilePath).readAsBytes();

      // // // Perform detection using TFLite model
      // var output = await Tflite.runModelOnBinary(
      //   binary: audioBytes,
      // );

      // // // Process detection output
      // processDetectionOutput(output);
    } catch (e) {
      // Handle error

      // print('Error in Tflite.runModelOnBinary: $e');
    }
  }

  Future<void> detectAudioBytes(Uint8List audioBytes) async {
    try {
      var output = await Tflite.runModelOnBinary(binary: audioBytes);

      print(output);

      processDetectionOutput(output);
    } catch (e) {
      // Handle error
      // print('Error in Tflite.runModelOnBinary: $e');
    }
  }

  void processDetectionOutput(List<dynamic>? output) {
    if (output != null) {
      String result = 'Detection Result: $output';

      setState(() {
        detectionResult = result;
      });
    }
  }

  updateRecordingDuration() {
    if (isRecording) {
      final duration = DateTime.now().difference(recordingStartTime!);
      setState(() {
        recordingDuration = duration;
      });
    }
  }

  Future<void> startRecording() async {
    try {
      if (await record.hasPermission()) {
        selectedAudioFileName = null;
        // Get external storage directory
        final directory = await getExternalStorageDirectory();

        // Generate a unique file name based on date and time
        String timestamp = DateTime.now().millisecondsSinceEpoch.toString();
        final path = '${directory?.path}/audio_$timestamp.wav';

        // Start recording
        await record.start(const RecordConfig(), path: path);

        // Start the stopwatch when recording begins
        recordingStartTime = DateTime.now();
        timer = Timer.periodic(const Duration(milliseconds: 100),
            (Timer t) => updateRecordingDuration());

        setState(() {
          isRecording = true;
        });
      } else {
        // print('Recording permission not granted.');
      }
    } catch (e) {
      // print('Error recording: $e');
    }
  }

  Future<void> stopRecording() async {
    try {
      final path = await record.stop();

      timer.cancel();

      setState(() {
        isRecording = false;
        recordingDuration = const Duration(seconds: 0);
      });

      String? audioFileName = path?.split('/').last;
      if (audioFileName != null) {
        setState(() {
          selectedAudioFileName = audioFileName;
        });
      }

      // print('Recording saved at: $path');
      // print('Recording duration: ${formatDuration(recordingDuration)}');
    } catch (e) {
      // print('Error stopping recording: $e');
    }
  }

  Future<void> pickAudio() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.audio,
        allowMultiple: false,
      );
      if (result != null) {
        String audioFilePath = result.files.single.bytes != null
            ? 'memory' // Handle memory case (e.g., not a file on the device)
            : 'unknown'; // Handle other cases where path is not available

        // Perform detection when audio is picked
        if (audioFilePath == 'memory') {
          // Handle detection logic using result.files.single.bytes directly
          await detectAudioBytes(result.files.single.bytes!);
        } else {
          // Handle detection logic for cases where file path is available
          await detectAudio(audioFilePath);
        }

        //  print(result.files.single.path);
        String audioFileName = result.files.single.name;

        setState(() {
          selectedAudioFileName = audioFileName;
        });
      } else {
        // print('File selection canceled.');
      }
    } catch (e) {
      // print('Error: $e');
    }
  }

  String formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    String threeDigits(int n) => n.toString().padLeft(3, '0');

    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    String twoDigitMilliseconds = threeDigits(duration.inMilliseconds % 1000);

    return '00:$twoDigitMinutes:$twoDigitSeconds.$twoDigitMilliseconds';
  }

  @override
  void dispose() async {
    record.dispose();
    await Tflite.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Audio Detection Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: isRecording ? stopRecording : startRecording,
              child: Text(isRecording ? 'Stop Recording' : 'Start Recording'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                pickAudio();
              },
              child: const Text('Pick Audio'),
            ),
            const SizedBox(height: 20),
            if (selectedAudioFileName != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Selected Audio: $selectedAudioFileName'),
                  IconButton(
                    onPressed: () {
                      // Add logic to delete the selected audio file here
                      setState(() {
                        selectedAudioFileName = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            if (isRecording)
              Text('Recording Duration: ${formatDuration(recordingDuration)}'),
            if (detectionResult != null)
              Column(
                children: [
                  const SizedBox(height: 20),
                  const Text('Detection Result:'),
                  Text(detectionResult!),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
