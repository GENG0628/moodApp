import 'package:flutter/material.dart';

class MoodOption {
  const MoodOption({
    required this.id,
    required this.label,
    required this.emoji,
    required this.score,
    required this.color,
    required this.background,
  });

  final String id;
  final String label;
  final String emoji;
  final int score;
  final Color color;
  final Color background;
}

const moodOptions = [
  MoodOption(
    id: 'great',
    label: '很好',
    emoji: '😆',
    score: 10,
    color: Color(0xFFFFB84D),
    background: Color(0xFFFFEDBE),
  ),
  MoodOption(
    id: 'good',
    label: '不错',
    emoji: '🙂',
    score: 8,
    color: Color(0xFFFF8DA1),
    background: Color(0xFFFFD7DE),
  ),
  MoodOption(
    id: 'calm',
    label: '平静',
    emoji: '😌',
    score: 6,
    color: Color(0xFF78B56B),
    background: Color(0xFFDDF2D8),
  ),
  MoodOption(
    id: 'tired',
    label: '疲惫',
    emoji: '😮‍💨',
    score: 4,
    color: Color(0xFF7AB6D9),
    background: Color(0xFFD9F0FF),
  ),
  MoodOption(
    id: 'sad',
    label: '低落',
    emoji: '😔',
    score: 2,
    color: Color(0xFF9B918C),
    background: Color(0xFFE7E0DC),
  ),
];
