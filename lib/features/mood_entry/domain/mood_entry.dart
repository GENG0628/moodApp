import 'mood_option.dart';

enum EntryOwner {
  self('我'),
  partner('TA');

  const EntryOwner(this.label);

  final String label;
}

class MoodEntry {
  const MoodEntry({
    required this.id,
    required this.owner,
    required this.mood,
    required this.intensity,
    required this.content,
    required this.tags,
    required this.createdAt,
  });

  final String id;
  final EntryOwner owner;
  final MoodOption mood;
  final int intensity;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
}

class MoodEntryDraft {
  const MoodEntryDraft({
    required this.owner,
    required this.mood,
    required this.intensity,
    required this.content,
    required this.tags,
  });

  final EntryOwner owner;
  final MoodOption mood;
  final int intensity;
  final String content;
  final List<String> tags;
}
