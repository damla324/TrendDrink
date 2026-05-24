import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:trenddrink/core/i18n/app_strings.dart';
import 'package:trenddrink/core/theme/app_palette.dart';
import 'package:trenddrink/core/theme/app_typography.dart';
import 'package:trenddrink/presentation/notifiers/assistant_notifier.dart';

// ── Provider ───────────────────────────────────────────────────────────────────
final _chatbotOpenProvider = NotifierProvider<_ChatbotOpenNotifier, bool>(
  _ChatbotOpenNotifier.new,
);

class _ChatbotOpenNotifier extends Notifier<bool> {
  @override
  bool build() => false;
  void toggle() => state = !state;
}

/// Floating chatbot bubble — add to ShellPage Stack as a Positioned widget.
class FloatingChatbot extends ConsumerStatefulWidget {
  const FloatingChatbot({super.key});

  @override
  ConsumerState<FloatingChatbot> createState() => _FloatingChatbotState();
}

class _FloatingChatbotState extends ConsumerState<FloatingChatbot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseCtrl;
  final TextEditingController _inputCtrl = TextEditingController();
  final ScrollController _scrollCtrl = ScrollController();

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _inputCtrl.dispose();
    _scrollCtrl.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollCtrl.hasClients) {
        _scrollCtrl.animateTo(
          _scrollCtrl.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isOpen = ref.watch(_chatbotOpenProvider);
    final messages = ref.watch(assistantProvider);
    final s = ref.watch(appStringsProvider);

    if (messages.length > 1) _scrollToBottom();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        // ── Chat panel ─────────────────────────────────────────────────────
        if (isOpen)
          _ChatPanel(
            messages: messages,
            scrollCtrl: _scrollCtrl,
            inputCtrl: _inputCtrl,
            s: s,
            onSend: () {
              final text = _inputCtrl.text.trim();
              if (text.isEmpty) return;
              _inputCtrl.clear();
              ref.read(assistantProvider.notifier).sendMessage(text);
            },
          ).animate().fadeIn(duration: 250.ms).slideY(begin: 0.08),

        const SizedBox(height: 12),

        // ── LED Pulse Button ────────────────────────────────────────────────
        _LedButton(
          pulseCtrl: _pulseCtrl,
          isOpen: isOpen,
          onTap: () => ref.read(_chatbotOpenProvider.notifier).toggle(),
        ),
      ],
    );
  }
}

// ── Chat Panel ────────────────────────────────────────────────────────────────
class _ChatPanel extends StatelessWidget {
  const _ChatPanel({
    required this.messages,
    required this.scrollCtrl,
    required this.inputCtrl,
    required this.s,
    required this.onSend,
  });

  final List messages;
  final ScrollController scrollCtrl;
  final TextEditingController inputCtrl;
  final AppStrings s;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          width: 340,
          height: 440,
          decoration: BoxDecoration(
            color: AppPalette.obsidian.withAlpha(190),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppPalette.ledCyan.withAlpha(80)),
            boxShadow: [
              BoxShadow(
                color: AppPalette.ledCyan.withAlpha(40),
                blurRadius: 24,
                spreadRadius: 2,
              ),
            ],
          ),
          child: Column(
            children: [
              // Header
              _ChatHeader(s: s),
              // Messages
              Expanded(
                child: ListView.builder(
                  controller: scrollCtrl,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                  itemCount: messages.length,
                  itemBuilder: (_, i) => _MessageBubble(message: messages[i]),
                ),
              ),
              // Input
              _ChatInput(ctrl: inputCtrl, s: s, onSend: onSend),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChatHeader extends StatelessWidget {
  const _ChatHeader({required this.s});
  final AppStrings s;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppPalette.espresso.withAlpha(130),
        border:
            Border(bottom: BorderSide(color: AppPalette.ledCyan.withAlpha(50))),
      ),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  AppPalette.ledCyan.withAlpha(200),
                  AppPalette.gold.withAlpha(200),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: AppPalette.ledCyan.withAlpha(80),
                  blurRadius: 8,
                ),
              ],
            ),
            child: const Icon(Icons.smart_toy_rounded,
                color: AppPalette.espresso, size: 16),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.chatbotName,
                  style: AppTypography.label(
                      size: 12,
                      color: AppPalette.cream,
                      letterSpacing: 0.8,
                      weight: FontWeight.w700)),
              Text(s.isTr ? 'İçecek Asistanı' : 'Drink Assistant',
                  style: AppTypography.body(
                      size: 10, color: AppPalette.ledCyan.withAlpha(200))),
            ],
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFF2ECC71),
              boxShadow: [
                BoxShadow(
                    color: const Color(0xFF2ECC71).withAlpha(120),
                    blurRadius: 6),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _MessageBubble extends StatelessWidget {
  const _MessageBubble({required this.message});
  final dynamic message;

  @override
  Widget build(BuildContext context) {
    final isUser = message.author.toString().contains('user');
    return Padding(
      padding: EdgeInsets.only(
        bottom: 10,
        left: isUser ? 40 : 0,
        right: isUser ? 0 : 40,
      ),
      child: Align(
        alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: isUser
                ? AppPalette.gold.withAlpha(35)
                : AppPalette.mocha.withAlpha(160),
            borderRadius: BorderRadius.only(
              topLeft: const Radius.circular(14),
              topRight: const Radius.circular(14),
              bottomLeft: Radius.circular(isUser ? 14 : 4),
              bottomRight: Radius.circular(isUser ? 4 : 14),
            ),
            border: Border.all(
              color: isUser
                  ? AppPalette.gold.withAlpha(60)
                  : AppPalette.ledCyan.withAlpha(35),
            ),
          ),
          child: Text(
            message.text as String,
            style: GoogleFonts.plusJakartaSans(
              fontSize: 12,
              color: isUser
                  ? AppPalette.cream
                  : AppPalette.dimCream.withAlpha(220),
              height: 1.5,
            ),
          ),
        ),
      ),
    );
  }
}

