# Git 工作流

版本：v0.1  
适用阶段：本地开发到远程仓库

## 1. 当前仓库状态

当前目录已经是 Git 仓库，并已配置 GitHub 远程地址：

```text
origin  https://github.com/GENG0628/moodApp.git
```

查看远程地址：

```bash
git remote -v
```

如果后续需要换仓库地址，可以执行：

```bash
git remote set-url origin <新的仓库地址>
```

## 2. 分支规范

建议使用：

```text
master 或 main：稳定主分支
codex/android-local-mvp：第一版 Android 本地 MVP 开发分支
```

功能分支命名：

```text
codex/feature-mood-entry
codex/feature-calendar
codex/feature-statistics
codex/feature-settings
```

## 3. 提交规范

提交信息建议使用：

```text
docs: update local android mvp plan
feat: add mood entry editor
feat: add local database
fix: correct calendar mood calculation
test: add mood statistics tests
chore: configure flutter lint
```

常用类型：

| 类型 | 用途 |
| --- | --- |
| docs | 文档 |
| feat | 新功能 |
| fix | 修复 |
| test | 测试 |
| refactor | 重构 |
| chore | 工程配置 |

## 4. 初次上传远程仓库

首次推送：

```bash
git push -u origin master
```

如果主分支叫 `main`：

```bash
git branch -M main
git push -u origin main
```

## 5. 提交前检查

每次提交前至少检查：

```bash
git status
```

Flutter 项目创建后，还需要执行：

```bash
flutter analyze
flutter test
```

Android 打包前执行：

```bash
flutter build apk --debug
```

正式发测试包时再执行 release 构建。

## 6. 不提交的内容

不要提交：

- 密钥文件。
- 签名证书。
- 本地配置。
- build 目录。
- IDE 临时文件。
- 用户导出的真实日记数据。

这些内容需要放入 `.gitignore`。
