import 'package:flutter/material.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import '../../../shared/widgets/section_card.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
      children: const [
        SectionCard(
          child: _SettingsTile(
            icon: LucideIcons.lockKeyhole,
            title: '隐私锁',
            subtitle: '后续接入 PIN 和生物识别',
          ),
        ),
        SizedBox(height: 10),
        SectionCard(
          child: _SettingsTile(
            icon: LucideIcons.bell,
            title: '每日提醒',
            subtitle: '后续支持本地通知',
          ),
        ),
        SizedBox(height: 10),
        SectionCard(
          child: _SettingsTile(
            icon: LucideIcons.download,
            title: '数据导出',
            subtitle: '后续导出 JSON、CSV 和图片',
          ),
        ),
        SizedBox(height: 10),
        SectionCard(
          child: _SettingsTile(
            icon: LucideIcons.cloudOff,
            title: '本地单机模式',
            subtitle: '当前版本不上传任何心情内容',
          ),
        ),
      ],
    );
  }
}

class _SettingsTile extends StatelessWidget {
  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: const Icon(LucideIcons.chevronRight),
    );
  }
}
