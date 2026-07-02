# 飲み代トラッカー 仕様書

この文書を本プロジェクトの単一の真実とする。Claude Codeは実装前に必ず本書と `CLAUDE.md` を読むこと。

## 1. プロダクト概要

- 名称(仮): 飲み代トラッカー
- コンセプト: 「今月、酒にいくら使ったか」を1秒で把握できる家飲み・外飲み支出トラッカー。
- 差別化: 健康軸や禁酒軸ではなく、実支出軸。日本の容量規格に完全対応する。
- ターゲット: 晩酌習慣があり、飲み代を節約したい20〜50代の日本人。
- 動作方針: 完全ローカル動作。サーバー、外部API、アカウント登録は一切なし。
- 言語: 日本語のみ。

## 2. App Store審査方針

- 年齢制限: 17+。アルコールへの言及があるため。
- 健康、医療、節酒効果、禁酒効果、依存症改善を示唆する文言は禁止。
- 純アルコール量は参考情報としてのみ表示する。
- マスコットのセリフは支出ジョークに限定し、説教、健康注意、飲酒量への価値判断は禁止。
- 設定画面に適正飲酒の注意書きを置く。ただし医療助言に見せない。
- データ収集ゼロのPrivacy Manifestを用意する。
- StoreKit 2実装時は購入復元ボタン、利用規約リンク、プライバシーポリシーリンクを必ず置く。

## 3. 技術要件

- Swift 5.10+
- SwiftUI
- iOS 17.0+
- SwiftData
- WidgetKit + App Group
- StoreKit 2
- Swift Charts
- 外部ライブラリ原則ゼロ
- アーキテクチャ: MV + Repository層。過剰な抽象化は禁止。
- 金額は必ず `Int` の円単位で保存、計算、表示する。`Double` / `Decimal` を金額に使わない。
- 日付は `Calendar.current` を使い、月境界はユーザーのタイムゾーン基準。
- 文字列は `Localizable.strings` に集約する。
- 全画面に `#Preview` を用意する。

### 3.1 整数計算ルール

度数は小数を避けるため `abvTenthsPercent` として保存する。

- 5.0% => `50`
- 7.0% => `70`
- 12.5% => `125`

純アルコール量は表示精度を保つため `pureAlcoholTenthsGram` として保存または算出する。

```text
純アルコール量(g) = 容量(ml) × 度数(%) / 100 × 0.8

pureAlcoholTenthsGram =
  volumeML * abvTenthsPercent * 8 / 1000
```

例: 350ml、5.0%の場合:

```text
350 * 50 * 8 / 1000 = 140
=> 14.0g
```

表示は整数除算と剰余で `14.0g` のように整形する。

## 4. MVP機能

### 4.1 クイック記録

ホームから3タップ以内で記録完了する。

標準プリセット:

| プリセット | 種別 | 容量 | 初期度数 | 初期価格 | 備考 |
|---|---:|---:|---:|---:|---|
| 缶ビール350 | 家飲み | 350ml | 5.0% | 220円 | 編集可能 |
| 缶ビール500 | 家飲み | 500ml | 5.0% | 300円 | 編集可能 |
| 缶チューハイ350 | 家飲み | 350ml | 7.0% | 170円 | 編集可能 |
| 缶チューハイ500 | 家飲み | 500ml | 7.0% | 230円 | 編集可能 |
| ハイボール | 家飲み | 350ml | 7.0% | 210円 | 編集可能 |
| 日本酒1合 | 家飲み | 180ml | 15.0% | 250円 | 編集可能 |
| ワイングラス | 家飲み | 120ml | 12.0% | 300円 | 編集可能 |
| 外飲み | 外飲み | 0ml | 0.0% | 3000円 | 金額のみ入力 |

3タップフローの推奨定義:

1. ホームの「記録」またはプリセットをタップ。
2. プリセットをタップ。
3. 確定ボタンをタップ。

ただしホームに上位プリセットを直接表示できる場合は「プリセットをタップ」「確定」の2タップ完了を許可する。価格や数量を変更する場合は追加操作を許容する。

