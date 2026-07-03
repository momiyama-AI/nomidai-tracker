# 飲み代トラッカー

飲み代トラッカーは、家飲み・外飲みの支出を端末内で記録し、今月の飲み代をすばやく確認するためのiPhoneアプリです。

## 特徴

- 完全ローカル動作。サーバー、外部API、アカウント登録なし。
- SwiftUI / SwiftData / WidgetKit / StoreKit 2 を使用。
- 家飲み・外飲みのクイック記録、月次サマリー、カレンダー、予算、ウィジェットに対応。
- Pro機能として全期間グラフ、CSV出力、カスタムプリセット無制限、中サイズウィジェットを用意。
- データ収集なしのプライバシーマニフェストを同梱。

## 開発環境

- Xcode 16系
- Swift 5.10+
- iOS 17.0+
- 外部ライブラリなし

## ビルドとテスト

クラウドMacまたはmacOS上で実行します。

```sh
xcodebuild test \
  -project NomidaiTracker.xcodeproj \
  -scheme NomidaiTracker \
  -destination 'platform=iOS Simulator,name=iPhone 16 Pro' \
  CODE_SIGNING_ALLOWED=NO
```

Archive / TestFlightアップロードにはApple Developerの署名設定が必要です。現在の手順と未解決事項は `AppStore/provisioning.md` を参照してください。
Apple Developerで作成するApp ID/App Groupの詳細は `AppStore/apple-developer-setup.md` を参照してください。
署名設定後のArchive確認は `bash scripts/archive-testflight.sh` で実行できます。
提出前のローカル成果物確認は `bash scripts/verify-release-readiness.sh` で実行できます。
App Store Connect入力値の文字数確認は `python3 scripts/verify-app-store-metadata.py` で実行できます。

GitHubにpush後は `.github/workflows/ios-ci.yml` により、pushとpull requestで自動テストが走ります。
`momiyama-AI/nomidai-tracker` 作成後の初回pushは `bash scripts/push-github.sh` で実行できます。

## App Store提出資料

- `AppStore/submission.md`: App Store Connect入力メモ
- `AppStore/app-store-connect-fields.md`: App Store Connect入力シート
- `AppStore/privacy-answers.md`: プライバシー回答案
- `AppStore/export-compliance.md`: 輸出コンプライアンス回答案
- `AppStore/age-rating.md`: 年齢制限回答案
- `AppStore/iap-products.md`: アプリ内課金商品設定案
- `AppStore/review-notes.md`: App Review Notes入力案
- `AppStore/release-checklist.md`: リリース前チェックリスト
- `AppStore/current-status.md`: 現在の準備状況と外部設定待ち
- `AppStore/screenshots/`: 提出用スクリーンショット

## 法務ページ

GitHub Pagesで `docs` を公開元にすると、以下をApp Store Connectとアプリ内リンクで利用できます。

- 利用規約: `https://momiyama-ai.github.io/nomidai-tracker/terms/`
- プライバシーポリシー: `https://momiyama-ai.github.io/nomidai-tracker/privacy/`
- サポート: `https://momiyama-ai.github.io/nomidai-tracker/support/`

公開手順は `AppStore/github-pages.md` を参照してください。
公開後の疎通確認には `bash scripts/verify-pages.sh` を使えます。

## 重要な方針

- 本アプリは酒類の支出記録アプリであり、健康改善、節酒、禁酒、依存症治療、医療助言を目的としません。
- 記録データは原則として利用者の端末内に保存されます。
- 仕様判断は `SPEC.md` を単一の真実として扱います。
