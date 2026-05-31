# 开发环境搭建

版本：v0.1  
目标：在 Windows 上开发并安装 Android APK 到华为 Pura/P70 Pro+

## 1. 当前检查结果

当前电脑执行：

```bash
flutter --version
```

结果是系统找不到 `flutter` 命令。说明还没有安装 Flutter，或者 Flutter 已安装但没有加入系统 PATH。

当前命令检查：

| 工具 | 状态 |
| --- | --- |
| Git | 已安装 |
| VS Code | 已安装 |
| Android Studio | 已安装，位置：`D:\Softs\AndroidStudio` |
| Android SDK | 已安装，位置：`C:\Users\18522\AppData\Local\Android\Sdk` |
| ADB | 已安装，已写入用户 PATH |
| Java | Android Studio 自带 JBR 已安装，已写入用户 PATH |
| Flutter | 未找到 |

因此现在主要还缺 Flutter SDK。Android Studio 和 Android SDK 已经装好。

## 2. 需要安装的软件

必须安装：

- Flutter SDK。
- Android Studio。
- Android SDK。
- Android SDK Platform-Tools。
- Git。

建议安装：

- VS Code 或 Android Studio 作为编辑器。
- Flutter 和 Dart 插件。
- 华为手机助手或华为 USB 驱动。

## 3. Flutter 安装思路

Windows 上建议：

1. 从 Flutter 官方网站下载 Windows 版 SDK。
2. 解压到固定目录，例如：

```text
D:\Dev\flutter
```

3. 把 Flutter 加入系统环境变量 PATH：

```text
D:\Dev\flutter\bin
```

4. 重新打开 PowerShell，执行：

```bash
flutter --version
flutter doctor
```

5. 按照 `flutter doctor` 的提示补齐 Android SDK、licenses 和插件。

## 4. Android Studio 配置

安装 Android Studio 后，需要确认：

- Android SDK 已安装。
- Android SDK Command-line Tools 已安装。
- Android SDK Platform-Tools 已安装。
- 至少安装一个较新的 Android SDK Platform。

接受 Android licenses：

```bash
flutter doctor --android-licenses
```

## 5. 华为手机调试设置

在华为 Pura/P70 Pro+ 上：

1. 打开设置。
2. 进入关于手机。
3. 连续点击版本号，开启开发者选项。
4. 返回系统和更新。
5. 进入开发人员选项。
6. 开启 USB 调试。
7. 用 USB 连接电脑。
8. 手机弹出授权时选择允许。

电脑上检查设备：

```bash
adb devices
flutter devices
```

如果看不到设备：

- 更换 USB 数据线。
- 确认不是只充电模式。
- 安装或更新华为 USB 驱动。
- 重启 adb：

```bash
adb kill-server
adb start-server
adb devices
```

## 6. 第一版创建项目命令

环境装好后，在当前仓库目录执行：

```bash
flutter create --project-name mood_app --platforms=android .
```

如果后续要补 iOS：

```bash
flutter create --platforms=ios .
```

第一版先只创建 Android 平台即可，避免无关平台文件干扰。

## 7. 本地运行

连接华为手机后：

```bash
flutter run
```

构建 debug APK：

```bash
flutter build apk --debug
```

构建 release APK：

```bash
flutter build apk --release
```

debug APK 通常在：

```text
build\app\outputs\flutter-apk\app-debug.apk
```

release APK 通常在：

```text
build\app\outputs\flutter-apk\app-release.apk
```

## 8. 华为兼容注意

第一版不要依赖：

- Google 登录。
- Google Drive。
- Firebase Cloud Messaging。
- Google Play Billing。
- Google Maps。

本地版可以正常使用：

- SQLite。
- 本地通知。
- 图片选择。
- 本地文件导出。
- 生物识别。

如果后续要上架华为应用市场，需要再接入华为账号、华为推送或华为支付，但这些不是第一版目标。
