# Release Checklist

最終更新日: 2026年7月3日

## Apple Developer

- [ ] Xcode > Settings > Accounts でApple IDに再ログインする。
- [ ] Team `K4RPQR296Y` が表示されることを確認する。
- [ ] App ID `com.momi0216yama.nomidaitracker` を作成する。
- [ ] Widget App ID `com.momi0216yama.nomidaitracker.widget` を作成する。
- [ ] App Group `group.com.momi0216yama.nomidaitracker` を作成する。
- [ ] App IDとWidget App IDの両方にApp Groupを紐づける。
- [ ] Provisioning Profileが自動作成されることを確認する。

## App Store Connect

- [ ] 新規アプリを作成する。
- [ ] Bundle ID `com.momi0216yama.nomidaitracker` を選択する。
- [ ] カテゴリをファイナンスに設定する。
- [ ] 年齢制限を17+に設定する。
- [ ] アプリ説明、サブタイトル、キーワードを入力する。
- [ ] スクリーンショット5枚を登録する。
- [ ] Review Notesに `AppStore/review-notes.md` の内容を入力する。
- [ ] サポートURL、利用規約URL、プライバシーポリシーURLを入力する。
- [ ] プライバシー回答を「データ収集なし」に設定する。
- [ ] Privacy ManifestのRequired Reason APIがApp/Widget bundleに含まれることを確認する。
- [ ] 輸出コンプライアンス回答を確認する。
- [ ] IAP商品 `nomidai.pro.lifetime` と `nomidai.pro.monthly` を作成する。
- [ ] IAP商品の価格、説明、審査情報を入力する。

## GitHub Pages / 法務ページ

- [ ] GitHubリポジトリ `momiyama-AI/nomidai-tracker` を作成する。
- [ ] ローカルリポジトリにremoteを追加してpushする。
- [ ] GitHub Actionsの `iOS CI` が成功する。
- [ ] リポジトリ名またはPages URLをアプリ内URLと合わせる。
- [ ] Pages公開元を `docs` に設定する。
- [ ] `https://momiyama-ai.github.io/nomidai-tracker/terms` を開けることを確認する。
- [ ] `https://momiyama-ai.github.io/nomidai-tracker/privacy` を開けることを確認する。
- [ ] `https://momiyama-ai.github.io/nomidai-tracker/support` を開けることを確認する。

詳細手順は `AppStore/github-pages.md` を参照。

## Xcode / TestFlight

- [ ] `xcodebuild test` が成功する。
- [ ] XcodeでArchiveを作成する。
- [ ] Archive OrganizerからValidateする。
- [ ] TestFlightへアップロードする。
- [ ] TestFlightでインストールできることを確認する。
- [ ] 購入、復元、CSV共有、Widget表示、記録編集/削除を確認する。

## 審査メモ

本アプリは酒類に関する支出記録アプリです。健康改善、節酒、禁酒、依存症治療を目的とせず、データは端末内に保存されます。サーバー、外部API、アカウント登録、広告トラッキングはありません。