class _ChatInput extends StatelessWidget {
  const _ChatInput({required this.ctrl, required this.s, required this.onSend});
  final TextEditingController ctrl;
  final AppStrings s;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: AppPalette.espresso.withAlpha(100),
        border: Border(top: BorderSide(color: AppPalette.gold.withAlpha(30))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: ctrl,
              style: GoogleFonts.plusJakartaSans(
                  fontSize: 12.5, color: AppPalette.cream),
              decoration: InputDecoration(
                hintText: s.chatHint,
                hintStyle: GoogleFonts.plusJakartaSans(
                    fontSize: 12, color: AppPalette.dimCream.withAlpha(120)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppPalette.gold.withAlpha(40)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: AppPalette.gold.withAlpha(40)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppPalette.ledCyan.withAlpha(160)),
                ),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
                filled: true,
                fillColor: AppPalette.mocha.withAlpha(100),
              ),
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: onSend,
            child: Container(
              width: 38,
              height: 38,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    AppPalette.ledCyan.withAlpha(200),
                    AppPalette.gold.withAlpha(180),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                      color: AppPalette.ledCyan.withAlpha(60), blurRadius: 8),
                ],
              ),
              child: const Icon(Icons.send_rounded,
                  color: AppPalette.espresso, size: 16),
            ),
          ),
        ],
      ),
    );
  }
}

// ── LED Pulse Button ──────────────────────────────────────────────────────────
class _LedButton extends StatefulWidget {
  const _LedButton({
    required this.pulseCtrl,
    required this.isOpen,
    required this.onTap,
  });
  final AnimationController pulseCtrl;
  final bool isOpen;
  final VoidCallback onTap;
  @override
  State<_LedButton> createState() => _LedButtonState();
}

class _LedButtonState extends State<_LedButton> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedBuilder(
          animation: widget.pulseCtrl,
          builder: (_, child) {
            final pulse = widget.pulseCtrl.value;
            return Stack(
              alignment: Alignment.center,
              children: [
                // Outer glow ring
                Container(
                  width: 66 + pulse * 8,
                  height: 66 + pulse * 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color:
                        AppPalette.ledCyan.withAlpha((20 + pulse * 30).toInt()),
                  ),
                ),
                // Mid ring
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    border: Border.all(
                      color: AppPalette.ledCyan
                          .withAlpha((80 + pulse * 100).toInt()),
                      width: 1.5,
                    ),
                  ),
                ),
                // Button body
                child!,
              ],
            );
          },
          child: ClipOval(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: _hovered || widget.isOpen
                        ? [
                            AppPalette.ledCyan.withAlpha(220),
                            AppPalette.gold.withAlpha(200),
                          ]
                        : [
                            AppPalette.obsidian.withAlpha(220),
                            AppPalette.mocha.withAlpha(200),
                          ],
                  ),
                  border: Border.all(
                    color: AppPalette.ledCyan
                        .withAlpha(_hovered || widget.isOpen ? 200 : 100),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppPalette.ledCyan
                          .withAlpha(_hovered || widget.isOpen ? 120 : 50),
                      blurRadius: _hovered ? 20 : 10,
                    ),
                  ],
                ),
                child: Center(
                  child: widget.isOpen
                      ? const Icon(Icons.close_rounded,
                          color: AppPalette.espresso, size: 22)
                      : const Icon(Icons.smart_toy_rounded,
                          color: AppPalette.cream, size: 22),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
