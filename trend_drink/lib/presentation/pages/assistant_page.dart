import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/models/chat_message.dart';
import 'package:trenddrink/core/theme/app_theme.dart';
import 'package:trenddrink/presentation/notifiers/assistant_notifier.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';

class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key});

  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage> {
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _sending = false;

  static const List<String> _quickPrompts = [
    'Kahve öner',
    'Enerji ver',
    'Sıcak içecek',
    'Elma, limon var',
    'Fit seçenekler',
    'Kokteyl öner',
  ];

  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 100,
          duration: const Duration(milliseconds: 320),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _send(String text) async {
    final msg = text.trim();
    if (msg.isEmpty || _sending) return;
    final membership = ref.read(membershipProvider);
    
    // Check if user can send AI requests
    if (!membership.isPro && membership.aiRequestsRemaining <= 0) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
              'Daily AI requests limit reached. Upgrade to Pro for unlimited access!',
            ),
            backgroundColor: Theme.of(context).colorScheme.error,
            action: SnackBarAction(
              label: 'Upgrade',
              onPressed: () => context.go('/pro'),
            ),
          ),
        );
      }
      return;
    }
    
    _controller.clear();
    setState(() => _sending = true);
    await ref.read(assistantProvider.notifier).sendMessage(msg);
    
    // Consume AI request if not pro
    if (!membership.isPro) {
      ref.read(membershipProvider.notifier).consumeAIRequest();
    }
    
    setState(() => _sending = false);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final membership = ref.watch(membershipProvider);
    final colors = Theme.of(context).colorScheme;
    
    // Gate AI feature for non-pro members with no requests
    if (!membership.isPro && membership.aiRequestsRemaining <= 0) {
      return Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Icon(
                    Icons.lock_outline,
                    size: 80,
                    color: colors.primary,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'AI Assistant Locked',
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'You have used all your daily AI requests.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Upgrade to Pro for unlimited AI assistance!',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: colors.onSurfaceVariant,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  FilledButton.icon(
                    onPressed: () => context.go('/pro'),
                    icon: const Icon(Icons.star),
                    label: const Text('Upgrade to Pro Now'),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Get unlimited AI requests, premium themes, and more!',
                    style: Theme.of(context).textTheme.labelLarge?.copyWith(
                      color: colors.primary,
                      fontWeight: FontWeight.w600,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    // Show remaining requests banner for free users
    final messages = ref.watch(assistantProvider);
    _scrollToBottom();

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          if (!membership.isPro)
            Container(
              color: colors.primaryContainer,
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(Icons.info, color: colors.primary, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'AI Requests: ${membership.aiRequestsRemaining}/${membership.maxDailyAIRequests} remaining',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ),
                  TextButton(
                    onPressed: () => context.go('/pro'),
                    child: Text(
                      'Upgrade',
                      style: TextStyle(color: colors.primary),
                    ),
                  ),
                ],
              ),
            ),
          _buildHeader(),
          Expanded(
            child: messages.isEmpty
                ? _buildEmptyState()
                : _buildMessageList(messages),
          ),
          _buildQuickPrompts(),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final hPad = isMobile ? 16.0 : 36.0;
    return Container(
      padding: EdgeInsets.fromLTRB(
          hPad, isMobile ? 16 : 28, hPad, isMobile ? 14 : 20),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppTheme.gold.withAlpha(25), width: 1),
        ),
      ),
      child: Row(
        children: [
          // AI Avatar
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppTheme.ledCyan.withAlpha(40),
                  AppTheme.ledCyan.withAlpha(15),
                ],
              ),
              border: Border.all(
                color: AppTheme.ledCyan.withAlpha(120),
                width: 1.5,
              ),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.ledCyan.withAlpha(50),
                  blurRadius: 12,
                ),
              ],
            ),
            child: const Center(
              child: Text('✨', style: TextStyle(fontSize: 22)),
            ),
          ),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'İçecek AI',
                style: GoogleFonts.playfairDisplay(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.cream,
                ),
              ),
              Text(
                'Kişisel içecek asistanın',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  color: AppTheme.ledCyan.withAlpha(200),
                ),
              ),
            ],
          ),
          const Spacer(),
          _LedPulse(),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍵', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 16),
          Text(
            'Bir içecek sormaya başla',
            style: GoogleFonts.playfairDisplay(
              fontSize: 22,
              color: AppTheme.dimCream.withAlpha(180),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList(List<ChatMessage> messages) {
    final hPad = MediaQuery.sizeOf(context).width < 768 ? 16.0 : 36.0;
    return ListView.builder(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(hPad, 20, hPad, 8),
      itemCount: messages.length + (_sending ? 1 : 0),
      itemBuilder: (context, index) {
        if (index == messages.length) {
          return _TypingIndicator();
        }
        final msg = messages[index];
        return _MessageBubble(
          message: msg,
          onDrinkTap: msg.drinkId != null
              ? () => context.go('/drink/${msg.drinkId}')
              : null,
        );
      },
    );
  }

  Widget _buildQuickPrompts() {
    final hPad = MediaQuery.sizeOf(context).width < 768 ? 16.0 : 36.0;
    return Padding(
      padding: EdgeInsets.fromLTRB(hPad, 8, hPad, 0),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _quickPrompts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (context, i) {
            return _QuickChip(
              label: _quickPrompts[i],
              onTap: () => _send(_quickPrompts[i]),
            );
          },
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    final isMobile = MediaQuery.sizeOf(context).width < 768;
    final hPad = isMobile ? 16.0 : 36.0;
    return Container(
      padding: EdgeInsets.fromLTRB(hPad, 14, hPad, isMobile ? 20 : 28),
      child: Row(
        children: [
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.mocha.withAlpha(160),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: AppTheme.gold.withAlpha(50),
                  width: 1,
                ),
              ),
              child: TextField(
                controller: _controller,
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 14,
                  color: AppTheme.cream,
                ),
                decoration: InputDecoration(
                  hintText: 'Malzeme veya kategori yaz…',
                  hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 14,
                    color: AppTheme.dimCream.withAlpha(100),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                onSubmitted: _send,
              ),
            ),
          ),
          const SizedBox(width: 10),
          _SendButton(
            sending: _sending,
            onTap: () => _send(_controller.text),
          ),
        ],
      ),
    );
  }
}

