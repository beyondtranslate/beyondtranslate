# 翻译目标选择器与语言选择交互重构方案

## 概述

统一翻译目标选择器的两种模式（持久化目标 vs UI 快速选择），去掉 `MatchStrategy`，用 `"auto"` 哨兵值表达自动检测源语言，全部交互使用原生 Menu 实现。

---

## 一、数据模型

### Rust — `crates/core/src/model/translation_target.rs`

```rust
use serde::{Deserialize, Serialize};

/// 翻译目标：从某源语言翻译到目标语言。
///
/// source 为 "auto" 表示自动检测源语言，始终参与翻译；
/// source 为具体语言代码（如 "en"）表示仅检测到该语言时参与翻译。
#[derive(Debug, Clone, PartialEq, Eq, Default, Serialize, Deserialize)]
pub struct TranslationTarget {
    pub source: String,
    pub target: String,
}

impl TranslationTarget {
    /// 自动检测源语言的标记值
    pub const AUTO_SOURCE: &'static str = "auto";

    /// 根据检测到的源语言过滤出活跃的翻译目标。
    pub fn filter_active(
        targets: &[Self],
        detected_language: Option<&str>,
    ) -> Vec<Self> {
        targets
            .iter()
            .filter(|t| {
                t.source == Self::AUTO_SOURCE
                    || detected_language.is_none_or(|dl| t.source == dl)
            })
            .cloned()
            .collect()
    }
}
```

删除 `MatchStrategy` 及所有相关代码（enum、导出、uniffi remote、序列化字段）。

序列化格式：

```json
{"source": "auto",     "target": "zh-Hans"}
{"source": "en",       "target": "ja"}
{"source": "zh-Hans",  "target": "en"}
```

`"auto"` 被当作普通字符串，无特殊序列化逻辑。

### Rust — 导出

`crates/core/src/model/mod.rs` 和 `crates/core/src/lib.rs` 中删除 `MatchStrategy` 导出。

### Rust — uniffi remote

`packages/runtime/rust/src/remote.rs` 中删除 `MatchStrategy` 的 remote：

```rust
// 删除
// type MatchStrategy = core::MatchStrategy;
// #[uniffi::remote(Enum)]
// pub enum MatchStrategy {
//     AutoDetect,
//     Always,
// }

// TranslationTarget 不变：
type TranslationTarget = core::TranslationTarget;
#[uniffi::remote(Record)]
pub struct TranslationTarget {
    pub source: String,
    pub target: String,
}
```

### Rust — `GeneralSettings`

`packages/runtime/rust/src/domain/settings.rs` 中 `translation_targets` 字段定义不变，删除 `MatchStrategy` 的 use。

Default 值 `Vec::new()` 不变。

### Rust — `get_active_translation_targets`

```rust
#[uniffi::export(async_runtime = "tokio")]
impl RuntimeSettings {
    /// 根据检测到的源语言过滤出活跃的翻译目标。
    /// - source == "auto" → 始终包含
    /// - source == "en"   → 仅 detected_language 匹配时包含
    pub async fn get_active_translation_targets(
        &self,
        targets: Vec<TranslationTarget>,
        detected_language: Option<String>,
    ) -> Vec<TranslationTarget> {
        TranslationTarget::filter_active(&targets, detected_language.as_deref())
    }
}
```

### Dart 工具层 — `language_util.dart`

```dart
/// 自动检测源语言的标记值
const kAutoSource = 'auto';

/// 判断是否为自动检测源语言
bool isAutoSource(String source) => source == kAutoSource;

/// 获取源语言的显示名称
String getSourceDisplayName(String source) {
  if (isAutoSource(source)) return t.common.language.auto_detect;
  return getLanguageName(source);
}

/// 根据应用偏好推断默认目标语言
String get defaultTargetLanguage {
  final appLang = settingsStore.appLanguage;
  switch (appLang) {
    case 'en':        return 'en';
    case 'ja':        return 'ja';
    case 'ko':        return 'ko';
    case 'zh-Hans':   return 'zh-Hans';
    case 'zh-Hant':   return 'zh-Hant';
    default:          return 'zh-Hans';
  }
}
```

### Dart — uniffi 生成

运行 `python scripts/codegen.py` 后自动更新。`TranslationTarget` 的 `source` 字段保持 `String` 类型，删除生成的 `MatchStrategy` 相关代码。

---

