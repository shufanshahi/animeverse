import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/providers.dart';

class ChatbotFloatingButton extends ConsumerWidget {
  const ChatbotFloatingButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final chatbotState = ref.watch(chatbotProvider);
    final chatbotNotifier = ref.read(chatbotProvider.notifier);

    return FloatingActionButton(
      onPressed: () {
        chatbotNotifier.toggleChat();
      },
      backgroundColor: chatbotState.isConnected 
          ? Theme.of(context).primaryColor 
          : Colors.grey,
      child: Stack(
        children: [
          Icon(
            chatbotState.isChatOpen ? Icons.close : Icons.chat,
            color: Colors.white,
          ),
          if (!chatbotState.isConnected)
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: Colors.red,
                  shape: BoxShape.circle,
                ),
              ),
            ),
        ],
      ),
    );
  }
}