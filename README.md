# 心情 App

这是一个心情记录 App 项目，目标是先完成本地单机版 Android MVP，后续再扩展 iOS、云同步、双人互动和 AI 总结。

## 当前决策

- 第一阶段只做本地单机版本。
- 第一阶段优先支持 Android APK。
- 目标真机优先适配华为 Pura/P70 Pro+。
- 不接服务器、不做登录、不做双端互通。
- 数据默认保存在手机本地，卸载 App 前需要导出备份。
- 代码架构按 feature-first + clean architecture 组织，方便后续接入服务器和 iOS。

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