## 二、Mini Translator 状态管理

### 状态变更

| 变量 | 类型 | 默认值 | 说明 |
|------|------|--------|------|
| `_sourceLanguage` | `String` | `kAutoSource` | `"auto"` 或具体代码 |
| `_detectedLanguage` | `String?` | `null` | 最近一次检测结果 |
| `_selectedTargetLanguage` | `String?` | `null` | 目标语言代码，`null` = 自动匹配 |
| `_activeConfigIndex` | `int` | `-1` | 当前选中的持久化目标索引，`-1` = 未选 |
| `_fastTargets` | `List<TranslationTarget>` | `[]` | 临时目标（快捷翻译生成），不持久化 |

**`_selectedTargetLanguage == null` 的含义**：用户选择"自动匹配"，翻译时不手动指定目标语言，完全由持久化目标的 `filter_active` 结果决定。

**`_activeConfigIndex >= 0` 的含义**：用户通过"切换目录"按钮选中了一个持久化目标，此时 `_sourceLanguage` 和 `_selectedTargetLanguage` 跟随该目标。翻译时不再走 `filter_active` 过滤，直接使用这个唯一目标。

### `_activeTranslationTargets()` 新逻辑

```dart
Future<List<TranslationTarget>> _activeTranslationTargets(
  GeneralSettings generalSettings,
) async {
  final persistentTargets = generalSettings.translationTargets;

  // 用户通过"切换目录"选中了一个持久化目标：直接使用它
  if (_activeConfigIndex >= 0 && _activeConfigIndex < persistentTargets.length) {
    return [persistentTargets[_activeConfigIndex]];
  }

  // 用户选了具体目标语言（非自动匹配）：生成临时目标
  if (_selectedTargetLanguage != null) {
    return [
      TranslationTarget(source: _sourceLanguage, target: _selectedTargetLanguage!),
    ];
  }

  // 自动匹配模式：使用持久化目标，按检测语言过滤
  if (persistentTargets.isNotEmpty) {
    final settings = runtime.settings();
    return await settings.getActiveTranslationTargets(
      targets: persistentTargets,
      detectedLanguage: _detectedLanguage,
    );
  }

  // 没有任何配置 + 自动匹配 → 兜底
  return [
    TranslationTarget(
      source: _sourceLanguage,
      target: defaultTargetLanguage,
    ),
  ];
}
```

**对比之前的 `_activeTranslationTargets`**：

| 维度 | 之前方案 | 新方案 |
|------|---------|--------|
| 已选持久化目标 | 走 filter_active 过滤 | **直接使用该目标，不走过滤** |
| 选了具体目标语言 | 与持久化目标合并去重 | **明确作为独立临时目标返回** |
| 自动匹配 + 有持久化目标 | 与 _fastTargets 合并后过滤 | **仅用持久化目标过滤** |
| 兜底 | 合并空列表后判断 | **按优先级清晰的三段判断** |

### `_queryData()` 中新增

语言检测后，将结果存入 `_detectedLanguage` 并触发 UI 刷新：

```dart
if (_text.isNotEmpty) {
  try {
    // ... 检测逻辑不变 ...
    if (detections != null && detections.isNotEmpty) {
      _detectedLanguage = detections.first.detectedLanguage;
    }
  } catch (e) {
    debugPrint('Language detection failed: $e');
  }
}
```

### `_buildInputView()` — 始终显示选择器

删除 `if (isTranslationTargetSelectorVisible)` 条件，`TranslationTargetSelectView` 始终渲染。

```dart
TranslationTargetSelectView(
  sourceLanguage: _sourceLanguage,
  detectedLanguage: _detectedLanguage,
  selectedTargetLanguage: _selectedTargetLanguage,
  activeConfigIndex: _activeConfigIndex,
  persistentTargets: settingsStore.general.translationTargets,
  onSourceChanged: _handleSourceChanged,
  onTargetLanguageChanged: _handleTargetLanguageChanged,
  onConfigTargetSelected: _handleConfigTargetSelected,
  onClearDetection: _handleClearDetection,
  onManageTargets: _handleManageTargets,
)
```

### 回调处理

