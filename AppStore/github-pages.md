# GitHub Pages 公開手順

最終更新日: 2026年7月3日

アプリ内リンクとApp Store Connectに登録する利用規約、プライバシーポリシー、サポートページを公開するための手順です。

## 前提

現在のアプリ内URLは以下を参照しています。

- `https://momiyama-ai.github.io/nomidai-tracker/terms/`
- `https://momiyama-ai.github.io/nomidai-tracker/privacy/`
- `https://momiyama-ai.github.io/nomidai-tracker/support/`

このURLのまま使う場合、GitHubリポジトリ名は `nomidai-tracker` にします。別名のリポジトリにする場合は、`NomidaiTracker/Supporting/LegalLinks.swift` とApp Store ConnectのURLを同じ値に更新してください。

## 手順

1. GitHubで `momiyama-AI/nomidai-tracker` リポジトリを作成する。
2. ローカルリポジトリにremoteを追加する。

```sh
bash scripts/push-github.sh
```

3. GitHubのリポジトリ画面で `Settings > Pages` を開く。
4. `Build and deployment` の `Source` を `Deploy from a branch` にする。
5. `Branch` を `master`、フォルダを `/docs` にして保存する。
6. 数分後に以下のURLが開けることを確認する。

- `https://momiyama-ai.github.io/nomidai-tracker/`
- `https://momiyama-ai.github.io/nomidai-tracker/terms/`
- `https://momiyama-ai.github.io/nomidai-tracker/privacy/`
- `https://momiyama-ai.github.io/nomidai-tracker/support/`

または、macOS/クラウドMac上で以下を実行する。

```sh
bash scripts/verify-pages.sh
```

## App Store Connectへ入力するURL

- サポートURL: `https://momiyama-ai.github.io/nomidai-tracker/support/`
- プライバシーポリシーURL: `https://momiyama-ai.github.io/nomidai-tracker/privacy/`
- 利用規約URL: `https://momiyama-ai.github.io/nomidai-tracker/terms/`

## 注意

Pages公開後にリポジトリ名やGitHubアカウント名を変えるとURLが変わります。その場合はアプリ内リンク、App Store Connect、スクリーンショット説明、提出メモのURLをすべて揃えてください。
