import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/chat_message.dart';

class ChatBubble extends StatelessWidget {
  const ChatBubble({super.key, required this.message});

  final ChatMessage message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.author == ChatAuthor.user;
    final color = isUser ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.surfaceContainerHighest;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 18),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(24),
              topRight: const Radius.circular(24),
              bottomLeft: Radius.circular(isUser ? 24 : 6),
              bottomRight: Radius.circular(isUser ? 6 : 24),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextContent(context, message.text, isUser),
              if (message.drinkId != null && !isUser)
                Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: ElevatedButton.icon(
                    onPressed: () => context.push('/drink/${message.drinkId}'),
                    icon: const Icon(Icons.local_drink_outlined, size: 18),
                    label: const Text('Tarifi Aç'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      backgroundColor: Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextContent(BuildContext context, String text, bool isUser) {
    final List<InlineSpan> spans = [];
    // Regex: Matches [Title](id) or **BoldText**
    final regex = RegExp(r'\[([^\]]+)\]\(([^)]+)\)|\*\*([^*]+)\*\*');
    int lastIndex = 0;

    for (final match in regex.allMatches(text)) {
      // Add plain text before the match
      if (match.start > lastIndex) {
        spans.add(TextSpan(text: text.substring(lastIndex, match.start)));
      }

      if (match.group(1) != null) {
        // Link match: [Title](id)
        final title = match.group(1)!;
        final id = match.group(2)!;
        spans.add(
          WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: GestureDetector(
              onTap: () => context.push('/drink/$id'),
              child: Text(
                title,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: isUser ? Colors.white : Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                      decorationColor: isUser ? Colors.white : Theme.of(context).colorScheme.primary,
                    ),
              ),
            ),
          ),
        );
      } else if (match.group(3) != null) {
        // Bold text match: **Text**
        spans.add(
          TextSpan(
            text: match.group(3),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      }
      lastIndex = match.end;
    }

    // Add remaining text
    if (lastIndex < text.length) {
      spans.add(TextSpan(text: text.substring(lastIndex)));
    }

    return Text.rich(
      TextSpan(
        children: spans,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: isUser ? Colors.white : Theme.of(context).colorScheme.onSurface,
            ),
      ),
    );
  }
}
