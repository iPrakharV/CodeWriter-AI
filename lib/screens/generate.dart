import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'code.dart';

class GenerateScreen extends StatefulWidget {
  const GenerateScreen({super.key});

  @override
  _GenerateScreenState createState() => _GenerateScreenState();
}

class _GenerateScreenState extends State<GenerateScreen> {
  final FlutterTts _flutterTts = FlutterTts();
  final stt.SpeechToText _speechToText = stt.SpeechToText();
  String _spokenText = '';
  bool _isListening = false;
  String _aiResponse = 'Processing your request...';

  @override
  void dispose() {
    _flutterTts.stop(); // Stops TTS when the widget is disposed
    super.dispose();
  }

  Future<void> _startConversation() async {
    // Request microphone permission before starting
    await _requestMicrophonePermission();

    // Step 1: TTS - Initial greeting
    await _speak("Hey, this is CodeWriter, how can I help you today?");
    // Step 2: Start listening to the user's input
    await _listen();
  }

  Future<void> _requestMicrophonePermission() async {
    var status = await Permission.microphone.status;
    if (status.isDenied) {
      // Request microphone permission
      await Permission.microphone.request();
    }

    if (status.isPermanentlyDenied) {
      // Open app settings if permission is permanently denied
      openAppSettings();
    }
  }

  Future<void> _speak(String text) async {
    await _flutterTts.setLanguage('en-US');
    await _flutterTts.setPitch(1.0);
    await _flutterTts.speak(text);
  }

  Future<void> _listen() async {
    bool available = await _speechToText.initialize();
    if (available) {
      setState(() {
        _isListening = true;
      });
      _speechToText.listen(onResult: (result) {
        setState(() {
          _spokenText = result.recognizedWords;
        });
      });

      // After 5 seconds or when the speech stops
      await Future.delayed(Duration(seconds: 5));
      _speechToText.stop();
      setState(() {
        _isListening = false;
      });

      // Step 3: Process the input and respond
      await _processInput(_spokenText);
    } else {
      setState(() {
        _aiResponse = 'Speech recognition is not available on this device.';
      });
    }
  }

  Future<void> _processInput(String input) async {
    // Here, you'd typically send the input to the Gemini API for processing.
    // For simplicity, we'll just mock a response.
    String response = "Got it, I'm generating a solution for: $input";

    await _speak(response);

    // Step 4: Simulate generating a file
    await _generateFile(input);

    setState(() {
      _aiResponse = 'I have generated a file for the requested problem. Click the button below to view it.';
    });
  }

  Future<void> _generateFile(String content) async {
    final directory = await getApplicationDocumentsDirectory();
    final filePath = '${directory.path}/generated_code.txt';
    final file = File(filePath);

    await file.writeAsString('Generated content based on input: $content');
  }

  void _viewGeneratedFile() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const CodeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _startConversation,
              child: Text('Start Conversation'),
            ),
            SizedBox(height: 20),
            Text(
              _aiResponse,
              style: TextStyle(fontSize: 16, color: Colors.white),
              textAlign: TextAlign.center,
            ),
            if (_aiResponse.contains('Click the button below'))
              ElevatedButton(
                onPressed: _viewGeneratedFile,
                child: Text('View Code'),
              ),
          ],
        ),
      ),
    );
  }
}