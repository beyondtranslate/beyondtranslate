# BeyondTranslate

[![GitHub (pre-)release](https://img.shields.io/github/release/beyondtranslate/beyondtranslate/all.svg?style=flat-square)](https://github.com/beyondtranslate/beyondtranslate/releases)

**BeyondTranslate** is a convenient translation and dictionary app written in `Flutter`. [View document](https://beyondtranslate.com/docs/)

---

English | [简体中文](./README-ZH.md)

---

![](https://biyidev.com/images/screenshots/biyi_extract_text_from_screen_selection.gif)

## Platform Support

| Linux | macOS | Windows |
| :---: | :---: | :-----: |
|   ✔️   |   ✔️   |    ✔️    |

## Installation

Downloads are available on the [Releases](https://github.com/beyondtranslate/beyondtranslate/releases/latest) page. Also check out the [website](https://biyidev.com/release-notes) for other installation methods.

**To install with Homebrew, run:**

```bash
brew tap biyidev/biyi
brew install biyi
```

## Development

### ⚠️ Linux requirements

- `appindicator3-0.1`
- [`keybinder-3.0`](https://github.com/kupferlauncher/keybinder)

Run the following command

```
sudo apt-get install appindicator3-0.1 libappindicator3-dev
sudo apt-get install keybinder-3.0
```

### Before You Start

1. Clone this repo via git:

```
$ git clone https://github.com/beyondtranslate/beyondtranslate.git
```

2. Change to `beyondtranslate` directory

```
$ cd beyondtranslate
```

4. Install dependencies

```
$ melos bs
```

### Run app

```
$ cd apps/desktop
$ flutter run -d linux / macos / windows
```

## Discussion

> Welcome to join the discussion group to share your suggestions and ideas with me.

- [QQ Group](https://jq.qq.com/?_wv=1027&k=vYQ5jW7y)

## Related Links

- https://github.com/biyidev/biyi
- https://github.com/leanflutter/hotkey_manager
- https://github.com/leanflutter/screen_text_extractor

## License

[AGPL](./LICENSE)
