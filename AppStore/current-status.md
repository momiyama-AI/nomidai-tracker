# Current Status

最終更新日: 2026年7月3日

飲み代トラッカーの現在の提出準備状況です。

## 完了済み

- iOSアプリ本体の主要機能実装
- SwiftDataモデル、Repository、Calculator
- クイック記録、ホーム、カレンダー、設定、予算
- WidgetKit小/中ウィジェット
- StoreKit 2の買い切り/サブスク対応
- Pro機能制御、全期間グラフ、CSV出力
- App Group entitlement設定
- App Store用アプリアイコン
- App Store提出用スクリーンショット
- 利用規約、プライバシーポリシー、サポートページ原稿
- PrivacyInfo.xcprivacy
- App Store Connect入力メモ
- GitHub Pages公開手順
- GitHub Actions CI設定

## ローカル検証済み

- クラウドMacで `xcodebuild test` 成功済み。
- 最終確認時点のテストは 62件成功、失敗0件。
- ドキュメント変更のみのコミットではXcodeビルド/テストは省略。

## 外部設定待ち

### GitHub

- `momiyama-AI/nomidai-tracker` リポジトリは確認時点で未作成または未アクセス。
- リポジトリ作成後、ローカルのremoteを追加してpushする。
- GitHub Pagesの公開元を `docs` に設定する。
- 法務ページURLが開けることを確認する。

### Apple Developer

- XcodeのApple ID再ログインが必要。
- App ID `com.momi0216yama.nomidaitracker` の作成が必要。
- Widget App ID `com.momi0216yama.nomidaitracker.widget` の作成が必要。
- App Group `group.com.momi0216yama.nomidaitracker` の作成と紐づけが必要。
- Provisioning Profileの生成が必要。

### App Store Connect

- 新規アプリ作成
- Bundle ID選択
- スクリーンショット登録
- サポートURL、利用規約URL、プライバシーポリシーURL登録
- プライバシー回答
- 年齢制限17+設定
- IAP商品作成

## 次の推奨順序

1. GitHubで `momiyama-AI/nomidai-tracker` を作成する。
2. このリポジトリをpushする。
3. GitHub Pagesで `docs` を公開する。
4. Apple DeveloperでApp ID、Widget App ID、App Groupを作成する。
5. XcodeでArchiveを作成する。
6. App Store ConnectでアプリとIAP商品を作成する。
7. TestFlightへアップロードする。
