import 'package:flutter/material.dart';

import '../../mood_entry/domain/mood_entry.dart';
import '../../../shared/widgets/section_card.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key, required this.entries});

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final days = List.generate(14, (index) {
      final date = DateTime(now.year, now.month, now.day - index);
      final entry = entries
          .where((item) => _sameDay(item.createdAt, date))
          .firstOrNull;
      return (date: date, entry: entry);
    });

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: [
        Text('近 14 天', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        SectionCard(
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: days.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: .82,
            ),
            itemBuilder: (context, index) {
              final day = days[index];
              return _DayCell(date: day.date, entry: day.entry);
            },
          ),
        ),
        const SizedBox(height: 18),
        Text('时间线', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        if (entries.isEmpty)
          const SectionCard(child: Text('暂无记录'))
        else
          for (final entry in entries) ...[
            SectionCard(
              child: ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Text(
                  entry.mood.emoji,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(entry.mood.label),
                subtitle: Text(
                  entry.content.isEmpty ? entry.tags.join('、') : entry.content,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: Text(_dateLabel(entry.createdAt)),
              ),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }

  bool _sameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  String _dateLabel(DateTime date) {
    return '${date.month}/${date.day}';
  }
}

class _DayCell extends StatelessWidget {
  const _DayCell({required this.date, required this.entry});

  final DateTime date;
  final MoodEntry? entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final color =
        entry?.mood.color.withValues(alpha: .18) ??
        theme.colorScheme.surfaceContainerHighest;

    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(date.day.toString(), style: theme.textTheme.labelLarge),
          const SizedBox(height: 4),
          Text(entry?.mood.emoji ?? '·', style: const TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
