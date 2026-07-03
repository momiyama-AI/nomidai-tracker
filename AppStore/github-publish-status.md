# GitHub公開状況

最終更新日: 2026年7月3日

## 完了済み

- GitHubリポジトリ作成: `momiyama-AI/nomidai-tracker`
- 公開URL: `https://github.com/momiyama-AI/nomidai-tracker`
- Git remote: `https://github.com/momiyama-AI/nomidai-tracker.git`
- 初回push: `master` ブランチ

## 実行済みコマンド

```sh
git remote add origin https://github.com/momiyama-AI/nomidai-tracker.git
git push -u origin master
```

## 次に必要な作業

1. GitHub Actionsの `iOS CI` が成功することを確認する。
2. GitHub Pagesの公開元を `master` ブランチの `docs` フォルダに設定する。
3. `bash scripts/verify-pages.sh` で以下URLが開けることを確認する。
   - `https://momiyama-ai.github.io/nomidai-tracker/terms/`
   - `https://momiyama-ai.github.io/nomidai-tracker/privacy/`
   - `https://momiyama-ai.github.io/nomidai-tracker/support/`

GitHub Pagesを有効化すると、App Store Connectとアプリ内リンクで利用する法務ページが公開されます。
