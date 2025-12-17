import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

class SpeechScreen extends StatefulWidget {
  const SpeechScreen({super.key});

  @override
  _SpeechScreenState createState() => _SpeechScreenState();
}

class _SpeechScreenState extends State<SpeechScreen> {
  late stt.SpeechToText _speech;
  bool _isListening = false;
  String _text = "Press the button and speak";
  String recognizedText = "";

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _initSpeech();
  }

  Future<void> _initSpeech() async {
    var status = await Permission.microphone.request();
    if (!status.isGranted) {
      setState(() {
        _text = "No microphone permission";
      });
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) {
        print('Status: $status');
        if (status == 'notListening' || status == 'done') {
          setState(() {
            _isListening = false;
          });
        }
      },
      onError: (val) {
        print('Error: $val');
        setState(() {
          _isListening = false;
        });
      },
    );

    if (available) {
      setState(() {
        _text = "Ready to listen to in Ukrainian";
      });
    } else {
      setState(() {
        _text = "Speech recognition is not available";
      });
    }
  }

  void _listen() {
    if (!_isListening) {
      setState(() {
        _isListening = true;
        _text = "I'm listening...";
      });

      _speech.listen(
        onResult: (val) {
          setState(() {
            recognizedText = val.recognizedWords;
            _text = recognizedText;
          });

          if (val.finalResult) {
            print("Final next: $recognizedText");
            _processRecognizedText(recognizedText);
          }
        },
        localeId: 'uk_UA',
      );
    } else {
      _speech.stop();
      setState(() {
        _isListening = false;
      });
    }
  }

  void _processRecognizedText(String text) {
    print("Corrected text in _processRecognizedText method: $text");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Voice assistant")),
      body: Center(
        child: Text(
          _text,
          style: const TextStyle(fontSize: 24),
          textAlign: TextAlign.center,
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _listen,
        tooltip: _isListening ? "Stop" : "Speak",
        child: Icon(_isListening ? Icons.mic : Icons.mic_none),
      ),
    );
  }
}
