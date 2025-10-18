import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../domain/entities/entities.dart';

class ClickableMessageText extends StatelessWidget {
  final String content;
  final List<ClickableAnimeReference>? clickableReferences;
  final ThemeData theme;
  final VoidCallback? onAnimeNavigate;

  const ClickableMessageText({
    super.key,
    required this.content,
    this.clickableReferences,
    required this.theme,
    this.onAnimeNavigate,
  });

  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: content,
      selectable: true,
      onTapLink: (text, href, title) {
        if (href != null) {
          // Check if it's an anime link (anime://id format)
          if (href.startsWith('anime://')) {
            final animeId = href.substring(8); // Remove 'anime://' prefix
            // Close the chatbot overlay before navigating
            onAnimeNavigate?.call();
            context.push('/anime/$animeId');
          } else {
            // Handle regular links
            launchUrl(Uri.parse(href));
          }
        }
      },
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 14,
        ),
        code: TextStyle(
          backgroundColor: theme.colorScheme.surfaceContainerHighest,
          color: theme.colorScheme.onSurface,
          fontSize: 13,
        ),
        codeblockDecoration: BoxDecoration(
          color: theme.colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.circular(8),
        ),
        blockquote: TextStyle(
          color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
          fontStyle: FontStyle.italic,
        ),
        h1: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        h2: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
        h3: TextStyle(
          color: theme.colorScheme.onSurface,
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        strong: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
        ),
        em: TextStyle(
          color: theme.colorScheme.onSurface,
          fontStyle: FontStyle.italic,
        ),
        a: TextStyle(
          color: theme.colorScheme.primary,
          decoration: TextDecoration.underline,
          decorationColor: theme.colorScheme.primary,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}