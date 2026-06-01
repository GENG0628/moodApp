import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../features/mood_entry/domain/mood_entry.dart';
import '../../features/mood_entry/domain/mood_option.dart';

class MoodSticker extends StatelessWidget {
  const MoodSticker({
    super.key,
    required this.mood,
    this.owner,
    this.size = 42,
    this.selected = false,
  });

  final MoodOption mood;
  final EntryOwner? owner;
  final double size;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    final radius = size * .28;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 160),
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: mood.background,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(
          color: selected ? mood.color : Colors.white,
          width: selected ? 2.4 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: mood.color.withValues(alpha: .20),
            blurRadius: selected ? 12 : 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Center(
            child: SvgPicture.asset(
              mood.assetPath,
              width: size * .88,
              height: size * .88,
              fit: BoxFit.contain,
              semanticsLabel: mood.label,
            ),
          ),
          if (owner != null)
            Positioned(
              right: -2,
              top: -4,
              child: DecoratedBox(
                decoration: BoxDecoration(
                  color: owner == EntryOwner.self
                      ? const Color(0xFF0F8F86)
                      : const Color(0xFFFF8DA1),
                  borderRadius: BorderRadius.circular(999),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 1,
                  ),
                  child: Text(
                    owner!.label,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 8,
                      fontWeight: FontWeight.w800,
                      height: 1,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