よく飲むものは `usageCount` と `lastUsedAt` を使って上位表示する。

### 4.2 今月サマリー

ホーム画面に以下を表示する。

- 今月の飲み代合計。最大表示。
- 先月同日比。
- 家飲み/外飲み内訳。
- 純アルコール量合計(g)。参考情報として小さく表示。
- 休肝日数。記録なしの日を自動カウントする。
- 月次予算の残額と消化ペース。

休肝日は当月1日から今日までを対象にし、未来日は除外する。

### 4.3 マスコット「のみだぬき」

ホーム画面の主役として表示する。

基準値:

- 初期値: 月5,500円。
- 根拠: 総務省家計調査ベースの目安。単身世帯の酒類約2,500円 + 外食飲酒代約3,000円。
- 設定画面で変更可能。
- 出典注記を設定画面に表示する。

日割り比較:

```text
ratio = 今月の支出累計 ÷ (基準値 × 経過日数 ÷ 当月日数)
```

0除算回避:

- 基準値が0以下の場合は、内部では1円として扱う。
- 経過日数は最低1日として扱う。
- 当月日数は `Calendar.current.range(of: .day, in: .month, for: date)` から取得し、取得不能時は30日。

WealthLevel判定:

| ratio | 状態名 | enum | 見た目の例 |
|---:|---|---|---|
| < 0.3 | 大富豪 | `grandRich` | 王冠・葉巻・札束・豪邸背景 |
| 0.3〜0.7 | 富豪 | `rich` | シルクハット・ワイングラス |
| 0.7〜1.0 | 小金持ち | `comfortable` | 小綺麗な服・にこにこ |
| 1.0〜1.5 | 庶民 | `normal` | 普段着・普通の表情 |
| 1.5〜2.0 | 金欠 | `broke` | ボロい服・涙目・裸電球 |
| >= 2.0 | 極貧 | `extremePoor` | ツギハギ服・ダンボール・悟りの表情 |

境界値は上の行を含まず、次の行に含める。例: `0.3` は富豪、`0.7` は小金持ち、`1.0` は庶民。

セリフ例:

| WealthLevel | セリフ |
|---|---|
| 大富豪 | 「今夜はドンペリでも開けるかね」 / 「財布が重くて肩がこるのう」 |
| 富豪 | 「余裕の一杯、いただきます」 / 「今日はグラスも輝いて見えるぞ」 |
| 小金持ち | 「なかなか上手にやりくりしておる」 / 「この調子ならおつまみも豪華じゃ」 |
| 庶民 | 「まあ、こんな夜もあるさ」 / 「平常運転じゃな」 |
| 金欠 | 「今月の財布、薄いのう…」 / 「電球まで節約モードじゃ」 |
| 極貧 | 「もやし、うまい…」 / 「段ボールも案外あたたかいぞ」 |

禁止:

- 説教。
- 健康への言及。
- 飲酒量への善悪評価。
- 医療、節酒、禁酒効果の示唆。

v1.0のアセット:

- 外部イラスト不要。
- SwiftUI描画 + SF Symbols + 絵文字のプレースホルダー。
- 後からPNG差し替え可能な `CharacterView` 抽象化を用意する。

### 4.4 カレンダー

- 日別支出ヒートマップを表示する。
- 記録なしの日を休肝日として自動カウントする。
- 今日より未来の日は休肝日に含めない。
- 日をタップするとその日の記録一覧を表示する。

### 4.5 月次予算

- 月次予算を設定できる。
- 今月残額を表示する。
- 経過日数ベースの消化ペースを表示する。
- 予算未設定の場合は「未設定」と表示し、エラー扱いにしない。

### 4.6 ウィジェット

WidgetKitで小/中を実装する。

- 小: 今月合計 + キャラ。
- 中: 今月合計 + 予算残額 + 休肝日数 + キャラ。
- 中ウィジェットは有料機能としてペイウォール制御する。
- App Groupでアプリ本体とデータ共有する。

### 4.7 有料機能

StoreKit 2で実装する。

- 買い切り: 600円想定。
- サブスク: 200円/月想定。
- v1.0では両方の実装を持ち、リリース時に運用方針を選択する。

