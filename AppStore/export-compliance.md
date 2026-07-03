# Export Compliance

最終更新日: 2026年7月3日

App Store Connect の輸出コンプライアンス入力用メモです。

## 方針

- 本アプリは独自の暗号化機能を実装しない。
- サーバー、外部API、アカウント登録、独自通信基盤は使用しない。
- 法務ページを開くためのHTTPSリンク、StoreKit、Apple標準フレームワークの利用のみ。
- `ITSAppUsesNonExemptEncryption` はアプリ本体とWidgetで `false` として明示する。

## App Store Connect回答案

| 項目 | 回答案 |
|---|---|
| 輸出コンプライアンス情報 | 独自の非免除暗号化を使用しない |
| 暗号化アルゴリズムの独自実装 | なし |
| HTTPS等の標準的な通信保護以外の暗号化 | なし |
| サーバー連携 | なし |

## 実装箇所

- アプリ本体: `NomidaiTracker.xcodeproj/project.pbxproj` の `INFOPLIST_KEY_ITSAppUsesNonExemptEncryption = NO;`
- Widget: `NomidaiTrackerWidget/Info.plist` の `ITSAppUsesNonExemptEncryption = false`

## 注意

将来、CloudKit同期、独自サーバー、外部API、暗号化バックアップ、認証、分析SDKなどを追加する場合は、提出前に輸出コンプライアンス回答を再確認する。
