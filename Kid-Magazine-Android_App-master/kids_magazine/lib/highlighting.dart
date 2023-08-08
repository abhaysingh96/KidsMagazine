import 'package:flutter/material.dart';
import 'package:kids_magazine/transliterate.dart';
import 'package:flutter_tts/flutter_tts.dart';


class HighlightedText extends StatefulWidget {
  final String text;
  final FlutterTts flutterTts;

  HighlightedText(
      {required this.text, required this.flutterTts});

  @override
  _HighlightedTextState createState() => _HighlightedTextState();
}
class _HighlightedTextState extends State<HighlightedText> {
  int start = 0;
  int end = 0;
  TtsState ttsState = TtsState.stopped;

  get isPlaying => ttsState == TtsState.playing;
  get isStopped => ttsState == TtsState.stopped;
  get isPaused => ttsState == TtsState.paused;
  get isContinued => ttsState == TtsState.continued;

  @override
  initState() {
    super.initState();
    initTts();
  }

  initTts() {
    widget.flutterTts.setStartHandler(() {
      setState(() {
        print("playing");
        ttsState = TtsState.playing;
      });
    });

    widget.flutterTts.setCompletionHandler(() {
      setState(() {
        print("Complete");
        ttsState = TtsState.stopped;
      });
    });

    widget.flutterTts.setCancelHandler(() {
      setState(() {
        print("Cancel");
        ttsState = TtsState.stopped;
      });
    });

    widget.flutterTts.setPauseHandler(() {
      setState(() {
        print("Paused");
        ttsState = TtsState.paused;
      });
    });

    widget.flutterTts.setContinueHandler(() {
      setState(() {
        print("Continued");
        ttsState = TtsState.continued;
      });
    });

    widget.flutterTts.setProgressHandler((String text, int startOffset, int endOffset, String word) {
      setState(() {
        onHighlightChanged(startOffset, endOffset, text);
      });
    });
  }

  void onHighlightChanged(int s, int e, String remText) {
    setState(() {
      // update the highlighted word
      int ind = widget.text.length - remText.length;
      start = s + ind;
      end = e + ind;
    });
  }
  @override
  Widget build(BuildContext context) {
    TextStyle normalStyle = TextStyle(
      fontSize: 18,
      color: Color(0xFF181621),
    );
    TextStyle highlightedStyle = TextStyle(
      fontSize: 18,
      color: Colors.red,
      fontWeight: FontWeight.bold,
    );
    return RichText(
        text: TextSpan(
            children: [
              TextSpan(
                text: widget.text.substring(0, start),
                style: normalStyle,
              ),
              TextSpan(
                text: widget.text.substring(start, end),
                style: highlightedStyle,
              ),
              TextSpan(
                text: widget.text.substring(end),
                style: normalStyle,
              ),
            ],
        ),
    );
  }
}
