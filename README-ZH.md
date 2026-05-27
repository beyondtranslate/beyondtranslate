# BeyondTranslate

[![GitHub (pre-)release](https://img.shields.io/github/release/beyondtranslate/beyondtranslate/all.svg?style=flat-square)](https://github.com/beyondtranslate/beyondtranslate/releases)

**BeyondTranslate**（原名 **Biyi**）是一款快速且原生体验出色的翻译应用，支持 macOS、Windows 和 Linux，由 Flutter 与 Rust 构建。通过从屏幕任意位置捕获文本，借助多引擎获得精准翻译——轻量不打扰，需要时随时在。[查看文档](https://beyondtranslate.com/docs/)

> **⚠️ 说明：** 架构升级中：核心服务切换至 Rust 以提升性能与跨平台复用，UI 继续由 Flutter 承载，macOS 设置页面则由 SwiftUI 原生渲染。

---

[English](./README.md) | 简体中文

---

![](https://beyondtranslate.com/images/screenshots/biyi_extract_text_from_screen_selection.gif)

## 平台支持

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|   ✔️   |   ✔️   |    ✔️    |

## 安装

下载可以在[发布版本](https://github.com/beyondtranslate/beyondtranslate/releases/latest)页面上找到，也可以在[网站](https://beyondtranslate.com/release-notes)上找到其他安装方法。

**要用 Homebrew 安装，请运行：**

```bash
brew tap beyondtranslate/beyondtranslate
brew install beyondtranslate
```

## 开发

### ⚠️ Linux 依赖

- `appindicator3-0.1`
- [`keybinder-3.0`](https://github.com/kupferlauncher/keybinder)

运行以下命令：

```
sudo apt-get install appindicator3-0.1 libappindicator3-dev
sudo apt-get install keybinder-3.0
```

### 开始之前

1. 克隆代码库：

```
$ git clone https://github.com/beyondtranslate/beyondtranslate.git
```

2. 切换到项目目录

```
$ cd beyondtranslate
```

3. 安装依赖

```
$ melos bs
```

### 运行应用

```
$ cd apps/desktop
$ flutter run -d linux / macos / windows
```

## 讨论

> 欢迎加入讨论组，与我分享你的建议和想法。

- [QQ 群](https://jq.qq.com/?_wv=1027&k=vYQ5jW7y)

## 相关链接

- https://github.com/beyondtranslate/beyondtranslate
- https://github.com/leanflutter/screen_text_extractor

## 许可证

[AGPL](./LICENSE)
