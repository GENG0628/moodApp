import 'package:flutter/material.dart';

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
            icon: Icons.lock_outline,
            title: '隐私锁',
            subtitle: '后续接入 PIN 和生物识别',
          ),
        ),
        SizedBox(height: 10),
        SectionCard(
          child: _SettingsTile(
            icon: Icons.notifications_outlined,
            title: '每日提醒',
            subtitle: '后续支持本地通知',
          ),
        ),
        SizedBox(height: 10),
        SectionCard(
          child: _SettingsTile(
            icon: Icons.ios_share_outlined,
            title: '数据导出',
            subtitle: '后续导出 JSON、CSV 和图片',
          ),
        ),
        SizedBox(height: 10),
        SectionCard(
          child: _SettingsTile(
            icon: Icons.cloud_off_outlined,
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
      trailing: const Icon(Icons.chevron_right),
    );
  }
}
