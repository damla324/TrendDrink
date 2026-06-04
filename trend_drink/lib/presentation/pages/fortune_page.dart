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

  static const _quickPrompts = [
    'Fincanımı yorumla 🔮',
    'Aşk hayatımda neler var? ❤️',
    'Kariyer yolum açık mı? 💼',
    'Yüreğim neden kabarık? ✨',
    'Günün mesajını fısılda 🌟'
  ];

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(fortuneProvider);
    final membership = ref.watch(membershipProvider);

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          _buildHeader(),
          Expanded(
            child: Stack(
              children: [
                if (messages.length <= 1) _buildMysticEmptyState(),
                _buildMessageList(messages),
              ],
            ),
          ),
          _buildQuickPrompts(),
          _buildInputBar(membership.isPro),
        ],
      ),
    );
  }

  Widget _buildMysticEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const _CrystalBallOrb(),
          const SizedBox(height: 24),
          Text(
            'Kaderin fısıltılarını duymak için\nbir adım at...',
            textAlign: TextAlign.center,
            style: AppTypography.display(
              size: 18,
              color: AppPalette.cream.withOpacity(0.6),
            ),
          ).animate().fadeIn(delay: 500.ms).slideY(begin: 0.2),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(36, 24, 36, 18),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: AppPalette.ledViolet.withAlpha(60))),
      ),
      child: Row(
        children: [
          const Icon(Icons.auto_fix_high_rounded, color: AppPalette.ledViolet, size: 28)
              .animate(onComplete: (c) => c.repeat())
              .shimmer(duration: 2.seconds),
          const SizedBox(width: 14),
          Text('Mistik Fal AI', style: AppTypography.display(size: 22, color: AppPalette.cream)),
          const Spacer(),
          const Text('🔮', style: TextStyle(fontSize: 24))
              .animate(onComplete: (c) => c.repeat(reverse: true))
              .scale(end: const Offset(1.2, 1.2), duration: 1.seconds),
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
        if (i == messages.length) return const _MysticTypingIndicator();
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
          labelStyle: AppTypography.label(size: 12, color: AppPalette.cream),
          backgroundColor: AppPalette.ledViolet.withAlpha(30),
          side: BorderSide(color: AppPalette.ledViolet.withAlpha(80)),
          onPressed: () {
            _ctrl.text = _quickPrompts[i];
            _send();
          },
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
              style: AppTypography.body(size: 14, color: AppPalette.cream),
              decoration: InputDecoration(
                hintText: 'Fincanını anlat veya mistik bir soru sor...',
                hintStyle: AppTypography.body(size: 13, color: AppPalette.cream.withAlpha(100)),
                filled: true,
                fillColor: AppPalette.mocha.withAlpha(150),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide(color: AppPalette.ledViolet.withAlpha(60)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: const BorderSide(color: AppPalette.ledViolet),
                ),
              ),
              onSubmitted: (_) => _send(),
            ),
          ),
          const SizedBox(width: 12),
          IconButton.filled(
            onPressed: _send,
            icon: const Icon(Icons.auto_awesome_rounded, color: AppPalette.espresso),
            backgroundColor: AppPalette.ledViolet,
          ).animate(onComplete: (c) => c.repeat())
           .shimmer(delay: 3.seconds),
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

class _CrystalBallOrb extends StatelessWidget {
  const _CrystalBallOrb();
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      height: 160,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            AppPalette.ledViolet.withOpacity(0.5),
            AppPalette.ledViolet.withOpacity(0.2),
            Colors.transparent,
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: AppPalette.ledViolet.withOpacity(0.3),
            blurRadius: 40,
            spreadRadius: 10,
          ),
        ],
      ),
      child: Center(
        child: const Text('🔮', style: TextStyle(fontSize: 70))
            .animate(onComplete: (c) => c.repeat(reverse: true))
            .scale(begin: const Offset(0.9, 0.9), end: const Offset(1.1, 1.1), duration: 2.seconds)
            .shimmer(duration: 3.seconds, color: Colors.white30),
      ),
    );
  }
}

class _MysticTypingIndicator extends StatelessWidget {
  const _MysticTypingIndicator();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Text(
            'Fısıltılar dinleniyor',
            style: AppTypography.body(
              size: 13,
              color: AppPalette.ledViolet.withOpacity(0.7),
              weight: FontWeight.w300,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(width: 8),
          ...List.generate(3, (i) => 
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 2),
              width: 4,
              height: 4,
              decoration: const BoxDecoration(shape: BoxShape.circle, color: AppPalette.ledViolet),
            ).animate(onComplete: (c) => c.repeat())
             .scale(delay: (i * 200).ms, duration: 600.ms, begin: const Offset(0.5, 0.5), end: const Offset(1.5, 1.5))
             .fadeOut(duration: 600.ms),
          ),
        ],
      ),
    );
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
        padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
        decoration: BoxDecoration(
          color: isUser 
              ? AppPalette.ledViolet.withAlpha(30) 
              : AppPalette.mocha.withAlpha(220),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(20),
            topRight: const Radius.circular(20),
            bottomLeft: Radius.circular(isUser ? 20 : 4),
            bottomRight: Radius.circular(isUser ? 4 : 20),
          ),
          border: Border.all(
            color: isUser 
                ? AppPalette.ledViolet.withAlpha(80) 
                : AppPalette.ledViolet.withAlpha(40),
          ),
        ),
        child: Text(
          message.text,
          style: AppTypography.body(size: 14, color: AppPalette.cream, height: 1.5),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms).slideX(begin: isUser ? 0.1 : -0.1);
  }
}