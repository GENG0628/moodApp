import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/widgets/mood_sticker.dart';
import '../../../shared/widgets/section_card.dart';
import '../../mood_entry/domain/mood_entry.dart';

class CalendarPage extends StatelessWidget {
  const CalendarPage({super.key, required this.entries});

  final List<MoodEntry> entries;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final monthStart = DateTime(now.year, now.month);
    final monthDays = DateUtils.getDaysInMonth(now.year, now.month);
    final leadingBlankCount = monthStart.weekday - 1;
    final cells = <DateTime?>[
      ...List<DateTime?>.filled(leadingBlankCount, null),
      for (var day = 1; day <= monthDays; day++)
        DateTime(now.year, now.month, day),
    ];
    while (cells.length % 7 != 0) {
      cells.add(null);
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: [
        _CalendarHeader(month: now),
        const SizedBox(height: 14),
        SectionCard(
          padding: const EdgeInsets.fromLTRB(10, 12, 10, 10),
          child: Column(
            children: [
              const _WeekHeader(),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: cells.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 7,
                  mainAxisSpacing: 8,
                  crossAxisSpacing: 6,
                  childAspectRatio: .62,
                ),
                itemBuilder: (context, index) {
                  final date = cells[index];
                  if (date == null) {
                    return const SizedBox.shrink();
                  }
                  return _MonthDayCell(
                    date: date,
                    selfEntry: _latestEntry(date, EntryOwner.self),
                    partnerEntry: _latestEntry(date, EntryOwner.partner),
                    isToday: _sameDay(date, now),
                  );
                },
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Text('时间线', style: theme.textTheme.titleMedium),
            const Spacer(),
            _LegendDot(
              color: const Color(0xFF0F8F86),
              label: EntryOwner.self.label,
            ),
            const SizedBox(width: 10),
            _LegendDot(
              color: const Color(0xFFFF8DA1),
              label: EntryOwner.partner.label,
            ),
          ],
        ),
        const SizedBox(height: 10),
        if (entries.isEmpty)
          const SectionCard(child: Text('暂无记录'))
        else
          for (final entry in entries) ...[
            SectionCard(
              child: Row(
                children: [
                  MoodSticker(mood: entry.mood, owner: entry.owner, size: 44),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${entry.owner.label} · ${entry.mood.label}',
                          style: theme.textTheme.titleMedium,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          entry.content.isEmpty
                              ? entry.tags.join('、')
                              : entry.content,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Text(_dateLabel(entry.createdAt)),
                ],
              ),
            ),
            const SizedBox(height: 10),
          ],
      ],
    );
  }

  MoodEntry? _latestEntry(DateTime date, EntryOwner owner) {
    final matched = entries.where(
      (entry) => entry.owner == owner && _sameDay(entry.createdAt, date),
    );
    return matched.isEmpty ? null : matched.first;
  }

  static bool _sameDay(DateTime left, DateTime right) {
    return left.year == right.year &&
        left.month == right.month &&
        left.day == right.day;
  }

  static String _dateLabel(DateTime date) {
    return '${date.month}/${date.day}';
  }
}

class _CalendarHeader extends StatelessWidget {
  const _CalendarHeader({required this.month});

  final DateTime month;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Row(
      children: [
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(LucideIcons.chevronLeft),
        ),
        Expanded(
          child: Column(
            children: [
              Text(
                '${month.month}月',
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text('${month.year}年', style: theme.textTheme.labelLarge),
            ],
          ),
        ),
        IconButton.filledTonal(
          onPressed: () {},
          icon: const Icon(LucideIcons.chartLine),
        ),
      ],
    );
  }
}

class _WeekHeader extends StatelessWidget {
  const _WeekHeader();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    const labels = ['一', '二', '三', '四', '五', '六', '日'];

    return Row(
      children: [
        for (final label in labels)
          Expanded(
            child: Center(
              child: Text(
                label,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: .55),
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

class _MonthDayCell extends StatelessWidget {
  const _MonthDayCell({
    required this.date,
    required this.selfEntry,
    required this.partnerEntry,
    required this.isToday,
  });

  final DateTime date;
  final MoodEntry? selfEntry;
  final MoodEntry? partnerEntry;
  final bool isToday;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: isToday ? const Color(0xFFFFF3C9) : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
        border: isToday
            ? Border.all(color: const Color(0xFFFFD166), width: 1.2)
            : null,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Column(
          children: [
            Text(
              isToday ? '今天' : date.day.toString(),
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: theme.textTheme.labelMedium?.copyWith(
                fontWeight: isToday ? FontWeight.w800 : FontWeight.w600,
                fontSize: isToday ? 10 : 12,
              ),
            ),
            const SizedBox(height: 3),
            _TinyMoodSlot(entry: selfEntry, owner: EntryOwner.self),
            const SizedBox(height: 3),
            _TinyMoodSlot(entry: partnerEntry, owner: EntryOwner.partner),
          ],
        ),
      ),
    );
  }
}

class _TinyMoodSlot extends StatelessWidget {
  const _TinyMoodSlot({required this.entry, required this.owner});

  final MoodEntry? entry;
  final EntryOwner owner;

  @override
  Widget build(BuildContext context) {
    if (entry != null) {
      return MoodSticker(mood: entry!.mood, owner: owner, size: 24);
    }

    return Container(
      width: 24,
      height: 24,
      decoration: BoxDecoration(
        color: owner == EntryOwner.self
            ? const Color(0xFFE2F3F1)
            : const Color(0xFFFFE8EC),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.white, width: 1),
      ),
      child: Center(
        child: Text(
          owner == EntryOwner.self ? '我' : 'TA',
          style: TextStyle(
            fontSize: 8,
            fontWeight: FontWeight.w800,
            color: owner == EntryOwner.self
                ? const Color(0xFF0F8F86)
                : const Color(0xFFFF8DA1),
          ),
        ),
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: Theme.of(context).textTheme.labelMedium),
      ],
    );
  }
}
