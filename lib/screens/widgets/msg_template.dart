import 'package:flutter/material.dart';
import '../../config/lang.dart';

class MessageTemplateList extends StatelessWidget {
  const MessageTemplateList({
    super.key,
    required this.samples,
    required this.onAdd,
    required this.onSelect,
    required this.onLongPress,
  });

  final List<String> samples;
  final VoidCallback onAdd;
  final ValueChanged<String> onSelect;
  final ValueChanged<String> onLongPress;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        spacing: 8,
        children: [
          ActionChip(
            avatar: const Icon(Icons.add, size: 18),
            label: Text(t('custom')),
            onPressed: onAdd,
          ),
          for (final sample in samples)
            Tooltip(
              message: t('holdDelete'),
              child: GestureDetector(
                onLongPress: () => onLongPress(sample),
                child: ActionChip(
                  label: Text(
                    sample.length > 15
                        ? '${sample.substring(0, 15)}...'
                        : sample,
                  ),
                  onPressed: () => onSelect(sample),
                ),
              ),
            ),
          for (final sample in const ['hello!', 'Can we connect?'])
            ActionChip(label: Text(sample), onPressed: () => onSelect(sample)),
        ],
      ),
    );
  }
}
