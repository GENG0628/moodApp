import 'package:flutter/material.dart';

import '../domain/mood_entry.dart';
import '../domain/mood_option.dart';

class MoodEditorSheet extends StatefulWidget {
  const MoodEditorSheet({super.key});

  @override
  State<MoodEditorSheet> createState() => _MoodEditorSheetState();
}

class _MoodEditorSheetState extends State<MoodEditorSheet> {
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

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 12,
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
                    child: Text('记录此刻心情', style: theme.textTheme.titleLarge),
                  ),
                  IconButton(
                    tooltip: '关闭',
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text('心情', style: theme.textTheme.titleMedium),
              const SizedBox(height: 10),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: moodOptions.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 5,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 8,
                  childAspectRatio: .78,
                ),
                itemBuilder: (context, index) {
                  final mood = moodOptions[index];
                  final selected = mood.id == _selectedMood.id;

                  return _MoodButton(
                    mood: mood,
                    selected: selected,
                    onTap: () => setState(() => _selectedMood = mood),
                  );
                },
              ),
              const SizedBox(height: 20),
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
              const SizedBox(height: 12),
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
                      onSelected: (_) => _toggleTag(tag),
                    ),
                ],
              ),
              const SizedBox(height: 18),
              TextField(
                controller: _contentController,
                minLines: 3,
                maxLines: 6,
                textInputAction: TextInputAction.newline,
                decoration: const InputDecoration(
                  labelText: '写一点发生了什么',
                  hintText: '可留空，先记录心情也可以',
                ),
              ),
              const SizedBox(height: 18),
              SizedBox(
                width: double.infinity,
                height: 48,
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
    );
  }
}

class _MoodButton extends StatelessWidget {
  const _MoodButton({
    required this.mood,
    required this.selected,
    required this.onTap,
  });

  final MoodOption mood;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 160),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? mood.color.withValues(alpha: .16)
              : theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected
                ? mood.color
                : theme.dividerColor.withValues(alpha: .35),
            width: selected ? 2 : 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(mood.emoji, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 6),
            Text(
              mood.label,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.labelMedium,
            ),
          ],
        ),
      ),
    );
  }
}
