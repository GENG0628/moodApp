# 心情 App

这是一个心情记录 App 项目，目标是先完成本地单机版 Android MVP，后续再扩展 iOS、云同步、双人互动和 AI 总结。

## 当前决策

- 第一阶段只做本地单机版本。
- 第一阶段优先支持 Android APK。
- 目标真机优先适配华为 Pura/P70 Pro+。
- 不接服务器、不做登录、不做双端互通。
- 数据默认保存在手机本地，卸载 App 前需要导出备份。
- 代码架构按 feature-first + clean architecture 组织，方便后续接入服务器和 iOS。

## 当前实现状态

已完成 Flutter Android 项目骨架和第一版可交互界面：

- 首页：今日心情、最近记录、记录入口。
- 记录弹窗：选择心情、强度、标签和文字。
- 日历：整月心情格子、我/TA 双槽位和时间线。
- 统计：心情分布和标签观察占位。
- 我的：隐私锁、提醒、导出、本地模式入口占位。
- Android debug APK 已可构建。

当前记录数据还是内存态，关闭 App 后不会保留。下一步会接入本地数据库，把记录真正保存在手机里。

当前 UI 已按贴纸化、柔和日历方向调整：心情以彩色贴纸块展示，日历每一天预留“我”和“TA”两个位置。后续开通情侣通讯后，对方同步过来的记录会落到 TA 槽位，不需要推翻日历结构。

图标和贴纸策略：

- 功能图标使用开源 `lucide_icons_flutter`，保持线性、干净、统一。
- 心情表情使用项目内原创 SVG 贴纸，位于 `assets/stickers/`。
- 不直接使用 Suki 的图标或表情资产，避免版权风险。

## 文档索引

- [产品 PRD](docs/PRD.md)
- [本地 Android MVP 实现方案](docs/IMPLEMENTATION_PLAN.md)
- [代码架构规范](docs/ARCHITECTURE.md)
- [Git 工作流](docs/GIT_WORKFLOW.md)
- [开发环境搭建](docs/ENVIRONMENT_SETUP.md)

## 第一版目标

第一版要让用户可以在一台 Android 手机上完整使用：

- 选择心情小表情。
- 填写心情强度、标签和文字。
- 保存、编辑、删除本地记录。
- 按日历和时间线回看记录。
- 查看基础统计。
- 设置提醒、主题和隐私锁。
- 导出本地数据，避免换机或卸载时丢失。

## 后续扩展方向

- 账号和云同步。
- 两台手机互相共享心情。
- 伴侣/好友绑定。
- 评论、贴纸回应和每日问答。
- iOS 版本。
- AI 周报、月报和写作提示。

## 本地验证

静态分析：

```bash
dart analyze
```

测试：

```bash
flutter test
```

构建 Android debug APK：

```bash
flutter build apk --debug
```

当前 APK 输出位置：

```text
build\app\outputs\flutter-apk\app-debug.apk
```

如果华为手机已开启 USB 调试并被识别，可以运行：

```bash
flutter devices
flutter run
```
