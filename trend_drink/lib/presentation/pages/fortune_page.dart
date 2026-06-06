import 'dart:typed_data';
import 'package:desktop_drop/desktop_drop.dart';
import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/core/widgets/frosted_panel.dart';
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
  bool _isDropTarget = false;
  Uint8List? _pendingImage;
  String? _pendingImageName;

  static const _quickPrompts = [
    'Fincanımı yorumla 🔮',
    'Aşk hayatımda neler var? ❤️',
    'Kariyer yolum açık mı? 💼',
    'Yüreğim neden kabarık? ✨',
    'Günün mesajını fısılda 🌟'
  ];

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent + 100,
          duration: 320.ms,
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send() async {
    final text = _ctrl.text.trim();
    final img = _pendingImage;
    if (text.isEmpty && img == null) return;
    if (_sending) return;

    final membership = ref.read(membershipProvider);
    if (img != null && !membership.isPro) {
      PaywallSheet.show(context);
      return;
    }

    _ctrl.clear();
    setState(() {
      _sending = true;
      _pendingImage = null;
      _pendingImageName = null;
    });

    await ref.read(fortuneProvider.notifier).sendMessage(
          text,
          imageBytes: img,
          imageName: _pendingImageName,
        );

    if (!membership.isPro) {
      ref.read(membershipProvider.notifier).consumeAIRequest();
    }

    if (mounted) setState(() => _sending = false);
    _scrollToBottom();
  }

  Future<void> _pickImage() async {
    final membership = ref.read(membershipProvider);
    if (!membership.isPro) {
      PaywallSheet.show(context);
      return;
    }
    const typeGroup = XTypeGroup(
      label: 'images',
      extensions: ['jpg', 'jpeg', 'png', 'webp'],
    );
    final file = await openFile(acceptedTypeGroups: [typeGroup]);
    if (file == null) return;
    final bytes = await file.readAsBytes();
    setState(() {
      _pendingImage = bytes;
      _pendingImageName = file.name;
    });
  }

  Future<void> _onDrop(DropDoneDetails details) async {
    final membership = ref.read(membershipProvider);
    if (!membership.isPro) {
      PaywallSheet.show(context);
      return;
    }
    setState(() => _isDropTarget = false);
    if (details.files.isEmpty) return;
    final f = details.files.first;
    final bytes = await f.readAsBytes();
    setState(() {
      _pendingImage = bytes;
      _pendingImageName = f.name;
    });
  }

  @override
  Widget build(BuildContext context) {
    final messages = ref.watch(fortuneProvider);
    final membership = ref.watch(membershipProvider);
    _scrollToBottom();

    return DropTarget(
      onDragEntered: (_) {
        if (membership.isPro) setState(() => _isDropTarget = true);
      },
      onDragExited: (_) => setState(() => _isDropTarget = false),
      onDragDone: _onDrop,
      child: Stack(
        children: [
          Scaffold(
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
                if (_pendingImage != null) _buildPendingImageBar(),
                _buildInputBar(membership.isPro),
              ],
            ),
          ),
          if (_isDropTarget)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: AppPalette.ledViolet.withAlpha(40),
                  child: Center(
                    child: FrostedPanel(
                      padding: const EdgeInsets.all(36),
                      alpha: 220,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.auto_fix_high_rounded, size: 56, color: AppPalette.ledViolet),
                          const SizedBox(height: 12),
                          Text('Fincanı buraya bırak...',
                              style: AppTypography.display(size: 18, color: AppPalette.cream)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
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
          Text('TrendMystic', style: AppTypography.display(size: 22, color: AppPalette.cream)),
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
      padding: const EdgeInsets.fromLTRB(36, 14, 36, 10),
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

  Widget _buildPendingImageBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 4, 36, 0),
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppPalette.mocha.withAlpha(170),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppPalette.ledViolet.withAlpha(80)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(_pendingImage!, width: 46, height: 46, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _pendingImageName ?? 'Görsel ekli',
                style: AppTypography.body(size: 12, color: AppPalette.cream),
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                _pendingImage = null;
                _pendingImageName = null;
              }),
              icon: const Icon(Icons.close_rounded, color: AppPalette.dimCream, size: 18),
            ),
          ],
        ),
      ),
    ).animate().slideY(begin: 0.2, curve: Curves.easeOut);
  }

  Widget _buildInputBar(bool isPro) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 10, 36, 24),
      child: Row(
        children: [
          _MysticIconBtn(
            icon: Icons.add_a_photo_rounded,
            onTap: _pickImage,
            tooltip: 'Fincan resmi gönder (Pro)',
            highlight: isPro,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppPalette.mocha.withAlpha(150),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppPalette.ledViolet.withAlpha(60)),
              ),
              child: TextField(
                controller: _ctrl,
                style: AppTypography.body(size: 14, color: AppPalette.cream),
                decoration: InputDecoration(
                  hintText: 'Fincanını anlat veya bir soru sor...',
                  hintStyle: AppTypography.body(size: 13, color: AppPalette.cream.withAlpha(100)),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          IconButton.filled(
            onPressed: _send,
            icon: _sending 
              ? const SizedBox(width: 18, height: 18, child: CircularProgressIndicator(strokeWidth: 2, color: AppPalette.espresso))
              : const Icon(Icons.auto_awesome_rounded, color: AppPalette.espresso),
            style: IconButton.styleFrom(backgroundColor: AppPalette.ledViolet),
            constraints: const BoxConstraints.tightFor(width: 48, height: 48),
          ).animate(onComplete: (c) => c.repeat()).shimmer(delay: 3.seconds),
        ],
      ),
    );
  }
}

class _MysticIconBtn extends StatefulWidget {
  const _MysticIconBtn({required this.icon, required this.onTap, required this.tooltip, this.highlight = false});
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool highlight;
  @override
  State<_MysticIconBtn> createState() => _MysticIconBtnState();
}

class _MysticIconBtnState extends State<_MysticIconBtn> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _hover = true),
        onExit: (_) => setState(() => _hover = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: 160.ms,
            width: 46, height: 46,
            decoration: BoxDecoration(
              color: _hover ? AppPalette.ledViolet.withAlpha(40) : AppPalette.mocha.withAlpha(140),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: widget.highlight ? AppPalette.ledViolet.withAlpha(120) : AppPalette.ledViolet.withAlpha(40)),
            ),
            child: Icon(widget.icon, color: widget.highlight ? AppPalette.ledViolet : AppPalette.dimCream, size: 20),
          ),
        ),
      ),
    );
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
            ).copyWith(fontStyle: FontStyle.italic),
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