import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../domain/entities/chat_message_entity.dart';

class ChatMessageBubble extends StatelessWidget {
  final ChatMessageEntity message;
  final bool isMe;

  const ChatMessageBubble({
    super.key,
    required this.message,
    required this.isMe,
  });

  String _formatTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final messageDate = DateTime(dateTime.year, dateTime.month, dateTime.day);

    if (messageDate == today) {
      return DateFormat('h:mm a').format(dateTime);
    } else {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.75,
        ),
        decoration: BoxDecoration(
          color: isMe
              ? Theme.of(context).colorScheme.primary
              : Theme.of(context).colorScheme.surfaceContainerHighest,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: isMe ? const Radius.circular(16) : Radius.zero,
            bottomRight: isMe ? Radius.zero : const Radius.circular(16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.message,
              style: TextStyle(
                color: isMe
                    ? Theme.of(context).colorScheme.onPrimary
                    : Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _formatTime(message.createdAt),
                  style: TextStyle(
                    color: isMe
                        ? Theme.of(context).colorScheme.onPrimary.withOpacity(0.7)
                        : Theme.of(context).colorScheme.onSurfaceVariant.withOpacity(0.7),
                    fontSize: 11,
                  ),
                ),
                if (isMe && message.isRead) ...[
                  const SizedBox(width: 4),
                  Icon(
                    Icons.done_all,
                    size: 14,
                    color: Theme.of(context).colorScheme.onPrimary.withOpacity(0.7),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}
