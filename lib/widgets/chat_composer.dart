import 'package:flutter/material.dart';
import 'package:intro_to_genui/theme/app_theme.dart';

class ChatComposer extends StatelessWidget {
  const ChatComposer({
    super.key,
    required this.controller,
    required this.isWaiting,
    required this.onSend,
  });

  final TextEditingController controller;
  final bool isWaiting;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(top: BorderSide(color: AppColors.border)),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                  enabled: !isWaiting,
                  minLines: 1,
                  maxLines: 4,
                  textInputAction: TextInputAction.send,
                  onSubmitted: isWaiting ? null : (_) => onSend(),
                  style: const TextStyle(fontSize: 15),
                  decoration: InputDecoration(
                    hintText: isWaiting ? 'Waiting for response…' : 'Message your planner',
                  ),
                ),
              ),
              const SizedBox(width: 10),
              _SendButton(isWaiting: isWaiting, onSend: onSend),
            ],
          ),
        ),
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({required this.isWaiting, required this.onSend});

  final bool isWaiting;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: isWaiting ? AppColors.borderSubtle : AppColors.primary,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: isWaiting ? null : onSend,
        borderRadius: BorderRadius.circular(12),
        child: SizedBox(
          width: 48,
          height: 48,
          child: isWaiting
              ? const Padding(
                  padding: EdgeInsets.all(14),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: AppColors.textMuted,
                  ),
                )
              : const Icon(Icons.arrow_upward_rounded, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}
