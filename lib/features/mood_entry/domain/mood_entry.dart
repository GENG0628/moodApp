import 'mood_option.dart';

class MoodEntry {
  const MoodEntry({
    required this.id,
    required this.mood,
    required this.intensity,
    required this.content,
    required this.tags,
    required this.createdAt,
  });

  final String id;
  final MoodOption mood;
  final int intensity;
  final String content;
  final List<String> tags;
  final DateTime createdAt;
}

class MoodEntryDraft {
  const MoodEntryDraft({
    required this.mood,
    required this.intensity,
    required this.content,
    required this.tags,
  });

  final MoodOption mood;
  final int intensity;
  final String content;
  final List<String> tags;
}