```dart
void _handleSourceChanged(String newSource) {
  _setStateAndScheduleWindowResize(() {
    _sourceLanguage = newSource;
  });
  if (_text.isNotEmpty) _handleButtonTappedTrans();
}

void _handleTargetLanguageChanged(String? targetCode) {
  // null = 自动匹配
  // 具体代码 = 快速翻译到该语言
  _setStateAndScheduleWindowResize(() {
    _selectedTargetLanguage = targetCode;
    _activeConfigIndex = -1;  // 清除已选的持久化目标
    if (targetCode != null) {
      _fastTargets = [
        TranslationTarget(source: kAutoSource, target: targetCode),
      ];
    } else {
      _fastTargets = [];
    }
  });
  if (_text.isNotEmpty) _handleButtonTappedTrans();
}

void _handleConfigTargetSelected(int index) {
  final target = settingsStore.general.translationTargets[index];
  _setStateAndScheduleWindowResize(() {
    _activeConfigIndex = index;
    _sourceLanguage = target.source;
    _selectedTargetLanguage = target.target;
    _fastTargets = [];
  });
  if (_text.isNotEmpty) _handleButtonTappedTrans();
}

void _handleClearDetection() {
  setState(() => _detectedLanguage = null);
}

void _handleManageTargets() {
  showSettingsWindow();
}
```

---

## 三、UI 组件 — `TranslationTargetSelectView`

使用原生 `nativeapi.Menu` / `MenuItem` 实现所有菜单，不引入 Flutter 弹窗。

### 3.1 布局

```
Card
┌──────────────────────────────────────────────────────────────────┐
│ Row                                                                 │
│  [sourceButton]  [swapButton]  [targetButton]  [configButton]  [⚙]  │
│ Row (条件显示)                                                        │
│  [检测到: English ⓧ]                                                │
└──────────────────────────────────────────────────────────────────┘
```

五个区域：
- **源语言按钮** — `"auto"` + 所有语言
- **互换按钮** — auto 源时 disabled
- **目标语言按钮** — "自动匹配" + 所有语言，选具体语言 = 快速翻译
- **配置目标切换按钮**（新增）— 列出持久化目标，选中后联动 source 和 target
- **管理按钮** — 跳转 Settings

### 3.2 Widget 接口

```dart
class TranslationTargetSelectView extends StatefulWidget {
  const TranslationTargetSelectView({
    Key? key,
    required this.sourceLanguage,          // "auto" 或具体代码
    this.detectedLanguage,                 // 检测到的语言，null 表示未检测
    this.selectedTargetLanguage,           // null = 自动匹配
    this.activeConfigIndex = -1,           // -1 = 未选持久化目标
    this.persistentTargets = const [],
    required this.onSourceChanged,         // 源语言变更
    required this.onTargetLanguageChanged, // null = 自动匹配
    required this.onConfigTargetSelected,  // int index
    this.onClearDetection,
    this.onManageTargets,
  }) : super(key: key);
}
```

### 3.3 源语言按钮

与之前相同，不改变。

### 3.4 检测标签

与之前相同，不改变。

### 3.5 互换按钮

与之前相同。auto 源时 disabled。

### 3.6 目标语言按钮

**按钮文字**：

| `_selectedTargetLanguage` | 按钮文字 |
|---|---|
| `null`（自动匹配） | `t.mini_translator.language.auto_match`（"自动匹配"） |
| `"zh-Hans"` | `getLanguageName("zh-Hans")`（"中文 (简体)"） |

**菜单结构**：

```
┌─────────────────────────┐
│ ✓ 自动匹配               │ ← 第一项固定
│ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │ ← 分隔线
│   简体中文               │ ← 选具体语言 → 快速翻译
│   English               │
│   日本語                │
│   ...                   │
└─────────────────────────┘
```

**行为**：

| 点击 | 结果 |
|------|------|
| "自动匹配" | `_selectedTargetLanguage = null`，`_fastTargets` 清空，`_activeConfigIndex = -1`，由持久化目标决定翻译结果 |
| "简体中文" | `_selectedTargetLanguage = "zh-Hans"`，`_fastTargets = [{source:"auto", target:"zh-Hans"}]`，清除 `_activeConfigIndex` |

**实现**：

