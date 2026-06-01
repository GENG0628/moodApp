import 'package:flutter/material.dart';

class MoodOption {
  const MoodOption({
    required this.id,
    required this.label,
    required this.emoji,
    required this.score,
    required this.color,
  });

  final String id;
  final String label;
  final String emoji;
  final int score;
  final Color color;
}

const moodOptions = [
  MoodOption(
    id: 'great',
    label: '很好',
    emoji: '😄',
    score: 10,
    color: Color(0xFF2F9E44),
  ),
  MoodOption(
    id: 'good',
    label: '不错',
    emoji: '🙂',
    score: 8,
    color: Color(0xFF3C8DBC),
  ),
  MoodOption(
    id: 'calm',
    label: '平静',
    emoji: '😌',
    score: 6,
    color: Color(0xFF7E6B8F),
  ),
  MoodOption(
    id: 'tired',
    label: '疲惫',
    emoji: '😮‍💨',
    score: 4,
    color: Color(0xFF8A7A4E),
  ),
  MoodOption(
    id: 'sad',
    label: '低落',
    emoji: '😔',
    score: 2,
    color: Color(0xFF6C757D),
  ),
];
