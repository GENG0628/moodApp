import 'package:flutter/material.dart';

class MoodOption {
  const MoodOption({
    required this.id,
    required this.label,
    required this.emoji,
    required this.score,
    required this.color,
    required this.background,
    required this.assetPath,
  });

  final String id;
  final String label;
  final String emoji;
  final int score;
  final Color color;
  final Color background;
  final String assetPath;
}

const moodOptions = [
  MoodOption(
    id: 'great',
    label: '很好',
    emoji: '😆',
    score: 10,
    color: Color(0xFFFFB84D),
    background: Color(0xFFFFEDBE),
    assetPath: 'assets/stickers/delighted.svg',
  ),
  MoodOption(
    id: 'good',
    label: '不错',
    emoji: '☺️',
    score: 8,
    color: Color(0xFFFF8DA1),
    background: Color(0xFFFFD7DE),
    assetPath: 'assets/stickers/happy.svg',
  ),
  MoodOption(
    id: 'calm',
    label: '平静',
    emoji: '😌',
    score: 6,
    color: Color(0xFF78B56B),
    background: Color(0xFFDDF2D8),
    assetPath: 'assets/stickers/calm.svg',
  ),
  MoodOption(
    id: 'tired',
    label: '疲惫',
    emoji: '😮‍💨',
    score: 4,
    color: Color(0xFF7AB6D9),
    background: Color(0xFFD9F0FF),
    assetPath: 'assets/stickers/sleepy.svg',
  ),
  MoodOption(
    id: 'sad',
    label: '低落',
    emoji: '😔',
    score: 2,
    color: Color(0xFF9B918C),
    background: Color(0xFFE7E0DC),
    assetPath: 'assets/stickers/sad.svg',
  ),
  MoodOption(
    id: 'angry',
    label: '生气',
    emoji: '😠',
    score: 2,
    color: Color(0xFFF46F5E),
    background: Color(0xFFFFC5B8),
    assetPath: 'assets/stickers/angry.svg',
  ),
  MoodOption(
    id: 'anxious',
    label: '焦虑',
    emoji: '😟',
    score: 3,
    color: Color(0xFF7C79C8),
    background: Color(0xFFDADAF7),
    assetPath: 'assets/stickers/anxious.svg',
  ),
  MoodOption(
    id: 'love',
    label: '想你',
    emoji: '😍',
    score: 9,
    color: Color(0xFFFF7F9A),
    background: Color(0xFFFFE1EC),
    assetPath: 'assets/stickers/love.svg',
  ),
];