```dart
void _showTargetMenu() {
  final window = miniTranslatorWindowController.window;
  final menu = Menu();

  // 自动匹配（第一项）
  final autoItem = MenuItem(
    t.mini_translator.language.auto_match,
    MenuItemType.checkbox,
  );
  autoItem.state = widget.selectedTargetLanguage == null
      ? MenuItemState.checked
      : MenuItemState.unchecked;
  autoItem.on<MenuItemClickedEvent>((_) {
    widget.onTargetLanguageChanged(null);
  });
  menu.addItem(autoItem);

  // 分隔线
  menu.addItem(MenuItem.separator());

  // 所有语言
  for (final lang in supportedLanguages) {
    final item = MenuItem(
      getLanguageName(lang, showNative: true),
      MenuItemType.checkbox,
    );
    item.state = widget.selectedTargetLanguage == lang
        ? MenuItemState.checked
        : MenuItemState.unchecked;
    item.on<MenuItemClickedEvent>((_) {
      widget.onTargetLanguageChanged(lang);
    });
    menu.addItem(item);
  }

  // 定位打开...
}
```

注意：这个菜单**不包含**持久化目标和"管理翻译目标"入口——它们移到了下面的配置目标切换按钮。

### 3.7 配置目标切换按钮（新增）

**按钮文字**：

| `_activeConfigIndex` | 按钮文字 |
|---|---|
| `-1`（未选） | `t.mini_translator.language.switch_config`（"切换目录"） |
| `0`（选中`auto→zh-Hans`） | `自动检测 → 中文(简体)`（`getSourceDisplayName(source)` + `→` + `getLanguageName(target)`） |

**菜单结构**：

```
┌─────────────────────────────────────┐
│ ✓ 自动检测 → 中文(简体)              │ ← 当前选中
│   英语 → 日本語                     │
│   日本語 → 中文(简体)                │
│ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ ─ │ ← 分隔线
│   ⚙ 管理翻译目标...                  │ ← 跳转 Settings
└─────────────────────────────────────┘
```

**行为**：

| 点击 | 结果 |
|------|------|
| 某个持久化目标 | `_activeConfigIndex = index`，`_sourceLanguage = 目标的 source`，`_selectedTargetLanguage = 目标的 target`，`_fastTargets` 清空 |
| "管理翻译目标..." | 跳转 Settings |

选中持久化目标后，源语言按钮和目标语言按钮的文字随之更新。

**实现**：

```dart
void _showConfigMenu() {
  final window = miniTranslatorWindowController.window;
  final menu = Menu();

  for (var i = 0; i < widget.persistentTargets.length; i++) {
    final target = widget.persistentTargets[i];
    final label = '${getSourceDisplayName(target.source)} → ${getLanguageName(target.target)}';
    final item = MenuItem(label, MenuItemType.checkbox);
    item.state = widget.activeConfigIndex == i
        ? MenuItemState.checked
        : MenuItemState.unchecked;
    item.on<MenuItemClickedEvent>((_) {
      widget.onConfigTargetSelected(i);
    });
    menu.addItem(item);
  }

  menu.addItem(MenuItem.separator());

  final manageItem = MenuItem(
    '⚙ ${t.settings.general.button.manage_targets}',
    MenuItemType.normal,
  );
  manageItem.on<MenuItemClickedEvent>((_) => widget.onManageTargets?.call());
  menu.addItem(manageItem);

  // 定位打开...
}
```

### 3.8 管理按钮

与之前相同，`⚙` 图标按钮跳转 Settings。

### 3.9 交互总表

| 操作哪个按钮 | 选了什么 | `_sourceLanguage` | `_selectedTargetLanguage` | `_activeConfigIndex` | 翻译使用 |
|------------|---------|-------------------|--------------------------|---------------------|---------|
| 源语言 | `auto` | `"auto"` | 不变 | 清为 -1 | auto + 自动匹配 → filter_active |
| 源语言 | `en` | `"en"` | 不变 | 清为 -1 | en + 自动匹配 → filter_active |
| 目标语言 | 自动匹配 | 不变 | `null` | 清为 -1 | filter_active |
| 目标语言 | `fr` | 不变 | `"fr"` | 清为 -1 | `{source:当前源, target:"fr"}` 临时目标 |
| 切换目录 | 索引 i | 目标的 source | 目标的 target | `i` | 直接使用该目标 |

---

## 四、Settings 页面变更

### `general.dart`

- 删除 `_matchStrategyTitle()` 方法
- 删除添加/编辑对话框中的策略选择器
- 源语言下拉加入 `"auto"` 选项：

```dart
final sourceItems = [
  DropdownMenuItem(value: kAutoSource, child: Text(t.common.language.auto_detect)),
  for (final lang in supportedLanguages)
    DropdownMenuItem(value: lang, child: Text(getLanguageName(lang, showNative: true))),
];
```

