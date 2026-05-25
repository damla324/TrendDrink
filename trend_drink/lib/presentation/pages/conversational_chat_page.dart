import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/presentation/notifiers/conversational_chat_notifier.dart';

/// Samimi, uzun sohbet yapan AI chat sayfası
class ConversationalChatPage extends ConsumerStatefulWidget {
  const ConversationalChatPage({super.key});

  @override
  ConsumerState<ConversationalChatPage> createState() =>
      _ConversationalChatPageState();
}

class _ConversationalChatPageState
    extends ConsumerState<ConversationalChatPage> {
  final _textController = TextEditingController();
  final _scrollController = ScrollController();
  bool _isComposing = false;

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleSubmitted(String text) {
    if (text.trim().isEmpty) return;

    _textController.clear();
    setState(() => _isComposing = false);

    ref
        .read(conversationalChatProvider.notifier)
        .sendMessage(text)
        .then((_) {
      _scrollToBottom();
    });
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

  void _resetChat() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Sohbeti Sıfırla'),
        content: const Text('Tüm sohbet geçmişi silinecek. Emin misin?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('İptal'),
          ),
          TextButton(
            onPressed: () {
              ref.read(conversationalChatProvider.notifier).resetChat();
              Navigator.pop(ctx);
            },
            child: const Text('Sıfırla', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(conversationalChatProvider);
    final isLoading = ref.watch(chatLoadingProvider);

    return Scaffold(
      backgroundColor: AppPalette.espresso,
      appBar: AppBar(
        backgroundColor: AppPalette.espresso,
        elevation: 0,
        title: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppPalette.emberOrange.withAlpha(200),
                    AppPalette.gold.withAlpha(200),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: Center(
                child: Text(
                  'A',
                  style: AppTypography.display(
                    size: 20,
                    color: Colors.white,
                    weight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Ava',
                  style: AppTypography.display(
                    size: 16,
                    color: AppPalette.cream,
                    weight: FontWeight.w600,
                  ),
                ),
                Text(
                  'Daima hazırım',
                  style: AppTypography.body(
                    size: 11,
                    color: AppPalette.dimCream.withAlpha(150),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _resetChat,
            tooltip: 'Sohbeti Sıfırla',
          ),
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Chat messages
          Expanded(
            child: messages.isEmpty
                ? Center(
                    child: Text(
                      'Sohbeti başlat',
                      style: AppTypography.body(
                        size: 14,
                        color: AppPalette.dimCream,
                      ),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    itemCount: messages.length,
                    itemBuilder: (ctx, idx) {
                      final msg = messages[idx];
                      return _ChatBubble(message: msg);
                    },
                  ),
          ),
          // Loading indicator
          if (isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Align(
                alignment: Alignment.centerLeft,
                child: _TypingIndicator(),
              ),
            ),
          // Input area
          _ChatInputArea(
            controller: _textController,
            onSubmitted: _handleSubmitted,
            isComposing: _isComposing,
            onComposingChanged: (value) {
              setState(() => _isComposing = value);
            },
            isLoading: isLoading,
          ),
        ],
      ),
    );
  }
}

/// Sohbet Balonu (User/Assistant)
class _ChatBubble extends StatelessWidget {
  const _ChatBubble({required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.author == ChatAuthor.user;

    return Padding(
      padding: EdgeInsets.only(
        bottom: 12,
        left: isUser ? 40 : 0,
        right: isUser ? 0 : 40,
      ),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          decoration: BoxDecoration(
            gradient: isUser
                ? LinearGradient(
                    colors: [
                      AppPalette.emberOrange.withAlpha(200),
                      AppPalette.gold.withAlpha(180),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  )
                : LinearGradient(
                    colors: [
                      AppPalette.cream.withAlpha(60),
                      AppPalette.cream.withAlpha(30),
                    ],
                  ),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(16),
              topRight: const Radius.circular(16),
              bottomLeft: Radius.circular(isUser ? 16 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 16),
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Text(
            message.text,
            style: AppTypography.body(
              size: 13,
              color: isUser ? Colors.white : AppPalette.cream,
              height: 1.4,
            ),
          ),
        ),
      ),
    );
  }
}

/// Yazıyor göstergesi
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppPalette.cream.withAlpha(
              (100 + 100 * math.sin(_controller.value * 2 * math.pi)).toInt(),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppPalette.cream.withAlpha(
              (100 + 100 * math.sin(_controller.value * 2 * math.pi + 0.4)).toInt(),
            ),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppPalette.cream.withAlpha(
              (100 + 100 * math.sin(_controller.value * 2 * math.pi + 0.8)).toInt(),
            ),
          ),
        ),
      ],
    );
  }
}

/// Chat input area
class _ChatInputArea extends StatefulWidget {
  const _ChatInputArea({
    required this.controller,
    required this.onSubmitted,
    required this.isComposing,
    required this.onComposingChanged,
    required this.isLoading,
  });

  final TextEditingController controller;
  final Function(String) onSubmitted;
  final bool isComposing;
  final Function(bool) onComposingChanged;
  final bool isLoading;

  @override
  State<_ChatInputArea> createState() => _ChatInputAreaState();
}

class _ChatInputAreaState extends State<_ChatInputArea> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppPalette.cream.withAlpha(40),
                    AppPalette.cream.withAlpha(20),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppPalette.cream.withAlpha(60),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: widget.controller,
                enabled: !widget.isLoading,
                onChanged: (text) {
                  widget.onComposingChanged(text.isNotEmpty);
                },
                onSubmitted: widget.isLoading ? null : widget.onSubmitted,
                style: AppTypography.body(
                  size: 13,
                  color: AppPalette.cream,
                ),
                decoration: InputDecoration(
                  hintText: 'Yazıp gönder...',
                  hintStyle: AppTypography.body(
                    size: 13,
                    color: AppPalette.dimCream.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
                maxLines: null,
                minLines: 1,
              ),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: widget.isLoading
                ? null
                : () {
                    if (widget.controller.text.trim().isNotEmpty) {
                      widget.onSubmitted(widget.controller.text);
                    }
                  },
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: widget.isLoading
                    ? LinearGradient(
                        colors: [
                          AppPalette.emberOrange.withAlpha(100),
                          AppPalette.gold.withAlpha(100),
                        ],
                      )
                    : LinearGradient(
                        colors: [
                          AppPalette.emberOrange,
                          AppPalette.gold,
                        ],
                      ),
              ),
              child: Center(
                child: widget.isLoading
                    ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor:
                              AlwaysStoppedAnimation(AppPalette.cream),
                        ),
                      )
                    : Icon(
                        Icons.send,
                        color: Colors.white,
                        size: 18,
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
