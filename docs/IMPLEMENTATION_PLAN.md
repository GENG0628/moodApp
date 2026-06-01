# 本地 Android MVP 实现方案

版本：v0.1  
日期：2026-05-31  
当前阶段：本地单机 Android 优先

## 0. 当前实现状态

截至 2026-06-01：

- Flutter Android 项目已创建。
- Android package id 已设置为 `com.geng.moodapp`。
- App 显示名已设置为 `心情App`。
- 第一版首页、记录弹窗、日历、统计、我的页面已完成内存态原型。
- `dart analyze` 通过。
- `flutter test` 通过。
- `flutter build apk --debug` 通过。
- debug APK 输出位置：`build\app\outputs\flutter-apk\app-debug.apk`。

注意：当前记录还没有持久化，关闭 App 后新增记录会丢失。下一步需要接入本地数据库。

## 1. 结论

第一版建议做成 Flutter Android APK，本地 SQLite 存储，不依赖服务器。这样可以最快在华为 Pura/P70 Pro+ 真机上验证核心体验：记录心情、写内容、看日历、看统计、设置提醒。

两台手机互相通讯、云备份、共享心情、评论和推送都放到后续版本。第一版不做服务器，可以显著降低开发复杂度。

## 2. 华为 P70 Pro+ 系统判断

华为 P70 系列实际上市名称通常是 HUAWEI Pura 70 系列。华为官网规格页显示 HUAWEI Pura 70 Pro+ 搭载 HarmonyOS 4.2。

对开发的影响：

- 如果你的手机是 HarmonyOS 4.x，通常可以按 Android APK 路线开发和安装。
- 如果系统已经升级到 HarmonyOS NEXT / HarmonyOS 5+ 原生鸿蒙版本，普通 Android APK 兼容性可能不再成立，需要改做鸿蒙原生应用包。
- 第一版先按 Android APK 做，开发前在真机上安装一个测试 APK 验证即可。

建议你在手机上确认：

```text
设置 -> 关于手机 -> HarmonyOS 版本
```

判断规则：

| 手机系统 | 第一版方案 |
| --- | --- |
| HarmonyOS 4.x | 走 Flutter Android APK |
| EMUI 14.x/15.x | 走 Flutter Android APK |
| HarmonyOS NEXT / HarmonyOS 5+ 原生鸿蒙 | 需要评估鸿蒙原生 HAP 方案 |

第一版不要依赖 Google 服务，因为华为手机通常没有 GMS。所有核心功能必须在无 Google Play 服务环境下工作。

当前项目仍放在中文路径 `D:\Users\18522\Documents\心情app`。Android Gradle 已通过 `android.overridePathCheck=true` 允许构建，但长期建议迁移到纯英文路径，例如 `D:\Code\moodApp`，减少 Windows 下 Android/Flutter 工具链兼容风险。

## 3. 第一版范围

### 3.1 做什么

- 本地心情记录。
- 心情小表情和强度。
- 文字日记。
- 标签。
- 图片附件，先限制最多 3 张。
- 日历查看。
- 时间线查看。
- 基础统计。
- 本地提醒。
- 设置页。
- 本地导出和导入。
- PIN 或生物识别隐私锁。

### 3.2 不做什么

- 不做登录注册。
- 不做服务器。
- 不做云同步。
- 不做两台手机互相通讯。
- 不做双人绑定。
- 不做在线聊天。
- 不做社区。
- 不做 AI。
- 不接广告和支付。

## 4. 技术选型

客户端：

- Flutter：一套代码后续可扩展 iOS。
- Riverpod：状态管理。
- go_router：页面路由。
- Drift + SQLite：本地数据库。
- freezed + json_serializable：不可变模型和 JSON 序列化。
- flutter_local_notifications：本地提醒。
- local_auth：生物识别。
- path_provider：本地文件路径。
- image_picker：图片选择。
- fl_chart：统计图表。

代码质量：

- flutter_lints 或 very_good_analysis。
- 单元测试覆盖 domain 和 repository。
- Widget 测试覆盖核心页面。
- 数据库迁移测试覆盖 schema 变更。

## 5. 本地数据存储

第一版所有数据保存在手机本地：

