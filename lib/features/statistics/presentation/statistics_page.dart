import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/widgets/mood_sticker.dart';
import '../../../shared/widgets/section_card.dart';
import '../../mood_entry/domain/mood_entry.dart';
import '../../mood_entry/domain/mood_option.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({super.key, required this.entries});

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final counts = {
      for (final mood in moodOptions)
        mood.id: entries.where((entry) => entry.mood.id == mood.id).length,
    };
    final maxCount = counts.values.fold<int>(1, (max, count) {
      return count > max ? count : max;
    });

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('心情分布', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        SectionCard(
          child: Column(
            children: [
              for (final mood in moodOptions) ...[
                _MoodBar(
                  mood: mood,
                  count: counts[mood.id] ?? 0,
                  maxCount: maxCount,
                ),
                if (mood != moodOptions.last) const SizedBox(height: 12),
              ],
            ],
          ),
        ),
        const SizedBox(height: 18),
        Text('标签观察', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        SectionCard(
          child: entries.length < 3
              ? const Text('记录达到 3 条后，这里会显示高频标签和可能相关的心情变化。')
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final tag in _topTags())
                      Chip(
                        avatar: const Icon(LucideIcons.tag, size: 16),
                        label: Text(tag),
                      ),
                  ],
                ),
        ),
      ],
    );
  }

  List<String> _topTags() {
    final counts = <String, int>{};
    for (final entry in entries) {
      for (final tag in entry.tags) {
        counts[tag] = (counts[tag] ?? 0) + 1;
      }
    }
    final sorted = counts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sorted.take(8).map((entry) => entry.key).toList();
  }
}

class _MoodBar extends StatelessWidget {
  const _MoodBar({
    required this.mood,
    required this.count,
    required this.maxCount,
  });

  final MoodOption mood;
  final int count;
  final int maxCount;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final ratio = maxCount == 0 ? 0.0 : count / maxCount;

    return Row(
      children: [
        SizedBox(
          width: 84,
          child: Row(
            children: [
              MoodSticker(mood: mood, size: 28),
              const SizedBox(width: 6),
              Expanded(
                child: Text(mood.label, overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              minHeight: 14,
              value: ratio == 0 ? .02 : ratio,
              backgroundColor: theme.colorScheme.surfaceContainerHighest,
              color: mood.color,
            ),
          ),
        ),
        const SizedBox(width: 10),
        SizedBox(
          width: 28,
          child: Text(
            count.toString(),
            textAlign: TextAlign.end,
            style: theme.textTheme.labelLarge,
          ),
        ),
      ],
    );
  }
}
