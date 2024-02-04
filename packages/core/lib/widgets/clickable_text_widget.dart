import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ClickableLinkWidget extends StatelessWidget {
  final String text;
  final TextStyle? style;

  const ClickableLinkWidget(
    this.text, {
    super.key,
    this.style,
  });

  @override
  Widget build(BuildContext context) {
    List<InlineSpan> spans = [];

    // Split the text by whitespace to identify individual words
    List<String> words = text.split(' ');

    for (String word in words) {
      if (word.contains('http://') || word.contains('https://')) {
        // If the word is a URL, make it clickable
        spans.add(
          TextSpan(
            text: '$word ',
            style: style?.copyWith(
              color: Colors.blue,
              decoration: TextDecoration.underline,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launchUrl(
                  Uri.parse(_extractUrl(word)),
                  mode: LaunchMode.externalApplication,
                );
              },
          ),
        );
      } else {
        // Otherwise, keep the word as normal text
        spans.add(
          TextSpan(text: '$word ', style: style),
        );
      }
    }

    return RichText(
      text: TextSpan(
        style: style,
        children: spans,
      ),
    );
  }
}

String _extractUrl(String input) {
  // Regular expression to match URLs
  RegExp urlRegExp = RegExp(r'https?://\S+');

  // Extract the first match from the input string
  Match? match = urlRegExp.firstMatch(input);

  // Check if a match is found
  if (match != null) {
    return match.group(0)!;
  } else {
    return ''; // Return an empty string if no URL is found
  }
}