有料対象:

- 全期間グラフ(Swift Charts)。
- CSV出力。
- カスタムプリセット無制限。
- 中ウィジェット。

無料版の推奨制限:

- 標準プリセット編集は可能。
- カスタムプリセット追加は3個まで。
- 小ウィジェットは無料。
- グラフは当月のみ簡易表示、全期間グラフは有料。

## 5. 画面一覧

| 画面 | 目的 | 主な要素 | フェーズ |
|---|---|---|---|
| ホーム | 1秒で今月支出を把握 | 今月合計、先月同日比、内訳、のみだぬき、上位プリセット | P3 |
| クイック記録 | 3タップ以内で記録 | プリセット、金額、数量、確定 | P2 |
| 記録編集 | 誤入力修正 | 日時、金額、数量、削除 | P2/P3 |
| カレンダー | 日別支出確認 | ヒートマップ、日別一覧、休肝日表示 | P3 |
| 予算 | 予算管理 | 月次予算、残額、ペース | P4 |
| プリセット編集 | 飲み物設定 | 名称、価格、容量、度数、家/外 | P4 |
| 設定 | 基準値/注意書き/法務 | 5,500円基準、適正飲酒注意、Privacy/Terms | P4/P6 |
| ペイウォール | 有料機能解放 | 買い切り、月額、復元、リンク | P6 |
| グラフ | 全期間推移 | Swift Charts | P6 |
| CSV出力 | データ持ち出し | CSVプレビュー/共有 | P6 |

## 6. 画面遷移図

```mermaid
flowchart TD
    A["アプリ起動"] --> B["ホーム"]
    B --> C["クイック記録"]
    C --> D["プリセット選択"]
    D --> E["金額/数量確認"]
    E --> B
    B --> F["カレンダー"]
    F --> G["日別記録一覧"]
    G --> H["記録編集"]
    B --> I["予算"]
    B --> J["設定"]
    J --> K["プリセット編集"]
    J --> L["基準値変更"]
    J --> M["ペイウォール"]
    B --> N["グラフ"]
    N --> M
    B --> O["CSV出力"]
    O --> M
```

## 7. SwiftDataモデル定義

以下は仕様上の擬似Swift定義であり、Claude Codeは実装時にSwiftDataの制約に合わせて調整してよい。ただし意味と保存項目は維持する。

### 7.1 DrinkPreset

```swift
@Model
final class DrinkPreset {
    @Attribute(.unique) var id: UUID
    var name: String
    var categoryRawValue: String
    var locationRawValue: String
    var defaultPriceYen: Int
    var volumeML: Int
    var abvTenthsPercent: Int
    var iconName: String
    var colorName: String
    var isDefault: Bool
    var isArchived: Bool
    var sortIndex: Int
    var usageCount: Int
    var lastUsedAt: Date?
    var createdAt: Date
    var updatedAt: Date
}
```

`categoryRawValue` 候補:

- `beer`
- `chuhai`
- `highball`
- `sake`
- `wine`
- `outside`
- `custom`

`locationRawValue` 候補:

- `home`
- `outside`

### 7.2 DrinkEntry

```swift
@Model
final class DrinkEntry {
    @Attribute(.unique) var id: UUID
    var occurredAt: Date
    var presetID: UUID?
    var presetNameSnapshot: String
    var categoryRawValue: String
    var locationRawValue: String
    var quantity: Int
    var amountYen: Int
    var volumeML: Int
    var abvTenthsPercent: Int
    var pureAlcoholTenthsGram: Int
    var memo: String
    var createdAt: Date
    var updatedAt: Date
}
```

方針:

- 記録後にプリセットが変更されても過去記録が変わらないよう、名称、価格、容量、度数をスナップショット保存する。
- 外飲みは金額のみ入力のため、初期値では `volumeML = 0`、`abvTenthsPercent = 0`、`pureAlcoholTenthsGram = 0` とする。
- `quantity` は最低1。
- `amountYen` は単価ではなく合計金額。

### 7.3 UserSettings

