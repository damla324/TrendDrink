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
import 'package:trenddrink/features/paywall/paywall_sheet.dart';
import 'package:trenddrink/features/drink_ai/assistant_notifier.dart';
import 'package:trenddrink/presentation/notifiers/membership_notifier.dart';

class AssistantPage extends ConsumerStatefulWidget {
  const AssistantPage({super.key});

  @override
  ConsumerState<AssistantPage> createState() => _AssistantPageState();
}

class _AssistantPageState extends ConsumerState<AssistantPage> {
  final _ctrl = TextEditingController();
  final _scroll = ScrollController();
  bool _sending = false;
  bool _isDropTarget = false;
  Uint8List? _pendingImage;
  String? _pendingImageName;

  static const _quickPrompts = [
    'Kahve öner',
    'Enerji ver',
    'Sıcak içecek',
    'Elma, limon var',
    'Fit seçenekler',
    'Kokteyl öner',
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
          duration: const Duration(milliseconds: 320),
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

    // Görsel ekleme Pro özelliği
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

    await ref.read(assistantProvider.notifier).sendMessage(
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
    final membership = ref.watch(membershipProvider);
    final messages = ref.watch(assistantProvider);
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
                if (!membership.isPro)
                  _buildQuotaBanner(membership.aiRequestsRemaining),
                _buildHeader(),
                Expanded(
                  child: messages.isEmpty
                      ? _buildEmpty()
                      : _buildMessageList(messages),
                ),
                _buildQuickPrompts(),
                if (_pendingImage != null) _buildPendingImageBar(),
                _buildInputBar(),
              ],
            ),
          ),
          if (_isDropTarget)
            Positioned.fill(
              child: IgnorePointer(
                child: Container(
                  color: AppPalette.ledCyan.withAlpha(40),
                  child: Center(
                    child: FrostedPanel(
                      padding: const EdgeInsets.fromLTRB(36, 28, 36, 28),
                      alpha: 220,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.cloud_upload_rounded,
                              size: 56,
                              color: AppPalette.ledCyan.withAlpha(220)),
                          const SizedBox(height: 12),
                          Text('Görseli buraya bırak',
                              style: AppTypography.display(
                                size: 18,
                                color: AppPalette.cream,
                                letterSpacing: 1.2,
                              )),
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

  Widget _buildQuotaBanner(int remaining) {
    return Container(
      color: remaining == 0
          ? AppPalette.danger.withAlpha(60)
          : AppPalette.gold.withAlpha(28),
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
      child: Row(
        children: [
          Icon(
            remaining == 0 ? Icons.error_outline_rounded : Icons.bolt_rounded,
            size: 16,
            color: remaining == 0 ? AppPalette.danger : AppPalette.gold,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              remaining == 0
                  ? 'Günlük AI kotan bitti. Sohbete devam edebilirsin, ya da Pro\'ya geç.'
                  : 'Günlük AI kullanım hakkın: $remaining',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.body(
                size: 12,
                color: AppPalette.cream,
              ),
            ),
          ),
          TextButton(
            onPressed: () => PaywallSheet.show(context),
            child: Text('Pro\'ya Geç',
                style: AppTypography.label(
                  size: 11,
                  color: AppPalette.gold,
                  letterSpacing: 1.4,
                )),
          )
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.fromLTRB(36, 24, 36, 18),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: AppPalette.gold.withAlpha(28)),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppPalette.aiAccent,
              boxShadow: [
                BoxShadow(
                    color: AppPalette.ledCyan.withAlpha(120), blurRadius: 14),
              ],
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: AppPalette.espresso, size: 22),
          ),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('İçecek AI',
                  style: AppTypography.display(
                    size: 22,
                    color: AppPalette.cream,
                    letterSpacing: 1.0,
                  )),
              Text('Görselden tarif öner • Malzeme analizi',
                  style: AppTypography.body(
                    size: 11.5,
                    color: AppPalette.ledCyan.withAlpha(200),
                  )),
            ],
          ),
          const Spacer(),
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppPalette.ledCyan,
              boxShadow: [
                BoxShadow(
                    color: AppPalette.ledCyan.withAlpha(180), blurRadius: 8),
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 360.ms);
  }

  Widget _buildEmpty() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🍵', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text('Bir içecek sormaya başla',
              style: AppTypography.display(
                size: 18,
                color: AppPalette.dimCream.withAlpha(180),
              )),
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
        if (i == messages.length) return const _TypingIndicator();
        final m = messages[i];
        return _MessageBubble(
          message: m,
          onDrinkTap: m.drinkId != null
              ? () => context.push('/drink/${m.drinkId}')
              : null,
        );
      },
    );
  }

  Widget _buildQuickPrompts() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 6, 36, 6),
      child: SizedBox(
        height: 36,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          itemCount: _quickPrompts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (ctx, i) => _ChipButton(
            label: _quickPrompts[i],
            onTap: () {
              _ctrl.text = _quickPrompts[i];
              _send();
            },
          ),
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
          border: Border.all(color: AppPalette.ledCyan.withAlpha(80)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.memory(_pendingImage!,
                  width: 46, height: 46, fit: BoxFit.cover),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _pendingImageName ?? 'Görsel ekli',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.body(size: 12, color: AppPalette.cream),
              ),
            ),
            IconButton(
              onPressed: () => setState(() {
                _pendingImage = null;
                _pendingImageName = null;
              }),
              icon: Icon(Icons.close_rounded,
                  color: AppPalette.dimCream.withAlpha(180), size: 18),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(36, 10, 36, 24),
      child: Row(
        children: [
          _IconBtn(
            icon: Icons.add_photo_alternate_rounded,
            tooltip: 'Görsel ekle (Pro)',
            onTap: _pickImage,
            highlight: ref.watch(membershipProvider).isPro,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: AppPalette.mocha.withAlpha(160),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppPalette.gold.withAlpha(50)),
              ),
              child: TextField(
                controller: _ctrl,
                style: AppTypography.body(size: 13.5, color: AppPalette.cream),
                decoration: InputDecoration(
                  hintText: 'Malzeme yaz, kategori sor veya görsel sürükle…',
                  hintStyle: AppTypography.body(
                    size: 13,
                    color: AppPalette.dimCream.withAlpha(120),
                  ),
                  border: InputBorder.none,
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
                ),
                onSubmitted: (_) => _send(),
              ),
            ),
          ),
          const SizedBox(width: 10),
          _SendBtn(sending: _sending, onTap: _send),
        ],
      ),
    );
  }
}

