import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/features/fortune_ai/fortune_notifier.dart';

class FortunePage extends ConsumerStatefulWidget {
  const FortunePage({super.key});

  @override
  ConsumerState<FortunePage> createState() => _FortunePageState();
}

class _FortunePageState extends ConsumerState<FortunePage> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();

  void _send() {
    final text = _ctrl.text.trim();
    if (text.isEmpty) return;
    ref.read(fortuneProvider.notifier).sendMessage(text);
    _ctrl.clear();
    _scrollToBottom();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(fortuneProvider);
    _scrollToBottom();

    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: Text('Mistik Falcı', style: AppTypography.display(size: 20, color: AppPalette.cream)),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scroll,
              padding: const EdgeInsets.all(24),
              itemCount: messages.length,
              itemBuilder: (ctx, i) {
                final m = messages[i];
                final isAi = m.author.name == 'assistant';
                return Align(
                  alignment: isAi ? Alignment.centerLeft : Alignment.centerRight,
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: isAi ? AppPalette.obsidian.withAlpha(200) : AppPalette.gold.withAlpha(40),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: isAi ? AppPalette.gold.withAlpha(40) : AppPalette.gold),
                    ),
                    child: Text(
                      m.text,
                      style: AppTypography.body(size: 14, color: AppPalette.cream),
                    ),
                  ),
                ).animate().fadeIn();
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: AppPalette.mocha.withAlpha(160),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: AppPalette.gold.withAlpha(50)),
                    ),
                    child: TextField(
                      controller: _ctrl,
                      style: AppTypography.body(size: 14, color: AppPalette.cream),
                      decoration: const InputDecoration(
                        hintText: 'Fincanından bahset veya bir burç yaz...',
                        hintStyle: TextStyle(color: Colors.white38),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (_) => _send(),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                IconButton(
                  onPressed: _send,
                  icon: const Icon(Icons.auto_awesome, color: AppPalette.gold),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}