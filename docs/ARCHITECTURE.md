# 代码架构规范

版本：v0.1  
适用阶段：Flutter Android 本地 MVP

## 1. 架构原则

项目采用 feature-first + clean architecture。

核心原则：

- 页面层不直接访问数据库。
- 业务逻辑不写在 Widget 里。
- 数据模型、业务实体、数据库表分清楚。
- 本地存储、后续服务器同步都通过 repository 抽象。
- 功能模块之间通过清晰接口协作，避免互相引用内部实现。
- 所有可测试逻辑优先放到 domain 层。

## 2. 推荐目录结构

```text
lib/
  main.dart
  app/
    app.dart
    router/
      app_router.dart
    theme/
      app_theme.dart
      app_colors.dart
    bootstrap/
      bootstrap.dart
  core/
    database/
      app_database.dart
      tables/
      migrations/
    errors/
      app_error.dart
      result.dart
    notifications/
      notification_service.dart
    security/
      app_lock_service.dart
    storage/
      file_storage_service.dart
    utils/
  features/
    mood_entry/
      data/
        datasources/
        dto/
        repositories/
      domain/
        entities/
        repositories/
        usecases/
      presentation/
        pages/
        widgets/
        controllers/
    calendar/
      data/
      domain/
      presentation/
    statistics/
      data/
      domain/
      presentation/
    settings/
      data/
      domain/
      presentation/
    tags/
      data/
      domain/
      presentation/
  shared/
    widgets/
    constants/
    extensions/
```

## 3. 分层说明

### 3.1 presentation

负责页面和交互：

- Page。
- Widget。
- Controller / Notifier。
- 表单状态。
- loading、empty、error 状态。

限制：

- 不写 SQL。
- 不直接读写文件。
- 不直接处理复杂统计逻辑。
- 不拼接数据库查询。

### 3.2 domain

负责业务规则：

- Entity。
- Repository interface。
- Use case。
- 统计计算规则。
- 数据校验规则。

限制：

- 不依赖 Flutter UI。
- 不依赖 Drift。
- 不依赖 HTTP 客户端。

### 3.3 data

负责数据实现：

- Drift DAO。
- DTO。
- Repository implementation。
- 本地文件读写。
- 后续远程 API。

限制：

- 不放 UI 组件。
- 不写页面跳转逻辑。

## 4. 命名规范

文件：

- 使用 snake_case。
- 页面文件以 `_page.dart` 结尾。
- 组件文件以 `_widget.dart` 或具体组件名结尾。
- use case 文件用动词开头，如 `create_mood_entry.dart`。

类：

- Entity：`MoodEntry`
- Repository 接口：`MoodEntryRepository`
- Repository 实现：`MoodEntryRepositoryImpl`
- UseCase：`CreateMoodEntry`
- Controller：`MoodEditorController`

## 5. 状态管理规范

使用 Riverpod：

- 简单只读数据使用 Provider。
- 异步数据使用 FutureProvider 或 AsyncNotifier。
- 表单和复杂交互使用 Notifier / AsyncNotifier。
- Controller 只协调 UI 状态和 use case，不写数据库细节。

错误状态统一转成 `AppError`，页面只负责展示用户能理解的文案。

## 6. 数据库规范

本地数据库使用 Drift：

- 表结构集中在 `core/database/tables/`。
- DAO 按功能模块拆分。
- 数据库版本升级必须写 migration。
- 删除记录优先软删除。
- 所有时间统一存 Unix 毫秒。
- 所有主键使用 UUID 字符串。

## 7. 测试规范

必须覆盖：

- 心情记录创建、编辑、删除 use case。
- 标签关联统计计算。
- 日历主心情计算。
- 数据库 migration。
- 导出和导入数据格式。

建议覆盖：

- 首页空状态。
- 记录表单校验。
- 统计页样本不足状态。
- 设置项读写。

## 8. UI 规范

- 底部导航固定 4 个主入口。
- 首页优先展示记录入口，不做复杂信息流。
- 记录页支持只选表情就保存。
- 所有删除操作都需要二次确认。
- 统计样本不足时展示引导，不输出误导性结论。
- 深色模式必须完整适配。
- 文案避免医疗诊断表达。

## 9. 隐私规范

第一版是本地单机，但仍按隐私产品处理：

- 默认不上传任何内容。
- 不采集位置，除非用户主动开启。
- 不记录通讯录。
- 不记录日记正文到日志。
- 导出文件需要提示用户妥善保存。
- App 锁开启后，冷启动和后台恢复都要校验。

## 10. 为云同步预留的接口

第一版 repository 接口示例：

```dart
abstract class MoodEntryRepository {
  Future<MoodEntry> create(MoodEntryDraft draft);
  Future<MoodEntry> update(MoodEntry entry);
  Future<void> delete(String id);
  Stream<List<MoodEntry>> watchEntries(MoodEntryQuery query);
  Future<MoodEntry?> findById(String id);
}
```

后续云同步只新增实现，不改变页面调用方式。