```swift
@Model
final class UserSettings {
    @Attribute(.unique) var id: UUID
    var baselineMonthlyYen: Int
    var monthlyBudgetYen: Int?
    var hasSeenOnboarding: Bool
    var selectedThemeRawValue: String
    var createdAt: Date
    var updatedAt: Date
}
```

方針:

- `baselineMonthlyYen` 初期値は5500。
- `monthlyBudgetYen` がnilの場合、予算未設定。
- アプリ内に1件だけ存在するシングルトン設定として扱う。

### 7.4 PurchaseEntitlement

```swift
@Model
final class PurchaseEntitlement {
    @Attribute(.unique) var id: UUID
    var productID: String
    var entitlementRawValue: String
    var isActive: Bool
    var expirationDate: Date?
    var latestTransactionID: String?
    var updatedAt: Date
}
```

方針:

- StoreKit 2の現在状態を反映するキャッシュ。
- 購入状態の最終判断はStoreKitのTransaction検証結果を優先する。

### 7.5 集計用モデルは作らない

月次集計、休肝日、WealthLevelはRepository/Calculatorで都度算出する。保存済み集計との不整合を避けるため、v1.0では集計キャッシュモデルを作らない。

## 8. Repository / Calculator

P1で最低限用意する。

| 型 | 役割 |
|---|---|
| `DrinkEntryRepository` | 記録の作成、取得、更新、削除 |
| `DrinkPresetRepository` | 標準プリセットの初期投入、並び順、使用回数更新 |
| `SettingsRepository` | `UserSettings` の取得、初期化、更新 |
| `SummaryRepository` | 月次サマリーの組み立て |
| `AlcoholCalculator` | 純アルコール量の整数計算 |
| `MonthCalculator` | 月初、月末、経過日数、先月同日範囲 |
| `CharacterEngine` | ratioとWealthLevel、セリフ選択 |
| `CSVExporter` | P6で実装。CSVエスケープはテスト必須 |

RepositoryはSwiftDataの `ModelContext` を受け取り、UIから直接SwiftDataクエリが増えすぎないようにする。ただし過剰なDIコンテナは作らない。

## 9. ディレクトリ構成

Claude CodeはP1でXcodeプロジェクトを作成する場合、以下を基準にする。