// ── Send Button ───────────────────────────────────────────────────────────
class _SendButton extends StatefulWidget {
  const _SendButton({required this.sending, required this.onTap});
  final bool sending;
  final VoidCallback onTap;

  @override
  State<_SendButton> createState() => _SendButtonState();
}

class _SendButtonState extends State<_SendButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.sending ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: _hovered && !widget.sending
                ? AppTheme.gold.withAlpha(230)
                : AppTheme.gold.withAlpha(200),
            boxShadow: _hovered && !widget.sending
                ? [
                    BoxShadow(
                        color: AppTheme.gold.withAlpha(60), blurRadius: 12)
                  ]
                : [],
          ),
          child: widget.sending
              ? const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Color(0xFF120B04),
                    ),
                  ),
                )
              : const Icon(
                  Icons.send_rounded,
                  color: Color(0xFF120B04),
                  size: 20,
                ),
        ),
      ),
    );
  }
}

// ── Message Bubble ────────────────────────────────────────────────────────
class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message, this.onDrinkTap});
  final ChatMessage message;
  final VoidCallback? onDrinkTap;

  bool get isUser => message.author == ChatAuthor.user;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          if (!isUser) _AssistantAvatar(),
          if (!isUser) const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Container(
                  constraints: const BoxConstraints(maxWidth: 520),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppTheme.gold.withAlpha(30)
                        : AppTheme.mocha.withAlpha(200),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isUser ? 14 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 14),
                    ),
                    border: Border.all(
                      color: isUser
                          ? AppTheme.gold.withAlpha(60)
                          : AppTheme.gold.withAlpha(20),
                      width: 1,
                    ),
                  ),
                  child: _RichText(text: message.text, isUser: isUser),
                ),
                if (onDrinkTap != null) ...[
                  const SizedBox(height: 6),
                  _DrinkLinkChip(onTap: onDrinkTap!),
                ],
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 350.ms).slideY(begin: 0.08, end: 0);
  }
}

class _RichText extends StatelessWidget {
  const _RichText({required this.text, required this.isUser});
  final String text;
  final bool isUser;