// ─── pieces ─────────────────────────────────────────────────────────────────
class _IconBtn extends StatefulWidget {
  const _IconBtn({
    required this.icon,
    required this.onTap,
    required this.tooltip,
    this.highlight = false,
  });
  final IconData icon;
  final VoidCallback onTap;
  final String tooltip;
  final bool highlight;

  @override
  State<_IconBtn> createState() => _IconBtnState();
}

class _IconBtnState extends State<_IconBtn> {
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
            duration: const Duration(milliseconds: 160),
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: _hover
                  ? AppPalette.ledCyan.withAlpha(40)
                  : AppPalette.mocha.withAlpha(140),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: widget.highlight
                    ? AppPalette.ledCyan.withAlpha(120)
                    : AppPalette.gold.withAlpha(50),
              ),
            ),
            child: Icon(widget.icon,
                color: widget.highlight
                    ? AppPalette.ledCyan
                    : AppPalette.dimCream.withAlpha(200),
                size: 20),
          ),
        ),
      ),
    );
  }
}

class _SendBtn extends StatefulWidget {
  const _SendBtn({required this.sending, required this.onTap});
  final bool sending;
  final VoidCallback onTap;
  @override
  State<_SendBtn> createState() => _SendBtnState();
}

class _SendBtnState extends State<_SendBtn> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.sending ? null : widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: _hover && !widget.sending
                ? AppPalette.gold
                : AppPalette.gold.withAlpha(220),
            boxShadow: _hover && !widget.sending
                ? [
                    BoxShadow(
                        color: AppPalette.gold.withAlpha(80), blurRadius: 14)
                  ]
                : [],
          ),
          child: widget.sending
              ? const Center(
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                        strokeWidth: 2, color: AppPalette.espresso),
                  ),
                )
              : const Icon(Icons.send_rounded,
                  color: AppPalette.espresso, size: 20),
        ),
      ),
    );
  }
}

