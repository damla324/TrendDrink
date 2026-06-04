import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/presentation/pages/fortune_notifier.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';
import 'package:trenddrink/features/paywall/paywall_sheet.dart';

class FortunePage extends ConsumerStatefulWidget {
  const FortunePage({super.key});

  @override
  ConsumerState<FortunePage> createState() => _FortunePageState();
}

class _FortunePageState extends ConsumerState<FortunePage> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;

  static const _quickPrompts = ['Fal bak 🔮', 'Aşk falı ❤️', 'İş/Kariyer 💼', 'Yüreğim kabarık..'];

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(fortuneProvider);
    final membership = ref.watch(membershipProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(child: _buildMessageList(messages)),
          _buildQuickPrompts(),
          _buildInputBar(membership.isPro),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(36, 24, 36, 18),
      decoration: BoxDecoration(border: Border(bottom: BorderSide(color: AppPalette.ledViolet.withAlpha(40)))),
      child: Row(
        children: [
          const Icon(Icons.auto_fix_high_rounded, color: AppPalette.ledViolet, size: 28),
          const SizedBox(width: 14),
          Text('Mistik Fal AI', style: AppTypography.display(size: 22, color: AppPalette.cream)),
          const Spacer(),
          const Text('🔮', style: TextStyle(fontSize: 24)),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    return ListView.builder(
      controller: _scroll,
      padding: const EdgeInsets.all(36),
      itemCount: messages.length + (_sending ? 1 : 0),
      itemBuilder: (ctx, i) {
        if (i == messages.length) return const Text('Fısıltılar dinleniyor...', style: TextStyle(color: AppPalette.ledViolet, fontStyle: FontStyle.italic));
        final m = messages[i];
        return _MessageBubble(message: m);
      },
    );
  }

  Widget _buildQuickPrompts() {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 36),
        itemCount: _quickPrompts.length,
        itemBuilder: (ctx, i) => ActionChip(
          label: Text(_quickPrompts[i]),
          onPressed: () { _ctrl.text = _quickPrompts[i]; _send(); },
        ),
      ),
    );
  }

  Widget _buildInputBar(bool isPro) {
    return Padding(
      padding: const EdgeInsets.all(36),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _ctrl,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                hintText: 'Fincanını anlat veya mistik bir soru sor...',
                hintStyle: TextStyle(color: AppPalette.cream.withAlpha(100)),
                filled: true,
                fillColor: AppPalette.mocha.withAlpha(100),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filled(
            onPressed: _send,
            icon: const Icon(Icons.send_rounded),
            backgroundColor: AppPalette.ledViolet,
          ),
        ],
      ),
    );
  }

  void _send() async {
    if (_ctrl.text.isEmpty) return;
    setState(() => _sending = true);
    await ref.read(fortuneProvider.notifier).sendMessage(_ctrl.text);
    _ctrl.clear();
    setState(() => _sending = false);
    _scroll.animateTo(_scroll.position.maxScrollExtent, duration: 300.ms, curve: Curves.easeOut);
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  const _MessageBubble({required this.message});

  @override
  Widget build(BuildContext context) {
    final isUser = message.author == ChatAuthor.user;
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isUser ? AppPalette.ledViolet.withAlpha(40) : AppPalette.mocha.withAlpha(180),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: isUser ? AppPalette.ledViolet.withAlpha(100) : Colors.transparent),
        ),
        child: Text(message.text, style: const TextStyle(color: AppPalette.cream)),
      ),
    );
  }
}