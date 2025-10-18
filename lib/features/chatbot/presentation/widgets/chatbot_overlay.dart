import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../l10n/app_localizations.dart';
import '../providers/providers.dart';
import '../providers/chatbot_notifier.dart';
import '../state/chatbot_state.dart';
import 'message_bubble.dart';

class ChatbotOverlay extends ConsumerStatefulWidget {
  const ChatbotOverlay({super.key});

  @override
  ConsumerState<ChatbotOverlay> createState() => _ChatbotOverlayState();
}

class _ChatbotOverlayState extends ConsumerState<ChatbotOverlay>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _scaleAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOutBack,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _sendMessage(ChatbotNotifier chatbotNotifier) {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      chatbotNotifier.sendMessage(message);
      _messageController.clear();
      setState(() {}); // Update UI state
    }
  }

  bool _canSendMessage(ChatbotState chatbotState) {
    return chatbotState.isConnected && 
           !chatbotState.isLoading && 
           _messageController.text.trim().isNotEmpty;
  }

  @override
  Widget build(BuildContext context) {
    final chatbotState = ref.watch(chatbotProvider);
    final chatbotNotifier = ref.read(chatbotProvider.notifier);

    // Listen to chat state changes
    ref.listen<bool>(
      chatbotProvider.select((state) => state.isChatOpen),
      (previous, current) {
        if (current) {
          _animationController.forward();
        } else {
          _animationController.reverse();
        }
      },
    );

    // Listen to new messages to scroll to bottom
    ref.listen(
      chatbotProvider.select((state) => state.messages.length),
      (previous, current) {
        if (current > (previous ?? 0)) {
          _scrollToBottom();
        }
      },
    );

    if (!chatbotState.isChatOpen) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 80,
      right: 16,
      child: SlideTransition(
        position: _slideAnimation,
        child: ScaleTransition(
          scale: _scaleAnimation,
          child: Material(
            elevation: 8,
            borderRadius: BorderRadius.circular(16),
            child: Container(
              width: 320,
              height: 400,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
              child: Column(
                children: [
                  // Header
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(16),
                        topRight: Radius.circular(16),
                      ),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.smart_toy,
                          color: Colors.white,
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            AppLocalizations.of(context)!.animeAssistant,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ),
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: chatbotState.isConnected
                                ? Colors.green
                                : Colors.red,
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: () => chatbotNotifier.closeChat(),
                          child: const Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Messages
                  Expanded(
                    child: chatbotState.messages.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.chat_bubble_outline,
                                  size: 48,
                                  color: Theme.of(context).colorScheme.outline,
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  AppLocalizations.of(context)!.askMeAnything,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.outline,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  AppLocalizations.of(context)!.chatbotDescription,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.outline,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            controller: _scrollController,
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: chatbotState.messages.length,
                            itemBuilder: (context, index) {
                              return MessageBubble(
                                message: chatbotState.messages[index],
                                onAnimeNavigate: () => chatbotNotifier.closeChat(),
                              );
                            },
                          ),
                  ),
                  // Error message
                  if (chatbotState.error != null)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.red.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red.shade600,
                            size: 16,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              chatbotState.error!,
                              style: TextStyle(
                                color: Colors.red.shade700,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => chatbotNotifier.clearError(),
                            child: Icon(
                              Icons.close,
                              color: Colors.red.shade600,
                              size: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  // Input
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border(
                        top: BorderSide(
                          color: Theme.of(context).dividerColor,
                          width: 1,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _messageController,
                            decoration: InputDecoration(
                              hintText: chatbotState.isConnected
                                  ? AppLocalizations.of(context)!.askAboutAnime
                                  : AppLocalizations.of(context)!.lmStudioNotConnected,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide(
                                  color: Theme.of(context).dividerColor,
                                ),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 8,
                              ),
                              enabled: chatbotState.isConnected && !chatbotState.isLoading,
                            ),
                            maxLines: null,
                            textInputAction: TextInputAction.send,
                            onChanged: (value) {
                              // Trigger rebuild to update send button state
                              setState(() {});
                            },
                            onSubmitted: chatbotState.isConnected && !chatbotState.isLoading
                                ? (value) {
                                    if (value.trim().isNotEmpty) {
                                      _sendMessage(chatbotNotifier);
                                    }
                                  }
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        GestureDetector(
                          onTap: _canSendMessage(chatbotState)
                              ? () => _sendMessage(chatbotNotifier)
                              : null,
                          child: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: _canSendMessage(chatbotState)
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).colorScheme.outline,
                              shape: BoxShape.circle,
                            ),
                            child: chatbotState.isLoading
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                : const Icon(
                                    Icons.send,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}