  @override
  Widget build(BuildContext context) {
    // Simple bold parsing: **text**
    final boldPattern = RegExp(r'\*\*(.*?)\*\*');
    final spans = <TextSpan>[];
    final allMatches = boldPattern.allMatches(text).toList();

    int lastEnd = 0;
    for (final match in allMatches) {
      if (match.start > lastEnd) {
        spans.add(TextSpan(text: text.substring(lastEnd, match.start)));
      }
      spans.add(TextSpan(
        text: match.group(1),
        style: const TextStyle(fontWeight: FontWeight.w700),
      ));
      lastEnd = match.end;
    }
    if (lastEnd < text.length) {
      spans.add(TextSpan(text: text.substring(lastEnd)));
    }

    return RichText(
      text: TextSpan(
        style: GoogleFonts.plusJakartaSans(
          fontSize: 13.5,
          color: isUser ? AppTheme.cream : AppTheme.dimCream.withAlpha(220),
          height: 1.6,
        ),
        children: spans,
      ),
    );
  }
}

class _DrinkLinkChip extends StatefulWidget {
  const _DrinkLinkChip({required this.onTap});
  final VoidCallback onTap;

  @override
  State<_DrinkLinkChip> createState() => _DrinkLinkChipState();
}

class _DrinkLinkChipState extends State<_DrinkLinkChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.gold.withAlpha(30)
                : AppTheme.gold.withAlpha(15),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.gold.withAlpha(80), width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.open_in_new_rounded, size: 13, color: AppTheme.gold),
              const SizedBox(width: 6),
              Text(
                'Detayı Gör',
                style: GoogleFonts.plusJakartaSans(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.gold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Quick Chip ─────────────────────────────────────────────────────────────
class _QuickChip extends StatefulWidget {
  const _QuickChip({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  State<_QuickChip> createState() => _QuickChipState();
}

class _QuickChipState extends State<_QuickChip> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
          decoration: BoxDecoration(
            color: _hovered
                ? AppTheme.mocha.withAlpha(220)
                : AppTheme.mocha.withAlpha(140),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: _hovered
                  ? AppTheme.gold.withAlpha(80)
                  : AppTheme.gold.withAlpha(30),
              width: 1,
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: GoogleFonts.plusJakartaSans(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _hovered ? AppTheme.cream : AppTheme.dimCream,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// ── Typing Indicator ──────────────────────────────────────────────────────
class _TypingIndicator extends StatefulWidget {
  @override
  State<_TypingIndicator> createState() => _TypingIndicatorState();
}

class _TypingIndicatorState extends State<_TypingIndicator>
    with TickerProviderStateMixin {
  final List<AnimationController> _controllers = [];
  final List<Animation<double>> _animations = [];

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < 3; i++) {
      final c = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 500),
      );
      _controllers.add(c);
      _animations.add(Tween<double>(begin: 0, end: -6).animate(
        CurvedAnimation(parent: c, curve: Curves.easeInOut),
      ));
      Future.delayed(Duration(milliseconds: i * 160), () {
        if (mounted) c.repeat(reverse: true);
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          _AssistantAvatar(),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: AppTheme.mocha.withAlpha(200),
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(14),
                topRight: Radius.circular(14),
                bottomRight: Radius.circular(14),
                bottomLeft: Radius.circular(4),
              ),
              border: Border.all(color: AppTheme.gold.withAlpha(20), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                3,
                (i) => AnimatedBuilder(
                  animation: _animations[i],
                  builder: (context, _) => Transform.translate(
                    offset: Offset(0, _animations[i].value),
                    child: Container(
                      margin: EdgeInsets.only(right: i < 2 ? 4 : 0),
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppTheme.gold.withAlpha(180),
                      ),
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
}

// ── Small reusable pieces ─────────────────────────────────────────────────
class _AssistantAvatar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppTheme.ledCyan.withAlpha(25),
        border: Border.all(color: AppTheme.ledCyan.withAlpha(80), width: 1),
      ),
      child: const Center(
        child: Text('✨', style: TextStyle(fontSize: 14)),
      ),
    );
  }
}

class _LedPulse extends StatefulWidget {
  @override
  State<_LedPulse> createState() => _LedPulseState();
}

class _LedPulseState extends State<_LedPulse>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (_, __) => Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppTheme.ledCyan,
              boxShadow: [
                BoxShadow(
                  color:
                      AppTheme.ledCyan.withAlpha((80 + _c.value * 140).round()),
                  blurRadius: 8,
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),
          Text(
            'Çevrimiçi',
            style: GoogleFonts.plusJakartaSans(
              fontSize: 11,
              color: AppTheme.ledCyan.withAlpha((140 + _c.value * 115).round()),
            ),
          ),
        ],
      ),
    );
  }
}