- 结构化数据存 SQLite。
- 图片存 App 私有目录。
- 设置项可存 SQLite 或 SharedPreferences。
- 导出时生成 JSON/CSV，图片单独打包。

注意：

- 用户卸载 App 会删除本地数据。
- 第一版必须提供导出功能。
- 后续云同步上线后，旧本地数据要能迁移到账号下。

## 6. 数据表设计

### 6.1 mood_entries

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| id | text | UUID |
| mood_type_id | text | 心情类型 ID |
| mood_score | integer | 1 到 10 |
| intensity | integer | 1 到 5 |
| content | text | 正文，可为空 |
| entry_time | integer | 发生时间，Unix 毫秒 |
| created_at | integer | 创建时间 |
| updated_at | integer | 更新时间 |
| deleted_at | integer | 软删除时间 |

### 6.2 mood_types

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| id | text | UUID |
| name | text | 心情名称 |
| emoji | text | 表情 |
| color | text | 颜色 |
| score | integer | 默认分值 |
| sort_order | integer | 排序 |
| is_system | boolean | 是否系统默认 |

### 6.3 tags

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| id | text | UUID |
| name | text | 标签名 |
| category | text | 标签类别 |
| color | text | 颜色 |
| icon | text | 图标 |
| archived | boolean | 是否归档 |

### 6.4 entry_tags

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| entry_id | text | 记录 ID |
| tag_id | text | 标签 ID |

### 6.5 attachments

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| id | text | UUID |
| entry_id | text | 记录 ID |
| type | text | image |
| local_path | text | 本地文件路径 |
| width | integer | 图片宽度 |
| height | integer | 图片高度 |
| created_at | integer | 创建时间 |

### 6.6 app_settings

| 字段 | 类型 | 说明 |
| --- | --- | --- |
| key | text | 设置键 |
| value | text | 设置值 |
| updated_at | integer | 更新时间 |

## 7. 页面规划

底部导航保留 4 个 Tab：

- 首页：今日记录入口、最近记录、连续记录天数。
- 日历：月视图、每日主心情、时间线入口。
- 统计：趋势、分布、标签关联。
- 我的：设置、隐私锁、导入导出、关于。

核心页面：

- `HomePage`
- `MoodEditorPage`
- `MoodDetailPage`
- `CalendarPage`
- `TimelinePage`
- `StatisticsPage`
- `SettingsPage`
- `TagManagerPage`
- `ExportImportPage`

## 8. 开发顺序

建议按这个顺序开发：

1. 初始化 Flutter 项目。
2. 配置 lint、路由、主题和基础目录。
3. 建立 Drift 数据库。
4. 实现心情类型和标签种子数据。
5. 实现心情记录新增、编辑、删除。
6. 实现首页和最近记录。
7. 实现日历和时间线。
8. 实现基础统计。
9. 实现本地提醒。
10. 实现设置、隐私锁、导入导出。
11. 在华为 Pura/P70 Pro+ 真机测试 APK。

## 9. 真机测试重点

华为手机上需要重点测试：

- APK 是否可安装。
- 无 GMS 环境是否正常启动。
- 图片选择权限是否正常。
- 本地通知是否正常弹出。
- 后台清理后提醒是否还能触发。
- 生物识别是否可用。
- 深色模式是否正常。
- 数据导出文件是否能被系统文件管理器访问。

## 10. 后续接服务器的预留方式

第一版虽然不接服务器，但代码要为后续同步预留接口：

- UI 不直接操作数据库。
- UI 调用 use case。
- use case 调 repository。
- repository 第一版接 local data source。
- 后续新增 remote data source 和 sync service。

第一版：

```text
UI -> UseCase -> MoodRepository -> LocalMoodDataSource -> SQLite
```

后续：

```text
UI -> UseCase -> MoodRepository -> LocalMoodDataSource
                                      RemoteMoodDataSource
                                      SyncService
```

这样后面加服务器时，不需要推倒重写页面。

## 11. 参考来源

- [HUAWEI Pura 70 Pro+ 规格参数](https://consumer.huawei.com/cn/phones/pura70-pro-plus/specs/)
- [HarmonyOS NEXT APK 兼容性报道](https://www.sammobile.com/news/huaweis-harmonyos-next-not-support-android-apps/)
