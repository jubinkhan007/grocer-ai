import 'package:flutter/material.dart';
import '../../../ui/theme/app_theme.dart';

/// Call showCopilotSheet(context) from your FAB.
/// Draggable, with a fixed header and rounded top like the mock.
Future<void> showCopilotSheet(BuildContext context) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withOpacity(.25),
    builder: (_) => const _CopilotSheet(),
  );
}

class _CopilotSheet extends StatefulWidget {
  const _CopilotSheet();

  @override
  State<_CopilotSheet> createState() => _CopilotSheetState();
}

class _CopilotSheetState extends State<_CopilotSheet> {
  final TextEditingController _text = TextEditingController();

  // Static demo data (swap with your chat controller later)
  final List<_Msg> _messages = [
    _Msg(bot: true,  time: '7:20', text: 'Minimum text check, Hide check icon'),
    _Msg(bot: false, time: '7:20', text: '👍'),
    _Msg(
      bot: true,
      time: '7:20',
      text:
      'Rapidly build stunning Web Apps with Frest ✨\n'
          'Developer friendly, Highly customizable & Carefully crafted\n'
          'HTML Admin Dashboard Template.',
      rich: true,
    ),
    _Msg(bot: true, time: '7:20', text: 'More no. of lines text and showing complete list of features like time stamp + check icon READ'),
  ];

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.78,
      minChildSize: 0.45,
      maxChildSize: 0.97,
      builder: (_, controller) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 12)],
          ),
          child: Column(
            children: [
              _Header(onClose: () => Navigator.of(context).pop()),
              const Divider(height: 1),
              Expanded(
                child: ListView.builder(
                  controller: controller,
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  itemCount: _messages.length,
                  itemBuilder: (_, i) => _Bubble(msg: _messages[i]),
                ),
              ),
              const SizedBox(height: 8),
              _QuickChips(
                onTap: (s) => setState(() => _text.text = s),
              ),
              const SizedBox(height: 8),
              _InputBar(
                controller: _text,
                onSend: () {
                  final t = _text.text.trim();
                  if (t.isEmpty) return;
                  setState(() {
                    _messages.add(_Msg(bot: false, time: '7:21', text: t));
                  });
                  _text.clear();
                  // TODO: Send to your bot backend and append responses.
                },
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onClose});
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 64,
      decoration: BoxDecoration(
        color: AppColors.teal,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: [
          const _BotCircle(),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text('Copilot',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 16)),
                SizedBox(height: 2),
                Row(
                  children: [
                    Icon(Icons.circle, size: 8, color: Color(0xFF2ECC71)),
                    SizedBox(width: 6),
                    Text('Online', style: TextStyle(color: Colors.white70)),
                  ],
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: const Icon(Icons.remove, color: Colors.white),
            tooltip: 'Minimize',
          ),
        ],
      ),
    );
  }
}

class _BotCircle extends StatelessWidget {
  const _BotCircle();

  @override
  Widget build(BuildContext context) {
    // Swap with your mascot asset if you have one.
    return CircleAvatar(
      radius: 18,
      backgroundColor: Colors.white,
      child: Icon(Icons.smart_toy_rounded, color: AppColors.teal, size: 22),
    );
  }
}

class _QuickChips extends StatelessWidget {
  const _QuickChips({required this.onTap});
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    final items = const ['🤖 What is WappGPT?', '💰 Pricing', '📚 FAQs'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Wrap(
        spacing: 8,
        children: items
            .map((t) => ActionChip(
          label: Text(t),
          onPressed: () => onTap(t),
          backgroundColor: const Color(0xFFF0F3F5),
          side: BorderSide.none,
        ))
            .toList(),
      ),
    );
  }
}

class _InputBar extends StatelessWidget {
  const _InputBar({required this.controller, required this.onSend});
  final TextEditingController controller;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 46,
              decoration: BoxDecoration(
                color: const Color(0xFFF4F7F9),
                borderRadius: BorderRadius.circular(26),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: 'Type you message here',
                  border: InputBorder.none,
                  isCollapsed: true,
                ),
                minLines: 1,
                maxLines: 4,
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 46,
            width: 46,
            child: ElevatedButton(
              onPressed: onSend,
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.zero,
                backgroundColor: AppColors.teal,
                shape: const CircleBorder(),
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------- Bubbles ----------
class _Msg {
  final bool bot;
  final String time;
  final String text;
  final bool rich;
  _Msg({required this.bot, required this.time, required this.text, this.rich = false});
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.msg});
  final _Msg msg;

  @override
  Widget build(BuildContext context) {
    final isBot = msg.bot;
    final bg = isBot ? AppColors.card : AppColors.teal;
    final fg = isBot ? AppColors.text : Colors.white;

    final bubble = Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
      constraints: const BoxConstraints(maxWidth: 280),
      decoration: BoxDecoration(
        color: isBot ? Colors.white : bg,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(16),
          topRight: const Radius.circular(16),
          bottomLeft: Radius.circular(isBot ? 4 : 16),
          bottomRight: Radius.circular(isBot ? 16 : 4),
        ),
        boxShadow: isBot
            ? [BoxShadow(color: Colors.black.withOpacity(.06), blurRadius: 8)]
            : null,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(msg.text,
              style: TextStyle(
                color: fg,
                height: 1.35,
                fontWeight: msg.rich ? FontWeight.w600 : FontWeight.w400,
              )),
          const SizedBox(height: 6),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(msg.time,
                  style: TextStyle(
                    color: isBot ? AppColors.subtext : Colors.white70,
                    fontSize: 12,
                  )),
              if (!isBot) ...const [
                SizedBox(width: 6),
                Icon(Icons.done_all, size: 16, color: Colors.white70),
              ],
            ],
          ),
        ],
      ),
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
        isBot ? MainAxisAlignment.start : MainAxisAlignment.end,
        children: [
          if (isBot) const _BotCircle(),
          if (isBot) const SizedBox(width: 8),
          bubble,
          if (!isBot) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 16,
              backgroundImage: AssetImage('assets/avatar_placeholder.png'),
            ),
          ],
        ],
      ),
    );
  }
}
