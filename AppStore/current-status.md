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
- Required Reason APIのUserDefaults理由コード `CA92.1`
- 輸出コンプライアンス用 `ITSAppUsesNonExemptEncryption = false` 設定
- App Store Connect入力メモ
- App Review Notes入力メモ
- GitHub Pages公開手順
- GitHub Actions CI設定
- ペイウォール提出画像の月額サブスク説明反映
- ローカル提出準備チェック `scripts/verify-release-readiness.sh`

## ローカル検証済み

- クラウドMacで `xcodebuild test` 成功済み。
- `bash scripts/verify-release-readiness.sh` で署名前の提出物整合性を確認可能。
- 最終確認: 2026年7月3日、ペイウォール提出画像更新後にiPhone 16 Pro Simulatorで `TEST SUCCEEDED`。
- 実行コマンド:

```sh
xcodebuild test \
  -project NomidaiTracker.xcodeproj \
  -scheme NomidaiTracker \
  -destination id=50FD8F69-DBF1-48B8-B877-E5ED3AD92AB2 \
  CODE_SIGNING_ALLOWED=NO \
  -resultBundlePath /tmp/nomidai_paywall_screenshot_test.xcresult
```

## 外部設定待ち

### GitHub

- `momiyama-AI/nomidai-tracker` リポジトリは確認時点で未作成または未アクセス。
- GitHub連携検索でも `momiyama-AI` 配下に `nomidai` 関連リポジトリは見つからなかった。
- リポジトリ作成後、ローカルのremoteを追加してpushする。
- GitHub Pagesの公開元を `docs` に設定する。
- `bash scripts/verify-pages.sh` で法務ページURLが開けることを確認する。

### Apple Developer

- 2026年7月3日にArchiveを再実行し、Apple IDログイン拒否とProvisioning Profile未作成で失敗。
- XcodeのApple ID再ログインが必要。
- App ID `com.momi0216yama.nomidaitracker` の作成が必要。
- Widget App ID `com.momi0216yama.nomidaitracker.widget` の作成が必要。
- App Group `group.com.momi0216yama.nomidaitracker` の作成と紐づけが必要。
- Provisioning Profileの生成が必要。
- 再確認コマンド: `bash scripts/archive-testflight.sh`

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
5. `bash scripts/archive-testflight.sh` でArchiveを作成する。
6. App Store ConnectでアプリとIAP商品を作成する。
7. TestFlightへアップロードする。
