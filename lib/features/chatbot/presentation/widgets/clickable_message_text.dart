import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../domain/entities/entities.dart';

class ClickableMessageText extends StatelessWidget {
  final String content;
  final List<ClickableAnimeReference>? clickableReferences;
  final TextStyle style;

  const ClickableMessageText({
    super.key,
    required this.content,
    this.clickableReferences,
    required this.style,
  });

  @override
  Widget build(BuildContext context) {
    if (clickableReferences == null || clickableReferences!.isEmpty) {
      return Text(content, style: style);
    }

    final theme = Theme.of(context);
    final spans = <TextSpan>[];
    int currentIndex = 0;

    // Sort clickable references by start index
    final sortedReferences = List<ClickableAnimeReference>.from(clickableReferences!)
      ..sort((a, b) => a.startIndex.compareTo(b.startIndex));

    for (final reference in sortedReferences) {
      // Add text before the clickable anime title
      if (currentIndex < reference.startIndex) {
        spans.add(TextSpan(
          text: content.substring(currentIndex, reference.startIndex),
          style: style,
        ));
      }

      // Add the clickable anime title
      spans.add(TextSpan(
        text: reference.title,
        style: style.copyWith(
          color: theme.primaryColor,
          decoration: TextDecoration.underline,
          fontWeight: FontWeight.w600,
        ),
        recognizer: TapGestureRecognizer()
          ..onTap = () {
            context.push('/anime/${reference.animeId}');
          },
      ));

      currentIndex = reference.endIndex;
    }

    // Add remaining text after the last clickable reference
    if (currentIndex < content.length) {
      spans.add(TextSpan(
        text: content.substring(currentIndex),
        style: style,
      ));
    }

    return RichText(
      text: TextSpan(children: spans),
    );
  }
}