class _ChipButton extends StatefulWidget {
  const _ChipButton({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;
  @override
  State<_ChipButton> createState() => _ChipButtonState();
}

class _ChipButtonState extends State<_ChipButton> {
  bool _hover = false;
  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => _hover = true),
      onExit: (_) => setState(() => _hover = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 160),
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: _hover
                ? AppPalette.gold.withAlpha(40)
                : AppPalette.mocha.withAlpha(150),
            border: Border.all(
              color: _hover
                  ? AppPalette.gold.withAlpha(180)
                  : AppPalette.gold.withAlpha(50),
            ),
          ),
          child: Center(
            child: Text(
              widget.label,
              style: AppTypography.label(
                size: 11,
                color: _hover ? AppPalette.cream : AppPalette.dimCream,
                letterSpacing: 0.8,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

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
          if (!isUser)
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: AppPalette.aiAccent,
              ),
              child: const Icon(Icons.auto_awesome_rounded,
                  size: 16, color: AppPalette.espresso),
            ),
          if (!isUser) const SizedBox(width: 10),
          Flexible(
            child: Column(
              crossAxisAlignment:
                  isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                if (message.imageBytes != null)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.memory(
                        message.imageBytes!,
                        width: 180,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                Container(
                  constraints: const BoxConstraints(maxWidth: 540),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  decoration: BoxDecoration(
                    color: isUser
                        ? AppPalette.gold.withAlpha(36)
                        : AppPalette.mocha.withAlpha(200),
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(14),
                      topRight: const Radius.circular(14),
                      bottomLeft: Radius.circular(isUser ? 14 : 4),
                      bottomRight: Radius.circular(isUser ? 4 : 14),
                    ),
                    border: Border.all(
                      color: isUser
                          ? AppPalette.gold.withAlpha(70)
                          : AppPalette.gold.withAlpha(24),
                    ),
                  ),
                  child: Text(
                    message.text,
                    style: AppTypography.body(
                      size: 13.5,
                      color: AppPalette.cream,
                      height: 1.45,
                    ),
                  ),
                ),
                if (onDrinkTap != null) ...[
                  const SizedBox(height: 6),
                  GestureDetector(
                    onTap: onDrinkTap,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        gradient: AppPalette.goldAccent,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.open_in_new_rounded,
                              size: 14, color: AppPalette.espresso),
                          const SizedBox(width: 6),
                          Text('Tarifi Aç',
                              style: AppTypography.label(
                                size: 11,
                                color: AppPalette.espresso,
                                letterSpacing: 1.2,
                                weight: FontWeight.w800,
                              )),
                        ],
                      ),
                    ),
                  ),
                ]
              ],
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 240.ms);
  }
}

class _TypingIndicator extends StatelessWidget {
  const _TypingIndicator();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14, left: 4),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: AppPalette.aiAccent,
            ),
            child: const Icon(Icons.auto_awesome_rounded,
                color: AppPalette.espresso, size: 16),
          ),
          const SizedBox(width: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: AppPalette.mocha.withAlpha(180),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                for (var i = 0; i < 3; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 2),
                    child: Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppPalette.ledCyan,
                      ),
                    )
                        .animate(
                          onComplete: (c) => c.repeat(reverse: true),
                          delay: Duration(milliseconds: i * 120),
                        )
                        .scale(
                            begin: const Offset(0.5, 0.5),
                            end: const Offset(1.2, 1.2),
                            duration: 480.ms),
                  )
              ],
            ),
          ),
        ],
      ),
    );
  }
}