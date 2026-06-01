import 'package:flutter/material.dart';

import '../../calendar/presentation/calendar_page.dart';
import '../../mood_entry/domain/mood_entry.dart';
import '../../mood_entry/domain/mood_option.dart';
import '../../mood_entry/presentation/mood_editor_sheet.dart';
import '../../settings/presentation/settings_page.dart';
import '../../statistics/presentation/statistics_page.dart';
import '../../../shared/widgets/section_card.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  final _entries = <MoodEntry>[
    MoodEntry(
      id: 'demo-1',
      mood: moodOptions[1],
      intensity: 3,
      content: '今天先把产品思路和开发环境整理清楚，节奏不错。',
      tags: const ['工作', '学习'],
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
  ];

  Future<void> _createEntry() async {
    final draft = await showModalBottomSheet<MoodEntryDraft>(
      context: context,
      isScrollControlled: true,
      useSafeArea: true,
      showDragHandle: true,
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
          IconButton(
            tooltip: '新增记录',
            onPressed: _createEntry,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
      body: IndexedStack(index: _currentIndex, children: pages),
      floatingActionButton: _currentIndex == 0
          ? FloatingActionButton.extended(
              onPressed: _createEntry,
              icon: const Icon(Icons.edit_note),
              label: const Text('记录'),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: '首页',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month),
            label: '日历',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_outlined),
            selectedIcon: Icon(Icons.bar_chart),
            label: '统计',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings),
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
    final latest = entries.isEmpty ? null : entries.first;
    final theme = Theme.of(context);

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 96),
      children: [
        SectionCard(
          child: Row(
            children: [
              Container(
                width: 72,
                height: 72,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color:
                      latest?.mood.color.withValues(alpha: .16) ??
                      theme.colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  latest?.mood.emoji ?? '🙂',
                  style: const TextStyle(fontSize: 38),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      latest == null ? '今天还没有记录' : '最近一次：${latest.mood.label}',
                      style: theme.textTheme.titleLarge,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      latest == null
                          ? '先用一个表情记下此刻状态。'
                          : '强度 ${latest.intensity}/5 · ${latest.tags.join('、')}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: '记录心情',
                onPressed: onCreateEntry,
                icon: const Icon(Icons.add),
              ),
            ],
          ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _MetricTile(
                label: '总记录',
                value: entries.length.toString(),
                icon: Icons.event_note,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _MetricTile(
                label: '平均心情',
                value: _averageScore(entries),
                icon: Icons.show_chart,
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

  String _averageScore(List<MoodEntry> entries) {
    if (entries.isEmpty) {
      return '-';
    }
    final total = entries.fold<int>(0, (sum, entry) => sum + entry.mood.score);
    return (total / entries.length).toStringAsFixed(1);
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
          Text(entry.mood.emoji, style: const TextStyle(fontSize: 30)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.mood.label,
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