```text
NomidaiTracker/
|-- NomidaiTracker.xcodeproj/
|-- NomidaiTracker/
|   |-- App/
|   |   |-- NomidaiTrackerApp.swift
|   |   `-- AppEnvironment.swift
|   |-- Models/
|   |   |-- DrinkEntry.swift
|   |   |-- DrinkPreset.swift
|   |   |-- UserSettings.swift
|   |   `-- PurchaseEntitlement.swift
|   |-- Repositories/
|   |   |-- DrinkEntryRepository.swift
|   |   |-- DrinkPresetRepository.swift
|   |   |-- SettingsRepository.swift
|   |   `-- SummaryRepository.swift
|   |-- Calculators/
|   |   |-- AlcoholCalculator.swift
|   |   |-- MonthCalculator.swift
|   |   `-- CharacterEngine.swift
|   |-- Views/
|   |   |-- Home/
|   |   |-- QuickRecord/
|   |   |-- Calendar/
|   |   |-- Settings/
|   |   |-- Paywall/
|   |   `-- Components/
|   |-- Resources/
|   |   |-- Localizable.strings
|   |   `-- PrivacyInfo.xcprivacy
|   `-- Supporting/
|       |-- AppGroup.swift
|       `-- ProductIDs.swift
|-- NomidaiTrackerWidget/
|-- NomidaiTrackerTests/
|-- SPEC.md
|-- CLAUDE.md
`-- AGENTS.md
```

## 10. フェーズ計画

各フェーズでビルド確認とコミットを必須とする。コミットメッセージは日本語1行。

### P1: プロジェクト構成 + SwiftDataモデル + Repository + ユニットテスト

目的:

- iOS 17 SwiftUIプロジェクトを作る。
- SwiftDataモデルを作る。
- RepositoryとCalculatorの土台を作る。
- P1範囲のXCTestを追加する。

完了条件:

- アプリがビルドできる。
- SwiftDataモデルが起動時に初期化される。
- 標準プリセットが初回起動時に投入される。
- 金額がIntで扱われている。
- `AlcoholCalculator`、`MonthCalculator`、`CharacterEngine` のユニットテストがある。
- コミットされている。

### P2: クイック記録画面

目的:

- 3タップ以内で記録完了する導線を作る。
- 使用頻度順のプリセット表示を実装する。

完了条件:

- ホームまたは仮ホームから記録画面へ遷移できる。
- 標準プリセットで記録を追加できる。
- 外飲みは金額のみで記録できる。
- 記録後に `usageCount` と `lastUsedAt` が更新される。
- 入力バリデーションがある。

### P3: ホーム画面 + CharacterEngine + CharacterView + カレンダー

目的:

- 今月サマリーと「のみだぬき」をホームの主役として実装する。
- カレンダーのヒートマップを実装する。

完了条件:

- 今月合計、先月同日比、家/外内訳、純アルコール量、休肝日が表示される。
- WealthLevelに応じてキャラ表示とセリフが変わる。
- 状態遷移にアニメーションがある。
- 日別ヒートマップが表示される。

### P4: 月次予算 + 設定画面

目的:

- 予算設定、基準値変更、プリセット編集、注意書きを実装する。

完了条件:

- 月次予算を設定/解除できる。
- 基準値5,500円を変更できる。
- プリセットの価格、容量、度数を編集できる。
- 適正飲酒の注意書きと出典注記がある。
- 健康・医療効果を謳う文言がない。

### P5: WidgetKit

目的:

- 小/中ウィジェットを実装する。
- App Groupでデータ共有する。

完了条件:

- 小ウィジェットに今月合計とキャラが出る。
- 中ウィジェットに今月合計、予算残額、休肝日数、キャラが出る。
- 中ウィジェットは有料機能フラグに従う。
- App Groupの共有漏れがない。

### P6: StoreKit 2 + 有料機能

目的:

- ペイウォール、購入、復元、有料機能制御を実装する。
- 全期間グラフとCSV出力を実装する。

完了条件:

- StoreKit 2で買い切り/サブスク双方の状態を扱える。
- 購入復元ボタンがある。
- 利用規約/プライバシーポリシーリンクがある。
- Swift Chartsで全期間グラフが表示される。
- CSV出力ができ、CSVエスケープのテストがある。

## 11. v1.1ロードマップ

### CloudKit同期

- SwiftData + CloudKitで複数端末同期。
- `UUID` 主キーを維持。
- 集計キャッシュを保存しない方針を維持。
- CloudKit導入前にSwiftDataマイグレーション計画を作る。

### Live Activity

- 今月支出、予算残額、のみだぬき状態をロック画面/ Dynamic Islandに表示。
- 飲酒中タイマーではなく支出トラッカーとして表現する。
- 健康/節酒効果に見える文言は禁止。

### 追加候補

- レシート手入力補助。
- 月別レポート画像生成。
- PNG版のみだぬきアセット差し替え。
- iCloudバックアップ/エクスポート強化。

## 12. 未確定事項と推奨仮決め

| 質問 | 推奨仮決め |
|---|---|
| Bundle ID | `com.momi0216yama.nomidaitracker` |
| App Group ID | `group.com.momi0216yama.nomidaitracker` |
| Product ID | `nomidai.pro.lifetime` と `nomidai.pro.monthly` |
| アプリ正式名 | v1.0は「飲み代トラッカー」。キャラ名は画面内で「のみだぬき」。 |
| 外飲みの純アルコール量 | 金額のみ要件を優先し、v1.0では0g扱い。表示に「容量入力分のみ」と注記する。 |
| 利用規約/プライバシーポリシーURL | P6までにGitHub Pages等で用意。P1ではプレースホルダー定数のみ。 |
| 標準プリセット価格 | 本書の初期価格で仮実装。P4で編集可能にする。 |
| 有料方式 | 実装は買い切り/サブスク両対応。リリース直前に片方をApp Store Connectで有効化。 |

