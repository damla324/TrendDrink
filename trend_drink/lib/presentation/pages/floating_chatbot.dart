import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/presentation/pages/assistant_notifier.dart';
import 'package:trenddrink/presentation/pages/fortune_notifier.dart';

enum AIType { assistant, fortune }

class FloatingChatbot extends ConsumerStatefulWidget {
  const FloatingChatbot({
    super.key,
    required this.onDrag,
    required this.aiType,
    required this.onTap,
  });

  final ValueChanged<DragUpdateDetails> onDrag;
  final AIType aiType;
  final VoidCallback onTap;

  @override
  ConsumerState<FloatingChatbot> createState() => _FloatingChatbotState();
}

class _FloatingChatbotState extends ConsumerState<FloatingChatbot> {
  bool _isHovering = false;

  @override
  Widget build(BuildContext context) {
    final isAssistant = widget.aiType == AIType.assistant;
    final icon = isAssistant ? Icons.coffee_rounded : Icons.auto_fix_high_rounded;
    final label = isAssistant ? 'İçecek AI' : 'Mistik Fal AI';
    final color = isAssistant ? AppPalette.ledViolet : Colors.purpleAccent;

    return GestureDetector(
      onPanUpdate: widget.onDrag,
      onTap: widget.onTap,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovering = true),
        onExit: (_) => setState(() => _isHovering = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(_isHovering ? 0.9 : 0.7),
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: color.withOpacity(0.3),
                blurRadius: 10,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              Text(
                label,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}