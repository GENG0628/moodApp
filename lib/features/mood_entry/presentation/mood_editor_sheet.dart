import 'package:flutter/material.dart';

import '../../../shared/widgets/mood_sticker.dart';
import '../domain/mood_entry.dart';
import '../domain/mood_option.dart';

class MoodEditorSheet extends StatefulWidget {
  const MoodEditorSheet({super.key});

  @override
  State<MoodEditorSheet> createState() => _MoodEditorSheetState();
}

class _MoodEditorSheetState extends State<MoodEditorSheet> {
  EntryOwner _owner = EntryOwner.self;
  MoodOption _selectedMood = moodOptions[1];
  double _intensity = 3;
  final _contentController = TextEditingController();
  final _selectedTags = <String>{'工作'};

  static const _tags = ['工作', '学习', '家人', '朋友', '运动', '睡眠', '天气', '独处'];

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  void _toggleTag(String tag) {
    setState(() {
      if (_selectedTags.contains(tag)) {
        _selectedTags.remove(tag);
      } else {
        _selectedTags.add(tag);
      }
    });
  }

  void _save() {
    Navigator.of(context).pop(
      MoodEntryDraft(
        owner: _owner,
        mood: _selectedMood,
        intensity: _intensity.round(),
        content: _contentController.text.trim(),
        tags: _selectedTags.toList()..sort(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: Color(0xFFF7FBFA),
        borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 8,
            bottom: MediaQuery.viewInsetsOf(context).bottom + 20,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '记录此刻心情',
                        style: theme.textTheme.headlineSmall,
                      ),
                    ),
                    IconButton.filledTonal(
                      tooltip: '关闭',
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SegmentedButton<EntryOwner>(
                  segments: const [
                    ButtonSegment(
                      value: EntryOwner.self,
                      label: Text('我'),
                      icon: Icon(Icons.person_outline),
                    ),
                    ButtonSegment(
                      value: EntryOwner.partner,
                      label: Text('TA'),
                      icon: Icon(Icons.favorite_border),
                    ),
                  ],
                  selected: {_owner},
                  onSelectionChanged: (value) {
                    setState(() => _owner = value.first);
                  },
                ),
                const SizedBox(height: 20),
                Text('心情', style: theme.textTheme.titleMedium),
                const SizedBox(height: 12),
                SizedBox(
                  height: 104,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: moodOptions.length,
                    separatorBuilder: (_, _) => const SizedBox(width: 10),
                    itemBuilder: (context, index) {
                      final mood = moodOptions[index];
                      final selected = mood.id == _selectedMood.id;
                      return _MoodChoice(
                        mood: mood,
                        owner: _owner,
                        selected: selected,
                        onTap: () => setState(() => _selectedMood = mood),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 18),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '强度 ${_intensity.round()} / 5',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    const Icon(Icons.speed, size: 20),
                  ],
                ),
                Slider(
                  value: _intensity,
                  min: 1,
                  max: 5,
                  divisions: 4,
                  label: _intensity.round().toString(),
                  onChanged: (value) => setState(() => _intensity = value),
                ),
                const SizedBox(height: 10),
                Text('标签', style: theme.textTheme.titleMedium),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in _tags)
                      FilterChip(
                        label: Text(tag),
                        selected: _selectedTags.contains(tag),
                        showCheckmark: true,
                        onSelected: (_) => _toggleTag(tag),
                      ),
                  ],
                ),
                const SizedBox(height: 18),
                TextField(
                  controller: _contentController,
                  minLines: 4,
                  maxLines: 7,
                  textInputAction: TextInputAction.newline,
                  decoration: const InputDecoration(
                    labelText: '写一点发生了什么',
                    hintText: '可留空，先记录心情也可以',
                  ),
                ),
                const SizedBox(height: 18),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: _save,
                    icon: const Icon(Icons.check),
                    label: const Text('保存记录'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _MoodChoice extends StatelessWidget {
  const _MoodChoice({
    required this.mood,
    required this.owner,
    required this.selected,
    required this.onTap,
  });

  final MoodOption mood;
  final EntryOwner owner;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(18),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        width: 76,
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        decoration: BoxDecoration(
          color: selected ? Colors.white : const Color(0xFFEFF6F5),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: selected ? mood.color : const Color(0xFFDDE9E7),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MoodSticker(mood: mood, owner: owner, size: 44, selected: selected),
            const SizedBox(height: 8),
            Text(
              mood.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: selected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
