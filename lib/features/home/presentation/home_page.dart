import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/widgets/mood_sticker.dart';
import '../../../shared/widgets/section_card.dart';
import '../../calendar/presentation/calendar_page.dart';
import '../../mood_entry/domain/mood_entry.dart';
import '../../mood_entry/domain/mood_option.dart';
import '../../mood_entry/presentation/mood_editor_sheet.dart';
import '../../settings/presentation/settings_page.dart';
import '../../statistics/presentation/statistics_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _entries = <MoodEntry>[
    MoodEntry(
      id: 'demo-self',
      owner: EntryOwner.self,
      mood: moodOptions[1],
      intensity: 3,
      content: '今天先把产品思路和开发环境整理清楚，节奏不错。',
      tags: const ['工作', '学习'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    MoodEntry(
      id: 'demo-partner',
      owner: EntryOwner.partner,
      mood: moodOptions[0],
      intensity: 4,
      content: '情侣模式预留：以后对方的心情会同步到同一天的 TA 槽位。',
      tags: const ['情侣', '同步'],
      createdAt: DateTime.now().subtract(const Duration(hours: 1)),
    ),
  ];

  Future<void> _createEntry() async {
    final draft = await showModalBottomSheet<MoodEntryDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      builder: (context) => const MoodEditorSheet(),
    );

    if (draft == null) {
      return;
    }

    setState(() {
      _entries.insert(
        0,
        MoodEntry(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          owner: draft.owner,
          mood: draft.mood,
          intensity: draft.intensity,
          content: draft.content,
          tags: draft.tags,
          createdAt: DateTime.now(),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      _HomeTab(entries: _entries, onCreateEntry: _createEntry),
      CalendarPage(entries: _entries),
      StatisticsPage(entries: _entries),
      const SettingsPage(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('心情记录'),
        actions: [
          IconButton.filledTonal(
            tooltip: '新增记录',
            onPressed: _createEntry,
            icon: const Icon(LucideIcons.plus),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _createEntry,
              icon: const Icon(LucideIcons.edit2),
              label: const Text('写心情'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(LucideIcons.home),
            selectedIcon: Icon(LucideIcons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.calendarDays),
            selectedIcon: Icon(LucideIcons.calendarDays),
            label: '日历',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.chartColumnBig),
            selectedIcon: Icon(LucideIcons.chartColumnBig),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(LucideIcons.settings2),
            selectedIcon: Icon(LucideIcons.settings2),
            label: '我的',
          ),
        ],
      ),
    );
  }
}

class _HomeTab extends StatelessWidget {
  const _HomeTab({required this.entries, required this.onCreateEntry});

  final List<MoodEntry> entries;
  final VoidCallback onCreateEntry;

  @override
  Widget build(BuildContext context) {
    final latestSelf = _latestByOwner(EntryOwner.self);
    final latestPartner = _latestByOwner(EntryOwner.partner);
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
      children: [
        _HeroPanel(
          latestSelf: latestSelf,
          latestPartner: latestPartner,
          onCreateEntry: onCreateEntry,
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: '总记录',
                value: entries.length.toString(),
                icon: LucideIcons.notebookPen,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricTile(
                label: '平均心情',
                value: _averageScore(entries),
                icon: LucideIcons.chartLine,
              ),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Text('最近记录', style: theme.textTheme.titleMedium),
        const SizedBox(height: 10),
        if (entries.isEmpty)
          SectionCard(child: Text('暂无记录', style: theme.textTheme.bodyMedium))
        else
          for (final entry in entries.take(5)) ...[
            _EntryTile(entry: entry),
            const SizedBox(height: 10),
          ],
      ],
    );
  }

  MoodEntry? _latestByOwner(EntryOwner owner) {
    final filtered = entries.where((entry) => entry.owner == owner);
    return filtered.isEmpty ? null : filtered.first;
  }

  String _averageScore(List<MoodEntry> entries) {
    if (entries.isEmpty) {
      return '-';
    }
    final total = entries.fold<int>(0, (sum, entry) => sum + entry.mood.score);
    return (total / entries.length).toStringAsFixed(1);
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({
    required this.latestSelf,
    required this.latestPartner,
    required this.onCreateEntry,
  });

  final MoodEntry? latestSelf;
  final MoodEntry? latestPartner;
  final VoidCallback onCreateEntry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEAF8F6), Color(0xFFFFF4D6), Color(0xFFFFE9EF)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '今天的心情档案',
                    style: theme.textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                FilledButton.tonalIcon(
                  onPressed: onCreateEntry,
                  icon: const Icon(LucideIcons.plus),
                  label: const Text('记录'),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _OwnerMoodCard(
                    title: '我',
                    entry: latestSelf,
                    fallback: '还没记录',
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _OwnerMoodCard(
                    title: 'TA',
                    entry: latestPartner,
                    fallback: '等待同步',
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(
              '后续开通通讯后，双方记录会分别落到日历同一天的两个槽位。',
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: .68),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OwnerMoodCard extends StatelessWidget {
  const _OwnerMoodCard({
    required this.title,
    required this.entry,
    required this.fallback,
  });

  final String title;
  final MoodEntry? entry;
  final String fallback;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            if (entry == null)
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF1F0),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(LucideIcons.sparkles),
              )
            else
              MoodSticker(mood: entry!.mood, owner: entry!.owner, size: 46),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: theme.textTheme.labelLarge),
                  const SizedBox(height: 4),
                  Text(
                    entry?.mood.label ?? fallback,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SectionCard(
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelLarge),
                const SizedBox(height: 4),
                Text(value, style: theme.textTheme.headlineSmall),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.entry});

  final MoodEntry entry;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final content = entry.content.isEmpty ? '没有文字内容' : entry.content;

    return SectionCard(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          MoodSticker(mood: entry.mood, owner: entry.owner, size: 48),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        '${entry.owner.label} · ${entry.mood.label}',
                        style: theme.textTheme.titleMedium,
                      ),
                    ),
                    Text(
                      _timeLabel(entry.createdAt),
                      style: theme.textTheme.labelMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(content, maxLines: 2, overflow: TextOverflow.ellipsis),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final tag in entry.tags)
                      Chip(
                        label: Text(tag),
                        visualDensity: VisualDensity.compact,
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static String _timeLabel(DateTime time) {
    final hour = time.hour.toString().padLeft(2, '0');
    final minute = time.minute.toString().padLeft(2, '0');
    return '$hour:$minute';
  }
}