- 列表项展示使用 `getSourceDisplayName` 显示源语言名称
- 添加目标时：

```dart
TranslationTarget(source: source ?? kAutoSource, target: target)
```

### `settings_store.dart`

首次启动时添加默认翻译目标：

```dart
if (_general.translationTargets.isEmpty) {
  await updateGeneral(GeneralSettingsPatch(
    translationTargets: [
      TranslationTarget(
        source: kAutoSource,
        target: defaultTargetLanguage,
      ),
    ],
  ));
}
```

---

## 五、结果展示优化（可选）

### `translation_results_view.dart`

多目标时默认展开第一个，其余折叠。折叠成一个可点击的标签行。

```
┌─────────────────────────────────────────┐
│  自动检测 → 中文(简体)      ← 展开        │
│  ┌─────────────────────────────────────┐ │
│  │  Provider A 结果...                  │ │
│  └─────────────────────────────────────┘ │
│                                           │
│  ⏴ +2 more (英语→日本語, 英語→한국어)     │ ← 折叠，点击展开
└─────────────────────────────────────────┘
```

---

## 六、数据流总览

```
Mini Translator 启动
    │
    ├── _sourceLanguage = "auto"
    ├── _selectedTargetLanguage = null（自动匹配）
    ├── _activeConfigIndex = -1
    ├── _fastTargets = []
    ├── persistentTargets = settings.translationTargets
    │     └─ 首次启动 → [{"source":"auto","target":"zh-Hans"}]
    │
    ▼
用户输入 "Hello" → 点击翻译
    │
    ├── detectLanguage("Hello") → "en"
    │     └─ _detectedLanguage = "en"
    │        └─ UI: 源按钮下方显示 "检测到: English ⓧ"
    │
    ├── _activeTranslationTargets() 三段判断:
    │     │
    │     ├─ _activeConfigIndex >= 0?
    │     │     └─ Yes → 直接使用 persistentTargets[index]
    │     │
    │     ├─ _selectedTargetLanguage != null?
    │     │     └─ Yes → 生成临时目标 {source:当前源, target:所选语言}
    │     │
    │     └─ 自动匹配:
    │           ├─ 有持久化目标 → filter_active → 按检测语言过滤
    │           └─ 无持久化目标 → 兜底 {source:auto, target:defaultTargetLanguage}
    │
    └── 每个 activeTarget × 每个 Provider 执行翻译
```

---

## 七、文件变更清单

| 文件 | 操作 | 说明 |
|------|------|------|
| `crates/core/src/model/translation_target.rs` | **重写** | 删 `MatchStrategy`，`source` 保持 `String`，`"auto"` 哨兵值 |
| `crates/core/src/model/mod.rs` | 微调 | 删 `MatchStrategy` 的 mod 和 pub use |
| `crates/core/src/lib.rs` | 微调 | 删 `MatchStrategy` 导出 |
| `packages/runtime/rust/src/remote.rs` | 微调 | 删 `MatchStrategy` remote 绑定 |
| `packages/runtime/rust/src/domain/settings.rs` | 微调 | 删 `MatchStrategy` 的 use |
| `packages/runtime/rust/src/runtime.rs` | 微调 | 更新注释 |
| `packages/runtime/lib/src/generated/*` | **自动** | 运行 `python scripts/codegen.py` |
| `apps/desktop/lib/src/utils/language_util.dart` | **改写** | 增 `kAutoSource`、`getSourceDisplayName`、`defaultTargetLanguage` 智能推断 |
| `apps/desktop/lib/src/i18n/*.g.dart` | 微调 | 增 `common.language.auto_detect`、`mini_translator.language.*` |
| `apps/desktop/lib/src/routes/mini_translator/mini_translator.dart` | **改写** | 状态变量重构，合并目标逻辑，删除条件显示 |
| `apps/desktop/lib/src/routes/mini_translator/translation_target_select_view.dart` | **重写** | 新接口 + 原生 Menu 实现 |
| `apps/desktop/lib/src/routes/mini_translator/translation_results_view.dart` | 优化 | 多目标折叠展示（可选） |
| `apps/desktop/lib/src/routes/settings/general.dart` | **改写** | 删策略 UI，源语言支持 auto |
| `apps/desktop/lib/src/services/settings_store.dart` | 微调 | 首次启动预设 |
