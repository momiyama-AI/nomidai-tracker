# App Store Privacy Answers

最終更新日: 2026年7月3日

App Store Connect の「アプリのプライバシー」入力用メモです。

## 基本方針

- 本アプリはサーバー、外部API、アカウント登録、広告SDKを使用しない。
- 記録データは端末内のSwiftDataに保存する。
- CSV共有は利用者が明示操作した場合のみ、利用者が選択した共有先へ渡る。
- アプリ内課金はApple StoreKit / App Storeの仕組みを利用する。

## 回答案

| 項目 | 回答 |
|---|---|
| データを収集しますか | いいえ |
| トラッキングに使用しますか | いいえ |
| サードパーティ広告 | なし |
| 分析/クラッシュ収集SDK | なし |
| ユーザーアカウント | なし |
| 位置情報 | なし |
| 連絡先 | なし |
| 端末外への記録データ送信 | なし |

## PrivacyInfo.xcprivacy

`NomidaiTracker/Resources/PrivacyInfo.xcprivacy` は以下の状態。

- `NSPrivacyCollectedDataTypes`: 空
- `NSPrivacyTracking`: false
- `NSPrivacyTrackingDomains`: 空
- `NSPrivacyAccessedAPITypes`: 空

## 注意

将来、CloudKit同期、分析、クラッシュ収集、広告、問い合わせフォーム、外部APIを追加する場合は、この回答と `PrivacyInfo.xcprivacy` の再確認が必要。
