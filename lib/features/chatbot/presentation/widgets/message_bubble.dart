import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/entities/entities.dart';
import 'anime_suggestion_card.dart';
import 'clickable_message_text.dart';

class MessageBubble extends StatelessWidget {
  final MessageEntity message;
  final VoidCallback? onAnimeNavigate;

  const MessageBubble({
    super.key,
    required this.message,
    this.onAnimeNavigate,
  });

  @override
  Widget build(BuildContext context) {
    final isUser = message.type == MessageType.user;
    final theme = Theme.of(context);

    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 16),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isUser 
              ? theme.primaryColor 
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(18).copyWith(
            bottomRight: isUser ? const Radius.circular(4) : null,
            bottomLeft: !isUser ? const Radius.circular(4) : null,
          ),
          border: !isUser 
              ? Border.all(color: theme.dividerColor, width: 1)
              : null,
        ),
        child: message.isLoading
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            theme.colorScheme.onSurface,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        AppLocalizations.of(context)!.thinking,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (message.content.isNotEmpty && message.content != '...')
                    Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        message.content,
                        style: TextStyle(
                          color: theme.colorScheme.onSurface.withOpacity(0.7),
                          fontSize: 12,
                        ),
                      ),
                    ),
                ],
              )
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Message content
                  isUser
                      ? Text(
                          message.content,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        )
                      : (message.clickableAnimeReferences != null && message.clickableAnimeReferences!.isNotEmpty)
                          ? ClickableMessageText(
                              content: message.content,
                              clickableReferences: message.clickableAnimeReferences,
                              theme: theme,
                              onAnimeNavigate: onAnimeNavigate,
                            )
                          : MarkdownBody(
                              data: message.content,
                              styleSheet: MarkdownStyleSheet(
                                p: TextStyle(
                                  color: theme.colorScheme.onSurface,
                                  fontSize: 14,
                                ),
                            code: TextStyle(
                              backgroundColor: theme.colorScheme.surfaceVariant,
                              color: theme.colorScheme.onSurfaceVariant,
                              fontSize: 13,
                            ),
                            codeblockDecoration: BoxDecoration(
                              color: theme.colorScheme.surfaceVariant,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            blockquote: TextStyle(
                              color: theme.colorScheme.onSurface.withOpacity(0.7),
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
                          ),
                          selectable: true,
                        ),
                  // Anime suggestions
                  if (message.animeSuggestions != null && message.animeSuggestions!.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(
                      AppLocalizations.of(context)!.similarAnime,
                      style: TextStyle(
                        color: isUser ? Colors.white.withOpacity(0.9) : theme.colorScheme.onSurface,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 140, // Further reduced to match the card height
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        itemCount: message.animeSuggestions!.length,
                        itemBuilder: (context, index) {
                          return AnimeSuggestionCard(
                            anime: message.animeSuggestions![index],
                            onNavigate: onAnimeNavigate,
                          );
                        },
                      ),
                    ),
                  ],
                ],
              ),
      ),
    );
  }
}